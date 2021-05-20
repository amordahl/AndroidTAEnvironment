import argparse
from Flow import Flow
from collections import namedtuple
delim = ","
parser = argparse.ArgumentParser()
parser.add_argument("--header", action="store_true", default=True)
parser.add_argument("--groundtruths")
parser.add_argument("--results", nargs="+")
args = parser.parse_args()
import logging
logging.basicConfig(level=logging.INFO)
import os

if (args.header):
    if args.groundtruths is not None:
        print(f'apk{delim}generating_script{delim}num_flows{delim}time{delim}total_TP{delim}detected_TP{delim}total_FP{delim}detected_FP') #adds the header
    else:
        print(f"apk{delim}generating_script{delim}num_flows{delim}time")

import xml.etree.ElementTree as ET

for r in args.results:
    tree = ET.parse(r)
    root = tree.getroot()
    time = root.get("time")
    
    try:
        numflows = int(len(root[0]))
    except IndexError as ie:
        numflows = 0

    tokens = r.replace('apk_config_', f'apk{delim}config_').split(delim)
    apk = tokens[0]
    config = tokens[1]
    #logging.info(f'{args.result}')
    if args.groundtruths is not None:
        total_TP = 0
        total_FP = 0
        detected_FP = 0
        detected_TP = 0
        
        # start verifying the flows
        # We now need to add some extra fields
        foundFlows = []
        gd_root = ET.parse(args.groundtruths).getroot()
        try:
            flows = [Flow(f) for f in root[0]]
        except IndexError as ie:
            flows = []
        gd_flows = [Flow(f) for f in gd_root]
        for f in gd_flows:
            if os.path.basename(f.get_file()) == os.path.basename(apk): #check if we are in the right apk
                classification_result = f.element.find('classification').text # get the classificaiton
                if classification_result.lower() == 'true': #if true
                    total_TP += 1 #increment total tp
                    if f in flows:
                        detected_TP += 1 #if our flow is this flow, detected tp +1
                        foundFlows.append(namedtuple("true",f))
                elif classification_result.lower() == 'false': #if false
                    total_FP += 1 #incremen total fp
                    if f in flows:
                        detected_FP += 1 # if our flow is this flow, detected fp +1
                        foundFlows.append(namedtuple("false",f))
        print(f"{apk}{delim}{config}{delim}{numflows}{delim}{time}{delim}{total_TP}{delim}{detected_TP}{delim}{total_FP}{delim}{detected_FP}{delim}{foundFlows}") #print the result
    else:
        print(f"{apk}{delim}{config}{delim}{numflows}{delim}{time}")

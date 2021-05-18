import argparse
from Flow import Flow

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
        print(f'apk{delim}generating_script{delim}num_flows{delim}time{delim}total_TP{delim}detected_TP{delim}total_FP{delim}detected_FP')
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
        
        # We now need to add some extra fields
        gd_root = ET.parse(args.groundtruths).getroot()
        try:
            flows = [Flow(f) for f in root[0]]
        except IndexError as ie:
            flows = []
        gd_flows = [Flow(f) for f in gd_root]
        for f in gd_flows:
            if os.path.basename(f.get_file()) == os.path.basename(apk):
                classification_result = f.element.find('classification').text
                if classification_result.lower() == 'true':
                    total_TP += 1
                    if f in flows:
                        detected_TP += 1
                elif classification_result.lower() == 'false':
                    total_FP += 1
                    if f in flows:
                        detected_FP += 1
        print(f"{apk}{delim}{config}{delim}{numflows}{delim}{time}{delim}{total_TP}{delim}{detected_TP}{delim}{total_FP}{delim}{detected_FP}")
    else:
        print(f"{apk}{delim}{config}{delim}{numflows}{delim}{time}")

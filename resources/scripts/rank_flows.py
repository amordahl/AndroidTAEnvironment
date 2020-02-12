import os
import logging
from tqdm import tqdm
logging.basicConfig(level=logging.WARNING)

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("input", help="The input file")
parser.add_argument("output", help="The output file")
args = parser.parse_args()

import xml.etree.ElementTree as ET

def reference_matches(reference):
    classname = reference.findall("classname")[0].text
    app = reference.findall("app")[0]
    f = app.findall("file")[0].text
    apk = os.path.basename(f)
    package_name = apk.split("_")[0]
    if classname.startswith(package_name):
        logging.info(f"I think I found a match! classname is {classname}, and file is {f}")
        return True


tree = ET.parse(args.input)
root = tree.getroot()
newRoot = ET.Element("flows")
newTree = ET.ElementTree(newRoot)

print("Processing records....")
num_flows = 0
flows = root
for flow in tqdm(flows):
    num_flows += 1
    # reference is flow[0]
    if reference_matches(flow[0]) and reference_matches(flow[1]):
        newRoot.append(flow)
        
print(f"Done! {len(newRoot)} flows matched out of {num_flows}.")
newTree.write(args.output)

    

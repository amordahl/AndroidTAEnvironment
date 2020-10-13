import argparse
parser = argparse.ArgumentParser("deduplicate a file of xml flow reports")
parser.add_argument("input", help="undeduplicated xml file")
parser.add_argument("output", help="output xml file")
args = parser.parse_args()

import logging
import os
logging.basicConfig(level=logging.WARNING)
import xml.etree.ElementTree as ET
from Flow import Flow
from tqdm import tqdm


# Read input file
tree = ET.parse(args.input)
root = tree.getroot()

result = set()
for f in tqdm(root):
    flow = Flow(f)
    result.add(flow)
result = sorted(result)

print(f"Finished deduplicating. In total, {len(result)} flows are unique.")
print(f"Writing to file...")
newRoot = ET.Element("flows")
newTree = ET.ElementTree(newRoot)
for r in tqdm(result):
    newRoot.append(r.element)

newTree.write(args.output)

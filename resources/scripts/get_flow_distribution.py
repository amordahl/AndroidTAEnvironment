from Flow import Flow
import os
import xml.etree.ElementTree as ET

import argparse
parser = argparse.ArgumentParser("get distribution of flows among files")
parser.add_argument("input")
args = parser.parse_args()

root = ET.parse(args.input).getroot()

configs = dict()

flows = [Flow(f) for f in root]
for f in flows:
    gc = f.element.get("generating_config")
    if gc not in configs:
        configs[gc] = dict()
    apk = f.get_file()
    if apk not in configs[gc]:
        configs[gc][apk] = 1
    else:
        configs[gc][apk] += 1

for k,v in configs.items():
    print(f"{k}")
    for k1, v1, in v.items():
        print(f"\t{k1}: {v1}")

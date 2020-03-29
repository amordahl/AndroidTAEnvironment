from Flow import Flow
import xml.etree.ElementTree as ET

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("file1")
parser.add_argument("file2")
parser.add_argument("output")
args = parser.parse_args()

flows_file_1 = [Flow(f) for f in ET.parse(args.file1).getroot()]
flows_file_2 = [Flow(f) for f in ET.parse(args.file2).getroot()]

final = flows_file_1
for f in flows_file_2:
    if f not in final:
        final.append(f)

newflows = ET.Element("flows")
newtree = ET.ElementTree(newflows)
for f in final:
    newflows.append(f.element)

newtree.write(args.output)

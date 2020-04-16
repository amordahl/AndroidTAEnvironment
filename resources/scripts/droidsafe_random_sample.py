import argparse
from Flow import Flow
import random
import xml.etree.ElementTree as ET

parser = argparse.ArgumentParser()
parser.add_argument("input")
parser.add_argument("output")
parser.add_argument("--seed")
args = parser.parse_args()

# get flows
root = ET.parse(args.input).getroot()
flows = [Flow(f) for f in root]

# compute counts:
counts = dict()
for f in flows:
    if f.get_file() not in counts:
        counts[f.get_file()] = 0
    counts[f.get_file()] += 1

already_looked_at = list()

new_flows = ET.Element("flows")
new_tree = ET.ElementTree(new_flows)

#init random generator
if args.seed is not None:
    random.seed(args.seed)

for f in flows:
    if f.get_file() not in already_looked_at:
        if counts[f.get_file()] <= 50:
            # add all
            k = [g for g in flows if g.get_file() == f.get_file()]
        else:
            # sample
            k = random.sample([g for g in flows if g.get_file() == f.get_file()], 50)
        [new_flows.append(g.element) for g in k]
        already_looked_at.append(f.get_file())

print(f"{len(new_flows)} flows sampled")

new_tree.write(args.output)

            
                 

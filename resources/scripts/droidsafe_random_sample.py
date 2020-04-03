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

apks_to_not_sample = ["org.dyndns.sven",
                      "com.github.yeriomin",
                      "ru.henridellal.dialer",
                      "pt.isec.tp.am",
                      "org.tuxpaint",
                      "daniel_32",
                      "anupam.acrylic"]
already_looked_at = list()

new_flows = ET.Element("flows")
new_tree = ET.ElementTree(new_flows)

#init random generator
if args.seed is not None:
    random.seed(args.seed)

for f in flows:
    if f.get_file() not in already_looked_at:
        if True in [f.get_file().startswith(a) for a in apks_to_not_sample]:
            # add all
            k = [g for g in flows if g.get_file() == f.get_file()]
        else:
            # sample
            k = random.sample([g for g in flows if g.get_file() == f.get_file()], 50)
        [new_flows.append(g.element) for g in k]
        already_looked_at.append(f.get_file())

if len(new_flows) != 408:
    raise RuntimeError("Wrong number of flows")

new_tree.write(args.output)

            
                 

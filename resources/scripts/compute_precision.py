import xml.etree.ElementTree as ET
from Flow import Flow
import argparse
p = argparse.ArgumentParser()
p.add_argument("-c", "--classifications")
p.add_argument("-i", "--input")
p.add_argument("--header", action="store_true")
import os
args = p.parse_args()

if args.header:
    print("file,num_matches,num_true,num_false,precision")
    exit(0)

# Read in classifications file
if args.classifications is None:
    raise ValueError("Need to supply classifications file.")
ctree = ET.parse(args.classifications)
croot = ctree.getroot()
cs = [Flow(f) for f in croot]

# Read in input
if args.input is None:
    raise ValueError("Need to supply input.")
itree = ET.parse(args.input)
iroot = itree.getroot().find('flows')
inputs = list(set([Flow(f) for f in iroot])) if iroot is not None else []  # do this to deduplicate

overlap = [c for c in cs if c in inputs]
num_true = [c for c in overlap if
            c.element.find("classification").find('result').
            text.upper().startswith('TRUE')]
num_false = [c for c in overlap if
             c.element.find("classification").find('result')
             .text.upper().startswith('FALSE')]
if len(num_false) == 0 and len(num_true) == 0:
    precision = 0
else:
    precision = float(len(num_true)) / float(len(num_false)+len(num_true))

print(f"{os.path.basename(args.input)},{len(overlap)},{len(num_true)},"
      f"{len(num_false)},{precision}")

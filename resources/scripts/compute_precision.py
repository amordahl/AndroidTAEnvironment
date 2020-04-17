import xml.etree.ElementTree as ET
from Flow import Flow
import argparse
p = argparse.ArgumentParser()
p.add_argument("-c", "--classifications")
p.add_argument("-i", "--input")
p.add_argument("--header", action="store_true")
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
iroot = itree.getroot()
inputs = list(set([Flow(f) for f in iroot]))  # do this to deduplicate

overlap = [c for c in cs if c in inputs]
num_true = [c for c in overlap if
            c.element.find("classification").find('result').
            text.upper().startswith('TRUE')]
num_false = [c for c in overlap if
             c.element.find("classification").find('result')
             .text.upper().startswith('FALSE')]
precision = float(num_true) / float(num_false+num_true)

print(f"{args.input},{len(overlap)},{len(num_true)},"
      f"{len(num_false)},{precision}")

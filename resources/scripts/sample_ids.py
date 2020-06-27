import math
import xml.etree.ElementTree as ET
import os
import random
import argparse
import numpy as np
from functools import cmp_to_key
p = argparse.ArgumentParser()
p.add_argument("input")
p.add_argument("seed", type=int)
p.add_argument("output_prefix")
p.add_argument("--splits", default=3, type=int)
p.add_argument("--threshold", "-t", help="Sample if the number of flows"
               " in an apk is greater than this.", default=-1, type=int)
p.add_argument("-s", "--sample", action="store_true")

args = p.parse_args()

tree = ET.parse(args.input)
root = tree.getroot()

random.seed(args.seed)

# Since we don't want to split each app's flows, or at least avoid that as
# much as possible, we will split each id by apk and then shuffle by apk, and then recombine
# so the ids are still in order by apk but shuffled.
        
ids = dict()
for r in root:
    apk_iter = r.iter("file")
    apk = next(apk_iter).text
    if apk not in ids:
        ids[apk] = list()
    ids[apk].append(r.get('id'))

# Now ids is a dict where each key is an apk, and each value is a list of matching ids.
# We also make a master list upon which we will split.
master = list()
for k, v in ids.items():
    random.shuffle(v)
    # Sample flows if needed
    if args.threshold > -1 and len(v) > args.threshold:
        sample = v[0:args.threshold]
    else:
        sample = v
    for v1 in sample:
        master.append((k, v1))


files = list()

def compare(x, y):
    if x[0] == y[0]:
        return int(x[1].split('-')[1]) - int(y[1].split('-')[1])
    else:
        if x[0] < y[0]: return -1
        else: return 1

arrs = np.array_split(master, args.splits)
for ix, a in enumerate(arrs):
    with open(f"{args.output_prefix}_{args.seed}_{ix}.txt", "w") as outfile:
        apk = ""
        for apki, idi in sorted(a, key=cmp_to_key(compare)):
            if apki != apk:
                # only print the apk when needed
                apk = apki
                outfile.write(f"{apk}\n")
            outfile.write(f"\t{idi}\n")
        outfile.write(f"\n")

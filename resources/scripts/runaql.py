import argparse

parser = argparse.ArgumentParser()
parser.add_argument("config")
parser.add_argument("apk")
args = parser.parse_args()

# create output file
import os
b = os.path.basename(args.config)
output = f"{args.apk}_{b}"

# check if it exists
if not os.path.exists(output):
    import subprocess
    cmd = ["./run_aql.sh", args.config, args.apk, output]
    import timeit
    t = timeit.timeit(stmt=f"subprocess.run({cmd})", setup="import subprocess", number=1) * 1000
    
    import xml.etree.ElementTree as ET
    tree = ET.parse(output)
    root = tree.getroot()
    root.set("time", str(t))
    
    tree.write(output)
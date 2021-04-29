import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument("config")
parser.add_argument("apk")
parser.add_argument("--outputdir", help="Directory to put the results in. Default is the same directory as the APK.")
parser.add_argument('-f', '--force', help='force to overwrite log file if it already exists.', action='store_true')
args = parser.parse_args()

# create output file
import os
b = os.path.basename(args.config)
if args.outputdir is None:
    output = f"{args.apk}_{b}"
else:
    os.makedirs(args.outputdir, exist_ok=True)
    output = f"{args.outputdir}/{os.path.basename(args.apk)}_{b}"

# check if it exists
if not os.path.exists(output) or args.force:
    import subprocess
    cmd = ["./run_aql.sh", args.config, args.apk, output]
    import timeit
    t = timeit.timeit(stmt=f"subprocess.run({cmd})", setup="import subprocess", number=1) * 1000
    
    import xml.etree.ElementTree as ET
    tree = ET.parse(output)
    root = tree.getroot()
    root.set("time", str(t))
    
    tree.write(output)

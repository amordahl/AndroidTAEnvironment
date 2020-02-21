import argparse

delim = ";"
parser = argparse.ArgumentParser()
parser.add_argument("--result")
parser.add_argument("--header", action="store_true")
args = parser.parse_args()
import logging
logging.basicConfig(level=logging.DEBUG)

if (args.header):
    print(f"apk{delim}config{delim}num_flows{delim}time")
else:
    import xml.etree.ElementTree as ET

    tree = ET.parse(args.result)
    root = tree.getroot()
    time = root.get("time")
    
    try:
        numflows = int(len(root[0]))
    except IndexError as ie:
        numflows = 0

    print(f"{args.result.replace('apk_config_', f'apk{delim}config_')}{delim}{numflows}{delim}{time}")

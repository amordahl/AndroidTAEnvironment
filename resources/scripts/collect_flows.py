from tqdm import tqdm
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("output_file")
parser.add_argument("results_list", help="A file with the list of files to read")
args = parser.parse_args()

import logging
logging.basicConfig(level=logging.WARNING)
import xml.etree.ElementTree as ET
sizes = list()
flows = ET.Element("flows")
with open(args.results_list) as infile:
    for f in tqdm(infile):
        tree = ET.parse(f.strip())
        root = tree.getroot()
        if len(root) > 0:
            for g in root[0]:
                sizes.append(len(flows))
                config_file = f.replace("apk_config", "apk;config").split(";")[1].strip()
                logging.debug(f"config_file = {config_file}")
                g.set("generating_config", config_file)
                flows.append(g)

logging.debug(sizes)
tree = ET.ElementTree(flows)
tree.write(args.output_file)

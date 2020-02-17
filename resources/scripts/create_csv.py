import os
import argparse
import copy
import csv
import logging
logging.basicConfig(level=logging.DEBUG)

parser = argparse.ArgumentParser()
parser.add_argument("config_file", help="config file produced by parse_nist_file.py")
parser.add_argument("output", help="output_file")
parser.add_argument("--repetitions", help="number of times to print each row (useful for pasting two csvs together)", default=1, type=int)
args = parser.parse_args()

configs = list()
config_master = dict()
file_index = 0
with open(args.config_file) as f:
    for line in f:
        tokens = [t.strip() for t in line.split(" ")]
        tokens = [t for t in tokens if not (t.isspace() or t == '')]
        logging.debug(f"{tokens}")
        config = copy.deepcopy(config_master)
        config["file"] = file_index
        file_index += 1
        for (ix,t) in enumerate(tokens):
            logging.debug(f"({ix}, {t})")
            if t.startswith("--"):
                if t not in config_master:
                    # need to update config_master and backpropagate the field to all previous
                    #  configs
                    
                    # is it a binary or value option?
                    if tokens[ix+1].startswith("--"):
                        # binary, so all previous configs should have "FALSE" as default
                        config_master[t] = "FALSE"
                        for c in configs:
                            c[t] = "FALSE"
                    else:
                        # value option, so all previous configs should have "DEFAULT" as default
                        # TODO: add dict to lookup default values
                        config_master[t] = "DEFAULT"
                        for c in configs:
                            c[t] = "DEFAULT"
                if tokens[ix+1].startswith("--"):
                    config[t] = "TRUE"
                else:
                    config[t] = tokens[ix+1]
        configs.append(config)

# sanity check
# all dicts should have the same length now
logging.info(f"Processing done. {len(configs)} configs found.")
lengths = set([len(c) for c in configs])
assert len(lengths) == 1

# write to file
with open(args.output, 'w') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=configs[0].keys())
    writer.writeheader()
    for c in configs:
        for i in range(1, args.repetitions):
            writer.writerow(c)

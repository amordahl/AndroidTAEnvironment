import argparse
import logging
logging.basicConfig(level=logging.WARNING)
parser = argparse.ArgumentParser("Program to parse NIST files into command-line configurations.")
parser.add_argument("input", help="Input file")
parser.add_argument("output", help="Output file")
args = parser.parse_args()

# Open input
configs_string = list()
with open(args.input) as infile:
    config = ""
    for f in infile:
        logging.debug(f"line is {f}")
        if f[0].isnumeric():
            tokens = f.split('=')
            if tokens[2].strip() == "FALSE":
                continue # don't include command line parameters that are false
            config += f'--{tokens[1].strip()}{f" {tokens[2].strip()}" if tokens[2].strip() != "TRUE" else ""} ' # add parameter name
            logging.debug(f"config is {config}")
        elif config != "":
            configs_string.append(config)
            config = ""
            logging.debug(f"configs_string is {configs_string}")

with open(args.output, 'w') as outfile:
    for c in configs_string:
        outfile.write(c)
        outfile.write('\n')
    

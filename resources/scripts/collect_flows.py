from tqdm import tqdm
from Flow import Flow
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("output_file")
parser.add_argument("results_list", help="A file with the list of files to read")
parser.add_argument("--filter", help="Filter out less precise results", action="store_true")
parser.add_argument("--tool", help="Tool that generated the flows.", choices=["flowdroid", "droidsafe", "amandroid"])
parser.add_argument("--precision_function", default="./precision_function.json",
                    help="precision function in a json file")
args = parser.parse_args()

if args.filter and args.tool is None:
    raise RuntimeError("If filter is turned on, a tool must be provided.")

import logging
logging.basicConfig(level=logging.DEBUG)
import json
import xml.etree.ElementTree as ET
sizes = list()
flows = ET.Element("flows")
with open(args.results_list) as infile:
    for f in tqdm(infile):
        logging.debug(f)
        tree = ET.parse(f.strip())
        root = tree.getroot()
        if len(root) > 0:
            for g in root[0]:
                sizes.append(len(flows))
                config_file = f.replace("apk_config", "apk;config").split(";")[1].strip()
                logging.debug(f"config_file = {config_file}")
                g.set("generating_config", config_file)
                flows.append(g)

# if args.filter:
#     to_keep = ET.Element("flows")
#     to_discard = ET.Element("to_discard")
    
#     print("Now filtering out less precise flows")
#     def extract_option(f : Flow):
#         logging.debug("Extracting generating config")
#         gen_config = f.element.get("generating_config")
#         option = gen_config.split('_')[-1].split('.')[0]
#         logging.debug(f"{option} extracted from {gen_config}")
#         return option

#     def extract_value(o, option):
#         param = option.replace(o["option_name"], '')
#         if param == '':
#             # this is just a true/false value.
#             value = "true"
#         else:
#             value = param
#         logging.debug(f"Value of {option} is {value}")
#         return value

#     def more_precise(values, v1, v2):
#         """ Return whether v1 is more precise than v2 """
#         v1_match = -1
#         v2_match = -1

#         for (i,v) in enumerate(values):
#             if v1 == v:
#                 v1_match = i
#             if v2 == v:
#                 v2_match = i
#             if v == "*":
#                 # only allow "*" matches if not yet matched
#                 v1 = i if v1 == -1 else v1
#                 v2 = i if v2 == -1 else v2

#         return v1 > v2
                
#     with open(args.precision_function) as infile:
#         pf = json.load(infile)
        
#     for f in tqdm([Flow(flow) for flow in flows]):
#         option = extract_option(f)
#         # First, check if we have a function defined for this.
#         for o in pf[args.tool]:
#             if o["option_name"] in option:
#                 value = extract_value(o, option)
#                 # Then this is defined. Next, determine if this is the most precise report.
#                 # walk through the values and find the matching position.
#                 match = -1
#                 for (i,v) in enumerate(o["values"]):
#                     if str(v) == value:
#                         match = i
#                         break
#                 if match == -1:
#                     for (i,v) in enumerate(o["values"]):
#                         # second pass: match to any "*"
#                         if v == "*":
#                             match = i
#                 if match == -1:
#                     logging.debug(f"Parameter {value} is not defined in precision function. Keeping this flow.")
#                     to_keep.append(f.element)
#                 else:
#                     if match == len(o["values"] - 1):
#                         logging.debug(f"Parameter {value} is the most precise value. Keeping this flow.")
#                         to_keep.append(f.element)
#                     else:
#                         # now, we have to go through the files and find any file with flows more precise than this one.
#                         with open(args.results_list) as results_list:
#                             for r in results_list:
#                                 logging.debug(f"Now looking at file {r}")
#                                 match = False
#                                 r_option = extract_option(r)
#                                 for r_o in pf[args.tool]:
#                                     if r_o["option_name"] in r_option:
#                                         if r_o["option_name"] == o["option_name"]:
#                                             match = True
#                                 if match:
#                                     logging.debug(f"File {r} is the same option as {option}")
#                                     r_value = extract_value(r_o, r_option)
#                                     if more_precise(r_o["values"], r_value, value):
#                                         logging.debug(f"File {r} has more precise flows than {option}")
#                                         # get flows in r
#                                         r_root = ET.parse(r).getroot()
#                                         for r_flow in r_root[0]:
#                                             r_flow = Flow(r_flow)
#                                             if r_flow == f
                                            

                                
                                
                    
logging.debug(sizes)
tree = ET.ElementTree(flows)
tree.write(args.output_file)

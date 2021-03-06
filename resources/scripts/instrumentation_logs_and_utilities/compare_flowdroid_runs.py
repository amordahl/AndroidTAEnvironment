### Austin Mordahl
### 2021-02-26

from typing import List, Set, Tuple
import re
import os
import logging
from csv import DictWriter
SUPPORTED_STRUCTURES = ['callbackMethods',
                        'incoming',
                        'methodSinks',
                        'methodSideEffects',
                        'callgraphEdges']
import argparse
p = argparse.ArgumentParser()
p.add_argument('--list1',
               help='The first list of files.',
               nargs='+',
               type=str,
               required=True)
p.add_argument('--list2',
               help="""The second list of files.
               IMPORTANT: Files from the two lists will be paired
               in the order they are given. For example, giving 
               --list1 A B C and --list2 D E F will pair A and D, 
               B and E, and C and F.""",
               nargs='+',
               type=str,
               required=True)
p.add_argument('output', help='The output CSV file.')
p.add_argument('--structures',
               help='Structures to track and record.',
               nargs='+',
               type=str,
               choices=SUPPORTED_STRUCTURES,
               default=SUPPORTED_STRUCTURES)
p.add_argument('-v', '--verbose',
               help='Level of verbosity.',
               action='count', default=0)
args = p.parse_args()

# Setup Logging
if args.verbose < 1: # 0 
    logging.basicConfig(level = logging.CRITICAL)
elif args.verbose < 2:
    logging.basicConfig(level = logging.WARN)
elif args.verbose < 3:
    logging.basicConfig(level = logging.INFO)
else:
    logging.basicConfig(level = logging.DEBUG)


def open_file(f: str, strip_newlines: bool = True) -> Tuple[str]:
    """ Open a file and return its contents. """
    with open(f) as in_file:
        content = in_file.readlines() if not strip_newlines \
            else [l.strip() for l in in_file.readlines()]

    return tuple(content)

def find_num_flows(content: List[str]) -> int:
    """Finds the number of flows reported"""
    return int(content[-1].split(' ')[-2])

cache = dict()
def find_datastructure(content: Tuple[str], dataStructure: str) -> Set[str]:
    """
    Finds the given structure, and returns it.
    and returns it.
    """
    if f'{hash(content)}_{dataStructure}' in cache:
        return cache[f'{hash(content)}_{dataStructure}']
    
    result = []
    for line in content:
        ix = line.find('-')
        second_half = line[ix+1:len(line)].strip()
        if not second_half.startswith(f'{dataStructure}:'):
            continue
        else:
            full_list = re.search(r"{.*}", second_half).group()
            elements = re.findall(r"<<<<<.+?>>>>>", full_list)
            if len(elements) == 0:
                continue
            try:
#                result = set([(e.split(',')[0].strip('[]'), e.split(',')[1].strip('[]')) for e in elements])
                result = set(elements)
            except:
                logging.critical(f'Could not parse the collection {dataStructure} on line {line}.')
                result = []
    logging.debug(f'Returning result {frozenset(result)}')
    cache[f'{hash(content)}_{dataStructure}'] = frozenset(result)
    return frozenset(result)

# check different keys
def get_different_positions(coll1, coll2, pos) -> int:
    coll1_keys = set([k[pos] for k in coll1])
    coll2_keys = set([k[pos] for k in coll2])
    return len(coll1_keys.union(coll2_keys) - coll1_keys.intersection(coll1_keys))

def get_different_keys(coll1, coll2) -> int:
    return get_different_positions(coll1, coll2, 0)

def get_different_values(coll1, coll2) -> int:
    return get_different_positions(coll1, coll2, 1)
        
def get_null_keys(coll) -> int:
    """ Iterate through map and get the number of
    keys that are <null>"""
    logging.info(f'coll: {coll}')
    keys = [k for k,v in coll if k == '<null>']
    logging.info(f'keys: {keys}')
    return len(keys)

def collect_flows(lines):
    """Collects the flows and collects them into a set of tuples."""
    current_sink = None
    flows = []
    for l in lines:
        if l.startswith('[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - The sink'):
            current_sink = l
        elif l.startswith('[main] INFO soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow - Data flow solver'):
            logging.debug(f'Returning from collecting flows. Flows are {flows}.')
            break
        elif current_sink == None:
            continue
        else:
            logging.debug(f'Appending flow. Flow is {(current_sink, l)}')
            flows.append((current_sink, l)) #l is a source
    return frozenset(flows)
            
def main() :
    #1. Read in files.
    if len(args.list1) != len(args.list2):
        logging.critical(f'list1 and list2 need to be the same length. '\
                         f'list1 is {len(list1)} elements, and list2 is '\
                         f'{len(list2)} elements.')
        exit(1)

    file_lists = [args.list1, args.list2]
    logging.info('Opening files.')
    files = [{f: open_file(f) for f in l} for l in file_lists]
    logging.info(f'Files read in successfully.')
        # Parse data structures.
    logging.info(f'Now reading in data structures.')
    structures = [{f: {s: find_datastructure(files[x][f], s) for s in args.structures}\
                      for f in files[x].keys()} for x in range(len(files))]
    
    # Print to csv.
    base_dict={'file': None,
               'partner': None,
               'num_flows': None,
               'flows_equal': None,
               'this_subset_partner': None,
               'this_superset_partner': None,}
    for s in args.structures:
        base_dict[f'length_{s}'] = None
        base_dict[f'equal_{s}'] = None
        base_dict[f'this_{s}_minus_partner'] = None
        base_dict[f'partner_{s}_minus_this'] = None

    lines = []
    for i in range(len(args.list1)):
        # This is a little convoluted, but j is just an array giving the necessary elements to
        # construct the entry, so that we don't have to have a bunch of if-conditions
        # to write the line for entries from list1 and list2.
        for j in [0]:
            entry = base_dict.copy()
            f_this = file_lists[j][i]
            f_partner = file_lists[(j+1)%2][i]
            entry['file'] = f_this
            entry['partner'] = f_partner
            entry['num_flows'] = len(collect_flows(files[j][f_this]))
            entry['flows_equal'] = collect_flows(files[j][f_this]) == collect_flows(files[(j+1)%2][f_partner])
            entry['this_subset_partner'] = collect_flows(files[j][f_this]).issubset(
                collect_flows(files[(j+1)%2][f_partner]))
            entry['this_superset_partner'] = collect_flows(files[j][f_this]).issuperset(
                collect_flows(files[(j+1)%2][f_partner]))
            for s in args.structures:
                entry[f'length_{s}'] = len(find_datastructure(files[j][f_this], s))
                entry[f'equal_{s}'] = find_datastructure(files[j][f_this], s) == \
                    find_datastructure(files[(j+1)%2][f_partner], s)
                entry[f'this_{s}_minus_partner'] = find_datastructure(files[j][f_this], s) -\
                    find_datastructure(files[(j+1)%2][f_partner], s)
                entry[f'partner_{s}_minus_this'] = find_datastructure(files[(j+1)%2][f_partner], s) -\
                    find_datastructure(files[j][f_this], s)
                entry[f'difference_{s}_overall'] = len(find_datastructure(files[j][f_this], s).union(find_datastructure(files[(j+1)%2][f_partner], s)) - find_datastructure(files[j][f_this], s).intersection(find_datastructure(files[(j+1)%2][f_partner], s)))
            lines.append(entry)

    if os.path.exists(args.output):
        exists = True
    else:
        exists = False

    with open(args.output,'a') as out:
        writer = DictWriter(out, fieldnames=lines[0].keys(), dialect='excel-tab')
        if not exists:
            writer.writeheader()
        [writer.writerow(e) for e in lines]

if __name__ == '__main__':
    main()

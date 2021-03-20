### Austin Mordahl
## 2021-02-26

from typing import List, Set, Tuple, Dict
from tqdm import tqdm
from multiprocessing import Pool
from threading import Lock
from functools import partial
import re
import os
import logging
from csv import DictWriter
import xml.etree.ElementTree as ET
import argparse
p = argparse.ArgumentParser()
p.add_argument('--list1',
               help="""The first list of files. Note that violations are computed
               based on a subset relation. Anything where list1's flows are not a subset
               of list2's flows is a violation. This means that list1 should either be from 
               the more precise option (in the case of a precision partial order) or from the less
               sound option (in the case of a soundness partial order).""",
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
p.add_argument('--output', help='The output CSV file.')
p.add_argument('-v', '--verbose',
               help='Level of verbosity.',
               action='count', default=0)
p.add_argument('-j', '--jobs', default=8)
p.add_argument('-b', '--benchmark_directory', help="""The directory in which the benchmarks are stored.""")
p.add_argument('--partial_order', '-p', help="""Which partial order this represents (only used if strategy is ground_truth).""",
               choices=['soundness', 'precision'],
               default='soundness')
p.add_argument('--metric', '-m', help='The metric to calculate whether two structures are equal.',
               choices=['last_log', 'superset'],
               default='last_log')
p.add_argument('--strategy', '-s', help="""Whether to use the subset or ground truth strategy.""",
               choices=['set', 'ground_truth'],
               default='set')
p.add_argument('--unknown_as_fp', help="""Treat unknowns as false positives.""", action='store_true')
p.add_argument('--wei_transform', '-w', help="""Apply Dr. Wei's transformation. Specify which configuration is buggy.""", choices=[0, 1], type=int)
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
    logging.debug(f'Finding datastructure {dataStructure}')
    if f'{hash(content)}_{dataStructure}' in cache:
        return cache[f'{hash(content)}_{dataStructure}']
    
    result = []
    for line in content:
        ix = line.find('-')
        second_half = line[ix+1:len(line)].strip()
        logging.debug(f'second half is {second_half}')
        if not second_half.startswith(dataStructure):
            continue
        else:
            logging.debug(f'Found data structure {dataStructure} in line {line}.')
            full_list = re.search(r"{.*}", second_half).group()
            elements = re.findall(r"<<<<<.+?>>>>>", full_list)
            if len(elements) == 0:
                continue
            try:
                result.append(set(elements))
            except:
                logging.critical(f'Could not parse the collection {dataStructure} on line {line}.')
                
    logging.debug(f'Returning result {result}')
    cache[f'{hash(content)}_{dataStructure}'] = result
    return result

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
            current_sink_begin = current_sink.find('The sink') + len('The sink')
            current_sink_end = current_sink.find('in method') - 1
            sink = current_sink[current_sink_begin:current_sink_end].strip(' ')
            source_begin = l.find('- -') + len('- -')
            source_end = l.find('in method') - 1
            source = l[source_begin:source_end].strip(' ')
            logging.info(f'Appending flow. Flow is {(sink, source)}')
            flows.append((source,sink))
    logging.info(f'Found {len(flows)} flows.')
    return frozenset(flows)

def is_true_positive(apk: str, source: str, sink: str) -> bool:
    """ Returns whether a flow is a true or false positive. """
    # 1. Find the files that correspond to this apk.

    if args.benchmark_directory is None:
        raise RuntimeError('Benchmark directory must be specified. Please run again with the -b flag.')
    benchmark_files = []
    for root, dirs, files in os.walk(args.benchmark_directory):
        for f in files:
            if os.path.basename(apk).replace('.apk.log', '.xml') in f:
                benchmark_files.append(os.path.join(root, f))

    # Now, benchmark_files has all of the relevant benchmarks.
    for f in benchmark_files:
        root = ET.parse(f).getroot()
        for flow in root[0].findall('flow'):
            match_count = 0
            for r in flow.findall('reference'):
                if r.get('type') == 'to':
                    source_or_sink = sink
                else:
                    source_or_sink = source

                # Find the statement.
                if r.find('statement').find('statementgeneric').text in source_or_sink:
                    logging.info(f'is_true_positive: {r.find("statement").find("statementgeneric").text} is in {source_or_sink}')
                    match_count += 1
                else:
                    logging.info(f'is_true_positive: {r.find("statement").find("statementgeneric").text} is not in {source_or_sink}')

            if match_count < 2:
                # This is not a match
                continue
            else:
                if '_tp_' in f:
                    logging.info(f'Found flow {source} -> {sink} in {f}.')
                    return True
                elif '_fp_'in f:
                    logging.info(f'Found flow {source} -> {sink} in {f}.')
                    return False
                else:
                    raise RuntimeError(f'Could not determine whether {f} is a true or false postiive.')
    logging.critical(f'Could not find flow with source {source} and sink {sink} for APK {apk}.')
    if args.unknown_as_fp:
        return False
    else:
        return None
        

def add_structures(content: List[str]) -> Set[str]:
    """ Given a list of lines from a file, return the structures that 
    are defined in that file."""
    structures = set()
    for c in content:
        # Scan for lines that start with loggerhelper.
        logger = 'LoggerHelper'
        if logger in c:
            # lines look like this
            # [FlowDroid] INFO soot.jimple.infoflow.util.LoggerHelper - soot.jimple.infoflow.methodSummary.taintWrappers.SummaryTaintWrapper:776 res {[{NULL}]}
            try:
                log = '-'.join(c.split('-')[1:]).strip()
                struct = ' '.join([log.split(' ')[0], log.split(' ')[1]])
            except Exception as ex:
                logging.critical(f'Could not parse {c}')
                raise ex
            logging.info(f'Found structure {struct}.')
            structures.add(struct)
    return structures

def get_entry(base_dict: Dict[str, str],
              file_lists: List[List[str]],
              files: List[Dict[str, List[str]]],
              structures: Set[str],
              i: int) -> Dict[str, str]:
    """
    Given a base dictionary, all of the files, and an index,
    create the entry for it.
    """
    j = 0
    entry = base_dict.copy()
    f_this = file_lists[j][i]
    f_partner = file_lists[(j+1)%2][i]
    f_this_flows = collect_flows(files[j][f_this])
    f_partner_flows = collect_flows(files[(j+1)%2][f_partner])

    entry['file'] = f_this
    entry['partner'] = f_partner
    entry['num_flows'] = len(f_this_flows)
    entry['flows_equal'] = f_this_flows == f_partner_flows
    entry['this_subset_partner'] = f_this_flows.issubset(f_partner_flows)
    entry['this_superset_partner'] = f_this_flows.issuperset(f_partner_flows)

    if args.strategy == 'ground_truth':
        f_this_flows_groundtruths = [(f, is_true_positive(f_this, f[0], f[1])) for f in f_this_flows]
        logging.info(f'{f_this} has {len([e for e in f_this_flows_groundtruths if e[1]])} true positives and {len([e for e in f_this_flows_groundtruths if not e[1]])} false positives.')
        f_partner_flows_groundtruths = [(f, is_true_positive(f_partner, f[0], f[1])) for f in f_partner_flows]
        logging.info(f'{f_partner} has {len([e for e in f_partner_flows_groundtruths if e[1]])} true positives and {len([e for e in f_partner_flows_groundtruths if not e[1]])} false positives.')
        entry['this_true_positives'] = frozenset([k for k,v in f_this_flows_groundtruths if v == True])
        entry['partner_true_positives'] = frozenset([k for k,v in f_partner_flows_groundtruths if v == True])
        entry['this_false_positives'] = frozenset([k for k,v in f_this_flows_groundtruths if not v == False])
        entry['partner_false_positives'] = frozenset([k for k,v in f_partner_flows_groundtruths if not v == False])
    
    for s in structures:
        ds1 = find_datastructure(files[j][f_this], s)
        ds2 = find_datastructure(files[(j+1)%2][f_partner], s)

        # o1 and o2 are what to compare.
        o1 = None
        o2 = None
        if args.metric == 'last_log':
            # we compare the last element of each list.
            o1 = ds1[-1] if ds1 != [] else []
            o2 = ds2[-1] if ds2 != [] else []
        elif args.metric == 'superset':
            ds1_set = set()
            ds2_set = set()
            for se in ds1:
                ds1_set.update(se)
            for se in ds2:
                ds2_set.update(se)
            o1 = ds1_set
            o2 = ds2_set
        if args.wei_transform is not None:
            # We apply the following formula, assuming that B is the buggy configuration.
            # [if the data structure is accessed in B’s execution, 1; otherwise, 0] *
            #  [if the data structure is different in B than A, 1; otherwise, 0].
            if args.wei_transform == 0:
                # This is the buggy configuration.
                entry[f'equal_{s}'] = (len(o1) > 0) and (o1 == o2)
            else:
                entry[f'equal_{s}'] = (len(o2) > 0) and (o1 == o2)
        else:
            entry[f'equal_{s}'] = (o1 == o2)
    return entry

def main() :
    # Read in files.
    if len(args.list1) != len(args.list2):
        logging.critical(f'list1 and list2 need to be the same length. '\
                         f'list1 is {len(args.list1)} elements, and list2 is '\
                         f'{len(args.list2)} elements.')
        exit(1)

    file_lists = [args.list1, args.list2]
    files = [{f: open_file(f) for f in l} for l in file_lists]
    # Parse data structures.
    logging.info('Collecting data structures.')

    # First pass through all files is to collect all data structures.
    structures = set()

    # Flatten files (a list of dicts) into a list of the file
    # contents, so that it can be passed to p.map()
    content_list = []
    for l in files:
        for k,v in l.items():
            content_list.append(v)
    p = Pool(args.jobs)
    all_structures = p.map(add_structures, content_list)
    for a in all_structures:
        structures.update(a)
    logging.info('First pass done.')
    
    # Print to csv.
    base_dict={'file': None,
               'partner': None,
               'num_flows': None,
               'flows_equal': None,
               'this_subset_partner': None,
               'this_superset_partner': None}
    if args.strategy == 'ground_truth':
        base_dict['this_true_positives'] = None
        base_dict['partner_true_positives'] = None
        base_dict['this_false_positives'] = None
        base_dict['partner_false_positives'] = None
    for s in structures:
        base_dict[f'equal_{s}'] = None

    lines = []
    logging.info('Collecting data structures.')

    # Get entries in parallel.
    lines = list()
    for i in range(len(args.list1)):
        entry = get_entry(base_dict, file_lists, files, structures, i)
        lines.append(entry)

    # compute suspiciousness
    suspiciousness = []
    logging.info('Now comparing data structures and computing suspiciousness.')
    for s in tqdm(structures):
        logging.info(f'structure: {s}')
        if args.strategy == 'set':
            successful = len([e for e in lines if not e[f'equal_{s}'] and e['this_subset_partner']])
            failed = len([e for e in lines if not e[f'equal_{s}'] and not e['this_subset_partner']])
            total_successful = len([e for e in lines if e['this_subset_partner']])
            total_failed = len([e for e in lines if not e['this_subset_partner']])

            logging.info(f'successful: {successful}')
            logging.info(f'failed: {failed}')
            logging.info(f'total_successful: {total_successful}')
            logging.info(f'total_failed: {total_failed}')

            try:
                suspiciousness.append( (s,
                                        1 - ((float(successful) / total_successful) / \
                                             ( (float(successful) / total_successful) + (float(failed) / total_failed)))
                ))
            except ZeroDivisionError as ex:
                logging.critical(f'Suspiciousness for {s} could not be computed because of '
                                 f'division by zero error: successful={successful}, failed={failed}, '
                                 f'total_successful={total_successful},total_failed={total_failed}')
                suspiciousness.append( (s, 'N/A') )
                
        elif args.strategy == 'ground_truth':
            if args.partial_order == 'soundness':
                # Find the flows that are in the less sound but not more sound configuration.
                successful = len([e for e in lines if not e[f'equal_{s}'] and e['this_true_positives'].issubset(e['partner_true_positives'])])
                failed = len([e for e in lines if not e[f'equal_{s}'] and not e['this_true_positives'].issubset(e['partner_true_positives'])])
                total_successful = len([e for e in lines if e['this_true_positives'].issubset(e['partner_true_positives'])])
                total_failed = len([e for e in lines if not e['this_true_positives'].issubset(e['partner_true_positives'])])
                
                logging.info(f'successful: {successful}')
                logging.info(f'failed: {failed}')
                logging.info(f'total_successful: {total_successful}')
                logging.info(f'total_failed: {total_failed}')
                
                try:
                    suspiciousness.append( (s, e['file'], e['partner'],
                                            1 - ((float(successful) / total_successful) / \
                                                 ( (float(successful) / total_successful) + (float(failed) / total_failed))),
                                            successful, failed, total_successful, total_failed
                    ))
                except ZeroDivisionError as ex:
                    logging.critical(f'Suspiciousness for {s} could not be computed because of '
                                     f'division by zero error: successful={successful}, failed={failed}, '
                                     f'total_successful={total_successful},total_failed={total_failed}')
                    suspiciousness.append( (s, e['file'], e['partner'], 'N/A', successful, failed, total_successful, total_failed) )

            elif args.partial_order == 'precision':
                # Compute suspiciousness for each errant flow.
                successful = len([e for e in lines if not e[f'equal_{s}'] and e['this_false_positives'].issubset(e['partner_false_positives'])])
                failed = len([e for e in lines if not e[f'equal_{s}'] and not e['this_false_positives'].issubset(e['partner_false_positives'])])
                total_successful = len([e for e in lines if e['this_false_positives'].issubset(e['partner_false_positives'])])
                total_failed = len([e for e in lines if not e['this_false_positives'].issubset(e['partner_false_positives'])])

                logging.info(f'successful: {successful}')
                logging.info(f'failed: {failed}')
                logging.info(f'total_successful: {total_successful}')
                logging.info(f'total_failed: {total_failed}')
                
                try:
                    suspiciousness.append( (s, e['file'], e['partner'],
                                            1 - ((float(successful) / total_successful) / \
                                                 ( (float(successful) / total_successful) + (float(failed) / total_failed))),
                                            successful, failed, total_successful, total_failed
                    ))
                except ZeroDivisionError as ex:
                    logging.critical(f'Suspiciousness for {s} could not be computed because of '
                                     f'division by zero error: successful={successful}, failed={failed}, '
                                     f'total_successful={total_successful},total_failed={total_failed}')
                    suspiciousness.append( (s, e['file'], e['partner'], 'N/A', successful, failed, total_successful, total_failed) )
                    
            for s, fi, partner, score in sorted(suspiciousness, key=lambda s: s[-1] if isinstance(s[-1], float) else -1 , reverse=True):
                print(f'{args.partial_order},{os.path.dirname(fi).strip(./)}/{os.path.dirname(partner).strip(./)},{fi},{partner},{s},{score}')

            
    if args.strategy == 'set':
        suspiciousness = sorted(suspiciousness, key=lambda s: s[-1] if isinstance(s[-1], float) else -1 , reverse=True)
        for s in suspiciousness:
            print(f'{s[0]}: {s[1]}')
            
    if args.output is not None:
        if os.path.exists(args.output):
            exists = True
        else:
            exists = False
            
        with open(args.output,'a') as out:
            writer = DictWriter(out, fieldnames=lines[0].keys(), dialect='excel-tab')
            if not exists:
                writer.writeheader()
            for e in lines:
                writer.writerow(e)

if __name__ == '__main__':
    main()

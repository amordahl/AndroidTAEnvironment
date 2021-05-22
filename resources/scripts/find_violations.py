import logging
logging.basicConfig(level = logging.DEBUG)

from xml import ElementTree as ET
from Flow import Flow
from Configuration import Configuration
from typing import List, Dict
from csv import DictReader
import pickle
import argparse
p = argparse.ArgumentParser()
p.add_argument('groundtruths',
               help="""The file in AQL-Answer format that stores \
               the ground truths embedded as <classification> tags.""")
p.add_argument('config-file',
               help="""The CSV file mapping configuration
               names to their configurations.""")
p.add_argument('files', required=True, nargs='+')
p.add_argument('--write_files', action='store_true',
               help="""If enabled, we will overwrite result files \
               with the classifications.""")
p.add_argument('--verify_classifications', action='store_true',
               help="""If enabled, the script will check \
               any existing classification tags for correctness \
               and fix any errors. Otherwise, it will simply \
               skip checking classifications for any flow \
               that already has groundtruths.""")
p.add_argument('--data_directory', default='../checkmate/data')
               help="""The directory in which checkmate's model files \
               are stored.""")
p.add_argument('--tool', default='flowdroid', choices=['flowdroid','droidsafe'],
               help="""The tool that we are checking for violations in.""")
p.add_argument('--dataset', default='fossdroid', choices=['fossdroid', 'droidsafe'],
               help="""The dataset these reports are from.""")
args = p.parse_args()

def check_args():
    """
    Sanity checks for arguments. Throws exceptions if any arguments are
    incorrect.
    """
    if len(args.files) <= 1:
        raise RuntimeError('Must supply at least two files.')
    if args.tool != 'flowdroid':
        raise RuntimeError('Currently this tool only supports FlowDroid.')
    if args.dataset != 'fossdroid':
        raise RuntimeError('Currently this tool only supports FossDroid.')

def add_classifications(groundtruths: str, files: List[str],
                        verify_classifications: bool, write_files: bool) -> Dict[str, Flow]:
    """
    Opens the groundtruths and flow file and adds in classifications.
    """
    # Open the groundtruths
    groundtruths : List[Flow] = [Flow(f) for f in ET.parse(args.groundtruths).getroot().iter('flow')]
    
    # Open each file.
    files_to_flows : Dict[str, List[Dict]] = dict()
    for f: str in args.files:
        # Save the root 
        root : ElementTree.Element = ET.parse(f).getroot()
        files_to_flows[f] : List[Flow] = [Flow(f) for f in root.iter('Flow')]

        # Go through each flow and check if it already
        #  has classifications.
        for f : str in files_to_flows[f]
            if f_as_flow.get_classification() is not None and\
               not verify_classifications:
                # unless verify_classifications is on,
                #  we will just skip these.
                continue
            if f not in groundtruths:
                logging.critical(f'Flow with source and sink {f.get_source_and_sink()} '
                                 'is not in groundtruths.')
            else:
                # Add in the classification
                gt : Flow = groundtruths[groundtruths.index(f)]
                classifications : List[ElementTree.Element] = [e for e in gt.iter('classification')]
                if len(classifications) > 1:
                    id : int = gt[0].get('id')
                    if id is not None:
                        raise RuntimeError(f'Groundtruth with id {id} has more than '
                                           'one classification.')
                    else:
                        raise RuntimeError(f'A groundtruth with no id has more than '
                                           'one classification. That really stinks.')
                elif len(classifications) < 0:
                    id : int = gt[0].get('id')
                    if id is not None:
                        raise RuntimeError(f'Groundtruth with id {id} has no classification.')
                    else:
                        raise RuntimeError(f'A groundtruth with no id has no '
                                           'classification. That really stinks.')
                else:
                    f.add_classification(classifications[0].text)
        logging.info('Added all classifications.')
        if write_files:
            logging.critical('Writing files is not yet supported. Sorry!')

        logging.debug('Returning from add_classifications.')
        return files_to_flows

def get_option_under_investigation(k: str) -> str:
    """
    Takes the configuration name and returns the option
    that the configuration is investigating.
    """
    if k.startswith('config_'):
        k : str = k.replace('config_', '')
    if k.endswith('.xml'):
        k : str = k.replace('.xml', '')

    options_map = {
        'aliasalgofs' : 'aliasalgo',
        'aliasalgolazy' : 'aliasalgo',
        'aliasalgonone' : 'aliasalgo',
        'aliasalgoptsbased' : 'aliasalgo',
        'aliasflowins' : 'aliasflowins',
        'analyzeframeworks' : 'analyzeframeworks',
        'aplength1' : 'aplength',
        'aplength10' : 'aplength',
        'aplength2' : 'aplength',
        'aplength20' : 'aplength',
        'aplength3' : 'aplength',
        'aplength4' : 'aplength',
        'aplength5' : 'aplength',
        'aplength7' : 'aplength',
        'callbackanalyzerdef' : 'callbackanalyzer',
        'callbackanalyzerfast' : 'callbackanalyzer',
        'cgalgoauto' : 'cgalgo',
        'cgalgocha' : 'cgalgo',
        'cgalgogeom' : 'cgalgo',
        'cgalgorta' : 'cgalgo',
        'cgalgospark' : 'cgalgo',
        'cgalgovta' : 'cgalgo',
        'codeeliminationnone' : 'codeelimination',
        'codeeliminationpc' : 'codeelimination',
        'codeeliminationrc' : 'codeelimination',
        'dataflowsolvercsfs' : 'dataflowsolver',
        'dataflowsolverfins' : 'dataflowsolver',
        'enablereflection' : 'enablereflection',
        'implicitall' : 'implicit',
        'implicitarronly' : 'implicit',
        'implicitnone' : 'implicit',
        'maxcallbackchain0' : 'maxcallbacksdepth',
        'maxcallbackchain1' : 'maxcallbacksdepth',
        'maxcallbackchain100' : 'maxcallbacksdepth',
        'maxcallbackchain110' : 'maxcallbacksdepth',
        'maxcallbackchain120' : 'maxcallbacksdepth',
        'maxcallbackchain150' : 'maxcallbacksdepth',
        'maxcallbackchain200' : 'maxcallbacksdepth',
        'maxcallbackchain50' : 'maxcallbacksdepth',
        'maxcallbackchain600' : 'maxcallbacksdepth',
        'maxcallbackchain80' : 'maxcallbacksdepth',
        'maxcallbackchain90' : 'maxcallbacksdepth',
        'maxcallbacks1' : 'maxcallbackspercomponent',
        'maxcallbacks100' : 'maxcallbackspercomponent',
        'maxcallbacks110' : 'maxcallbackspercomponent',
        'maxcallbacks120' : 'maxcallbackspercomponent',
        'maxcallbacks150' : 'maxcallbackspercomponent',
        'maxcallbacks200' : 'maxcallbackspercomponent',
        'maxcallbacks50' : 'maxcallbackspercomponent',
        'maxcallbacks600' : 'maxcallbackspercomponent',
        'maxcallbacks80' : 'maxcallbackspercomponent',
        'maxcallbacks90' : 'maxcallbackspercomponent',
        'nocallbacks' : 'nocallbacks',
        'noexceptions' : 'noexceptions',
        'nothischainreduction' : 'nothischainreduction',
        'onecomponentatatime' : 'onecomponentatatime',
        'onesourceatatime' : 'onesourceatatime',
        'pathalgocontextinsensitive' : 'pathalgo',
        'pathalgocontextsensitive' : 'pathalgo',
        'pathalgosourcesonly' : 'pathalgo',
        'pathspecificresults' : 'pathspecificresults',
        'singlejoinpointabstraction' : 'singlejoinpointabstraction',
        'staticmodecsfs' : 'staticmode',
        'staticmodefins' : 'staticmode',
        'staticmodenone' : 'staticmode',
        'taintwrapperdefaultfallback' : 'taintwrapper',
        'taintwrappereasy' : 'taintwrapper',
        'taintwrappernone' : 'taintwrapper',
        'analyzestringsunfiltered' : 'analyzestringsunfiltered',
        'apicalldepth0' : 'apicalldepth',
        'apicalldepth1' : 'apicalldepth',
        'apicalldepth100' : 'apicalldepth',
        'apicalldepth110' : 'apicalldepth',
        'apicalldepth120' : 'apicalldepth',
        'apicalldepth150' : 'apicalldepth',
        'apicalldepth200' : 'apicalldepth',
        'apicalldepth50' : 'apicalldepth',
        'apicalldepth600' : 'apicalldepth',
        'apicalldepth80' : 'apicalldepth',
        'apicalldepth90' : 'apicalldepth',
        'filetransforms' : 'filetransforms',
        'ignoreexceptionflows' : 'ignoreexceptionflows',
        'ignorenocontextflows' : 'ignorenocontextflows',
        'implicitflow' : 'implicitflows',
        'imprecisestrings' : 'imprecisestrings',
        'kobjsens1' : 'kobjsens',
        'kobjsens18' : 'kobjsens',
        'kobjsens2' : 'kobjsens',
        'kobjsens3' : 'kobjsens',
        'kobjsens4' : 'kobjsens',
        'kobjsens5' : 'kobjsens',
        'kobjsens6' : 'kobjsens',
        'limitcontextforcomplex' : 'limitcontextforcomplex',
        'limitcontextforgui' : 'limitcontextforgui',
        'limitcontextforstrings' : 'limitcontextforstrings',
        'multipassfb' : 'multipassfb',
        'noarrayindex' : 'noarrayindex',
        'noclinitcontext' : 'noclinitcontext',
        'noclonestatics' : 'noclonestatics',
        'nofallback' : 'nofallback',
        'nojsa' : 'nojsa',
        'noscalaropts' : 'noscalaropts',
        'nova' : 'nova',
        'preciseinfoflow' : 'preciseinfoflow',
        'ptageo' : 'pta',
        'ptapaddle' : 'pta',
        'ptaspark' : 'pta',
        'transfertaintfield' : 'transfertaintfield',
        'typesforcontext' : 'typesforcontext'
    }

    if k not in options_map:
        raise RuntimeError(f'Cannot map {k} to the option under investigation.')
    else:
        return options_map[k]

def add_configurations(files_to_flows: Dict[str, List[Flow]],
                       settings_file: str) -> Dict[Configuration, Flow]:
    """
    Replaces the configuration name with a configuration object.
    """
    # Load in the settings.
    with open(settings_file) as f:
        reader : DictReader = DictReader(f)
        settings : Dict[str, Dict] = {r['generating_script']: r for r in reader}

    configurations_to_flows : Dict[Configuration, Flow] = dict()
        
    file: str
    files_to_flows: List[Flow]
    for file, flows in files_to_flows:
        candidates = {k,v for k,v in settings.items() if f'{k}.xml' in file}
        if len(candidates) > 1:
            raise RuntimeError(f'Found multiple matching settings for {file}.')
        elif len(candidates) == 0:
            raise RuntimeError(f'Could not find the configuration for {file}.')
        else: # len(candidates) == 1
            k : str
            v : Dict[str, Dict]
            for k, v in candidates.items(): # only one
                c = Configuration(get_option_under_investigation(k), v)
                configurations_to_flows[c] = flows

    return configurations_to_flows

def check_for_violations(configurations_to_flows: Dict[Configuration, List[Flow]],
                         tool: str, data_directory: str):
    """
    Opens the model file and checks for any violations.
    """
    
def main():
    # Check that the arguments are correct.
    check_args()
    logging.info('Argument sanity check passed.')

    files_to_flows: Dict[str, List[Flow]] = add_classifications(args.groundtruth, args.files,
                                                          args.verify_classifications,
                                                          args.write_files)

    configurations_to_flows: Dict[Configuration, List[Flow]] = add_configurations(files_to_flows)
        

if __name__ == '__main__':
    main()

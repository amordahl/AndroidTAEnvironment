import csv
import argparse
import logging
logging.basicConfig(level = logging.WARNING)
p = argparse.ArgumentParser("utility to add option settings to csv files.")
p.add_argument("csv_file")
p.add_argument("settings")
p.add_argument("output")
p.add_argument("--replication", default='1',
               help='which replication this represents.')

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

args = p.parse_args()

settings = list()
with open(args.settings) as f:
    reader = csv.DictReader(f)
    [settings.append(r) for r in reader]

records = list()
with open(args.csv_file) as f:
    reader = csv.DictReader(f)
    [records.append(r) for r in reader]

for r in records:
    config = r['generating_script']
    print(config)
    config_id = config.split('.')[-2].split('_')[-1].strip()
    for s in settings:
        setting_id = s['file'].split('_')[-1].strip(',')
        logging.debug(f'config_id = {config_id}, setting_id = {setting_id}')
        if config_id == setting_id:
            r.update(s)
    r['option_under_investigation'] = options_map[config_id]
    r['replication'] = args.replication
    if 'true_positive' in r:
        tp = r['true_positive'].lower() == 'true'
        sc = r['successful'].lower() == 'true'
        if tp and sc:
            r['tp'] = 1
            r['fp'] = 0
            r['tn'] = 0
            r['fn'] = 0
        if not tp and not sc:
            r['tp'] = 0
            r['fp'] = 1
            r['tn'] = 0
            r['fn'] = 0
        if tp and not sc:
            r['tp'] = 0
            r['fp'] = 0
            r['tn'] = 0
            r['fn'] = 1
        if not tp and sc:
            r['tp'] = 0
            r['fp'] = 0
            r['tn'] = 1
            r['fn'] = 0
    
with open(args.output, 'w') as f:
    writer = csv.DictWriter(f, fieldnames=records[0].keys())
    writer.writeheader()
    [writer.writerow(r) for r in records]

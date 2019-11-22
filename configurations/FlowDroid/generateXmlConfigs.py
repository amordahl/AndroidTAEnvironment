import argparse
parser = argparse.ArgumentParser()
parser.add_argument('tool_dir')
parser.add_argument('template_file')
parser.add_argument('config_prefix')
args = parser.parse_args()

import os

files_list = os.listdir(args.tool_dir)
files_list = [f for f in files_list if
              f.startswith('aqlRun') and f.endswith('.sh')]

template = ""
with open(args.template_file) as f:
    for l in f:
        template+=l

for f in files_list:
    content = template.replace("$$REPLACE$$", f)
    # assume that the file is named aqlRun_xxx.sh
    filestrip = f.lstrip("aqlRun").rstrip(".sh")
    with open(f'./{args.config_prefix}{filestrip}.xml', 'w') as g:
        g.write(content)


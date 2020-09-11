import argparse
parser = argparse.ArgumentParser()
parser.add_argument('config_dir')
parser.add_argument('template_file')
parser.add_argument('config_prefix')
parser.add_argument('output_dir')
args = parser.parse_args()

import os
import hashlib

files_list = list()
for root, dirs, files in os.walk(args.config_dir):
    for f in files:
        f = os.path.basename(f)
        if f.startswith('aqlRun') and f.endswith('.sh'):
            files_list.append(os.path.abspath(os.path.join(root, f)))

template = ""
with open(args.template_file) as f:
    for l in f:
        template+=l

template = template.replace("$ANDROID_TA_ENVIRONMENT_HOME", os.environ["ANDROID_TA_ENVIRONMENT_HOME"])
template = template.replace("$ANDROID_SDK_HOME", os.environ["ANDROID_SDK_HOME"])
for f in files_list:
    content = template.replace("%%REPLACE%%", f)
    hashval = hashlib.md5()
    hashval.update(content.encode())
    content = content.replace("%%HASH%%", hashval.hexdigest())
    # assume that the file is named aqlRun_xxx.sh
    filestrip = os.path.basename(f).replace("aqlRun", "").replace(".sh", "")
    with open(f'{args.output_dir}/{args.config_prefix}{filestrip}.xml', 'w') as g:
        g.write(content)


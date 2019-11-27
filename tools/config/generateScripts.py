import argparse
import os

parser = argparse.ArgumentParser()
parser.add_argument('template_file')
parser.add_argument('config_file')
parser.add_argument('output_dir')
parser.add_argument('--templatestring', default="%%REPLACE%%")
args = parser.parse_args()

template_file = args.template_file
template_string = args.templatestring

"""
Open the template and load in the contents.
"""
template = ""
with open(template_file) as f:
    for l in f:
        template += l

files_to_make = list()
with open(args.config_file, 'r') as f:
    for l in f:
        files_to_make.append(tuple(l.split(',')))

for fname, flags in files_to_make:
    content = template.replace(template_string, flags.strip())
    outfile = f'{args.output_dir}/aqlRun_{fname.strip()}.sh'
    with open(outfile, 'w') as f:
        f.write(content)
    os.chmod(outfile, 0o755)
    
        

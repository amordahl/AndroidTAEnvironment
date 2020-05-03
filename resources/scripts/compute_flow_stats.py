import argparse
from Flow import Flow
import xml.etree.ElementTree as ET
p = argparse.ArgumentParser('compute statistics for flows')

p.add_argument('classifications')
p.add_argument('results', nargs='*')

args = p.parse_args()

# First, find all of the true flows
root = ET.parse(p.classifications).getroot()


def is_true(f):
    classification = f.find('classification')
    result = classification.find('result')
    return result.text.upper() == 'TRUE'


trues = [Flow(f) for f in root if is_true(f)]

header = 'file'
id = 0
for t in trues:
    header = f'{header},{id}'
    id += 1

print(header)

for r in args.results:
    flows = [Flow(f) for f in ET.parse(r).getroot()]
    row = f'{r}'
    for t in trues:
        result = 0 if t not in flows else 1
        row = f'{row},{result}'
    print(row)

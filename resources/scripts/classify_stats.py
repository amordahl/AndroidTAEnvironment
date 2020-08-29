from Flow import Flow
import xml.etree.ElementTree as ET
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("input")
args=parser.parse_args()

flows = [Flow(f) for f in ET.parse(args.input).getroot()]

apks = dict()
for f in flows:
    if f.get_file() not in apks:
        apks[f.get_file()] = list()
    apks[f.get_file()].append(f)

global_classified=0
global_unclassified=0
global_types=dict()
for k, v in apks.items():
    classified = 0
    unclassified = 0
    types = dict()
    for f in v:
        try:
            result = f.element.find("classification")
            if result.text.strip() == "":
                raise AttributeError("empty result")
            if result.text.upper() not in types:
                types[result.text.upper()] = 0
            if result.text.upper() not in global_types:
                global_types[result.text.upper()] = 0
            types[result.text.upper()] += 1
            global_types[result.text.upper()] += 1
            classified += 1
            global_classified += 1
        except AttributeError:
            unclassified += 1
            global_unclassified += 1

    print(f"Apk: {k}\n\tClassified: {classified}\n"
          f"\tUnclassified: {unclassified}\n"
          "\tTypes:")
    [print(f"\t\t{k}: {v}") for k, v in types.items()]
    print("\n")

print(f"\nGlobal classified: {global_classified}")
print(f"\nGlobal unclassified: {global_unclassified}")
print(f"\nGlobal types:")
[print(f"\t{k}: {v}") for k, v in global_types.items()]

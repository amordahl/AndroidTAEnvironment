import argparse
parser = argparse.ArgumentParser("deduplicate a file of xml flow reports")
parser.add_argument("input", help="undeduplicated xml file")
parser.add_argument("output", help="output xml file")
args = parser.parse_args()

from typing import Dict
import logging
logging.basicConfig(level=logging.WARNING)
import xml.etree.ElementTree as ET
import re
from tqdm import tqdm

class Flow:

    register_regex = re.compile(r"\$[a-z]\d+")

    def __init__(self, element):
        logging.debug(f"Element is {element}")
        self.element = element
    
    # 1. Same file?
    def get_file(self) -> str:
        f = self.element[0].findall("app")[0].findall("file")[0].text
        logging.debug(f"Extracted file: {f}")
        return f

    # 2. Same source and sink?
    @classmethod
    def clean(cls, stmt: str) -> str:
        c = Flow.register_regex.sub("", stmt)
        logging.debug(f"Before clean: {stmt}\nAfter clean: {c}")
        return c
    
    def get_source_and_sink(self) -> Dict[str, str]:
        result = dict()
        references = self.element.findall("reference")
        logging.debug(f"References is {references}")
        source = [r for r in references if r.get("type") == "from"][0]
        sink = [r for r in references if r.get("type") == "to"][0]

        def get_statement_full(a: ET.Element) -> str:
            return a.find("statement").find("statementfull").text
        
        result["source"] = Flow.clean(get_statement_full(source))
        logging.debug(f"Source: {result}")
        result["sink"] = Flow.clean(get_statement_full(sink))
        return result

    def __eq__(self, other):
        """
        Return true if two flows are equal
            
        Criteria:
        1. Same apk.
        2. Same source and sink.
        """

        if not isinstance(other, Flow):
            return False
        else:
            return self.get_file() == other.get_file() and self.get_source_and_sink() == other.get_source_and_sink()

    def __hash__(self):
        sas = self.get_source_and_sink()
        return hash((self.get_file(), sas["source"], sas["sink"]))

# Read input file
tree = ET.parse(args.input)
root = tree.getroot()

result = set()
for f in tqdm(root):
    flow = Flow(f)
    result.add(flow)

print(f"Finished deduplicating. In total, {len(result)} flows are unique.")
print(f"Writing to file...")
newRoot = ET.Element("flows")
newTree = ET.ElementTree(newRoot)
for r in tqdm(result):
    newRoot.append(r.element)

newTree.write(args.output)

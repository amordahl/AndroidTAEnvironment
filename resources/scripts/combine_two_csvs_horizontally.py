import argparse
parser = argparse.ArgumentParser("combine two csvs horizontally.")
parser.add_argument("file1")
parser.add_argument("file2")
parser.add_argument("result")
parser.add_argument("--delim", default=";")
args = parser.parse_args()

with open(args.file1) as file1:
    with open(args.file2) as file2:
        if len(file1) != len(file2):
            raise RuntimeError(f"{file1} and {file2} are not the same length. Refusing to combine.")
        with open(args.result) as result:
            for i in range(0, len(file1)):
                result.write(f"{file1[i]}{delim}{file2[i]}")


import argparse

parser = argparse.ArgumentParser()
parser.add_argument('file')
args = parser.parse_args()

content = ""
with open(args.file) as f:
    for l in f:
        content += l

content = content.replace('soot.jimple.infoflow.android.SetupApplication$InPlaceInfoflow',
                          'soot.jimple.infoflow.Infoflow')

with open(args.file, 'w') as f:
    f.write(content)

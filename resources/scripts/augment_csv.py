import statistics
import logging
import csv
from typing import List
from tqdm import tqdm
from multiprocessing import Pool
from functools import partial
import argparse
p = argparse.ArgumentParser()
p.add_argument("csv_file")
p.add_argument("mode", choices=["droidbench", "rw"])
p.add_argument("output")
args = p.parse_args()

logging.basicConfig(level=logging.DEBUG)

records = list()
with open(args.csv_file) as f:
    reader = csv.DictReader(f)
    [records.append(r) for r in reader]

if args.mode == "rw":
    raise NotImplementedError("Haven't implemented this yet.")
else:
    class Record:
        def __init__(self, r):
            self.r = r

        def __eq__(self, o):
            try:
                return (o.r["apk"] == self.r["apk"] and
                        o.r["generating_script"] ==
                        self.r["generating_script"] and
                        o.r["replication"] == self.r["replication"])
            except KeyError:
                return (o.r["apk"] == self.r["apk"] and
                        o.r["generating_script"] ==
                        self.r["generating_script"])

    records = [Record(r) for r in records]

    def compute_num_true_pos(record: Record,
                             record_list: List[Record]) -> int:
        return sum([1 for r in filter(lambda r: r == record, record_list)
                    if (r.r["true_positive"] == "TRUE" and
                        r.r["successful"] == "TRUE")])

    def compute_num_false_pos(record: Record,
                              record_list: List[Record]) -> int:
        return sum([1 for r in filter(lambda r: r == record, record_list)
                    if (r.r["true_positive"] == "FALSE" and
                        r.r["successful"] == "FALSE")])

    def compute_num_false_neg(record: Record,
                              record_list: List[Record]) -> int:
        return sum([1 for r in filter(lambda r: r == record, record_list)
                    if (r.r["true_positive"] == "TRUE" and
                        r.r["successful"] == "FALSE")])

    logging.info("Starting to compute precision, recall, and f-measure")
    
    def process_record(records: List[Record], r: Record):
        num_tp = compute_num_true_pos(r, records)
        num_fp = compute_num_false_pos(r, records)
        num_fn = compute_num_false_neg(r, records)

        try:
            r.r["precision"] = float(num_tp) / float(num_tp + num_fp)
        except ZeroDivisionError:
            r.r["precision"] = 0

        try:
            r.r["recall"] = float(num_tp) / float(num_tp + num_fn)
        except ZeroDivisionError:
            r.r["recall"] = 0

        r.r["f-measure"] = statistics.harmonic_mean(
            [r.r["precision"], r.r["recall"]])

    prt = partial(process_record, records)
    logging.info("Processing records")
    with Pool(8) as p:
        p.map(prt, records)

    logging.info("Writing to output file....")

    with open(args.output, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=records[0].r.keys())
        writer.writeheader()
        [writer.writerow(r.r) for r in records]

    logging.info("Done writing.")

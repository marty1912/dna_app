#!/bin/python3
import json
import sys
import shutil
import os
import subprocess
import time
import csv
import json

import os


def flatten_json(y):
    out = {}

    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x

    flatten(y)
    return out


def main():

    if (len(sys.argv) != 2):
        print("invalid number of args. quitting...")
        print("sys argv:",sys.argv)
        quit()

    data_file = sys.argv[1]
    out_folder = "csv_data"
    if not os.path.exists(out_folder):
        os.makedirs(out_folder)
 
    with open(data_file) as jsonfile:
        data = json.load(jsonfile)

    trials = data['trials']
    for task_block in trials:
        if(not "name" in task_block):
            # skip the blocks without a name..
            continue
        csv_filename = task_block['name'] + ".csv"
        print(csv_filename)
        flat_trials = []
        task_trials= task_block['trials']
        for trial in  task_trials:
            flat_trial = {}
            for handler in trial:
                flat = flatten_json({handler['name']:handler})
                flat_trial = {**flat_trial , **flat}

            print("flat trial")
            print(flat_trial)
            flat_trials.append(flat_trial)
        output_file = open(os.path.join(out_folder,csv_filename),'w')
        csv_writer = csv.writer(output_file)

        # headers to the CSV file
        count = 0
  
        for emp in flat_trials:
            if count == 0:
                # Writing headers of CSV file
                header = emp.keys()
                csv_writer.writerow(header)
                count += 1
        
            # Writing data of CSV file
            csv_writer.writerow(emp.values())
  
        output_file.close()
        print("-"*80)


        

if __name__ == "__main__":
    main()
    

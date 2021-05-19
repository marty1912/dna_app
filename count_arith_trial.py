#!/bin/python3
import sys
import json


def getNumbersFromArithTrials(filename):
    with open(filename,"r") as jsonfile:
        jsondata = json.load(jsonfile)
    
    for block_index in range(0,len(jsondata)):
        block = jsondata[block_index]
        print("-"*80)
        print(block_index)
        print(block)
        print("-"*80)
    
    # we know from above that the trials come at index 4

    trials = jsondata[4]["trials"]
    numbers = []
    for trial in trials:
        numbers.append(trial[0]["params"]["solution"])
    print("have numbers:")
    print(numbers)
    return numbers




def main():
    arithmetic_filename = sys.argv[1]
    numbers = getNumbersFromArithTrials(arithmetic_filename)
    single_d = []
    double_d = []
    triple_d = []
    for num in numbers:
        if num >= 100:
            triple_d.append(num)
        elif num >= 10:
            double_d.append(num)
        else:
            single_d.append(num)
    print("single:",str(single_d))
    print("double:",str(double_d))
    print("triple:",str(triple_d))
    print("-"*80)
    print("single",len(single_d),"double",len(double_d),"triple",len(triple_d))


if __name__ == "__main__":
    main()
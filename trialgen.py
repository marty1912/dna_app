#!/bin/python3
import sys
import json
import shutil
import os
import subprocess
import time


from os import listdir
from os.path import isfile, join, basename ,splitext
from os import walk

def genSymbolicNumberCompareTrials(distances=[1,2,5,6],numbers=[1,2,3,4,5,6,7,8,9]):
    '''
    our output tells us that we have:
    have  8 for distance: 1
    have  7 for distance: 2
    have  4 for distance: 5
    have  3 for distance: 6
    so we use the distance 5 and 6 double to make it more balanced
    '''
    trials = []
    for dist in distances:
        dist_poss_count = 0
        for num in numbers:
            left_num = num
            right_num = num+dist
            solution = max(left_num,right_num)
            if (not left_num in numbers) or (not right_num in numbers):
                continue
            # append both directions
            trials.append([left_num,right_num,solution,dist])
            trials.append([right_num,left_num,solution,dist])
            dist_poss_count +=1
        print("have ",dist_poss_count,"for distance:",dist)
    return trials

def genOrdinalNumberVerificationTrials(distances=[1,2,3],numbers=[1,2,3,4,5,6,7,8,9]):
    '''
    our output tells us that we have:
    have  7 for distance: 1
    have  5 for distance: 2
    have  3 for distance: 3
    so we use the distance 3 ones double to make it more balanced
    '''
    trials = []

    for dist in distances:
        dist_poss_count = 0
        for num in numbers:
            left_num = num
            mid_num = num+dist
            right_num = num+2*dist
            solution = "IN_ORDER"
            if (not left_num in numbers) or (not mid_num in numbers) or (not right_num in numbers):
                continue
            # append both directions
            trials.append([left_num,mid_num,right_num,solution])
            trials.append([right_num,mid_num,left_num,solution])

            solution = "MIXED_ORDER"
            # ascending mixed
            trials.append([mid_num,right_num,left_num,solution])
            #descending mixed
            trials.append([mid_num,left_num,right_num,solution])
            dist_poss_count +=1
        print("have ",dist_poss_count,"for distance:",dist)
        


    return trials

def genNumLineTrials(ranges=[x for x in range(32,64+1,6)],targets=[x for x in range(4,32+1,3)]):
    '''
    our output tells us that we have:
    so we use the distance 3 ones double to make it more balanced
    '''
    trials = []

    for rang in ranges:
        for num in targets:
            trials.append([rang,num])

    return trials

def genAdditionTrials(numbers=[2,3,4,5,6,7,8,9]):
    '''
    '''
    trials = []

    for num_1 in numbers:
        for num_2 in numbers:
            if(num_1 == num_2):
                continue

            solution = num_1+num_2
            trials.append([num_1,num_2,solution])

    return trials







def insertListIntoTemplate(template_string,numbers_list):
    '''
    insertLIstIntoTemplate
    inserts a list into a template
    the template string needs to have the spots marked with INSERT_HERE_0,INSERT_HERE_1,...
    @ret the string with everything replaced.
    '''
    for index in range(0,len(numbers_list)):
        template_string = template_string.replace("INSERT_HERE_"+str(index),str(numbers_list[index]))
    return template_string







def main():

    if (len(sys.argv) != 3):
        print("invalid number of args. quitting...")
        print("sys argv:",sys.argv)
        quit()


    mode = sys.argv[1]
    if(mode == "symb"):
        trials = genSymbolicNumberCompareTrials()
    elif mode == "ord":
        trials = genOrdinalNumberVerificationTrials()
    elif mode == "numline":
        trials = genNumLineTrials()
    elif mode == "add":
        trials = genAdditionTrials()

    template_file = sys.argv[2]

    temp_string = ""
    with open(template_file) as tempfile:
        temp_string = tempfile.read()

    string_with_all_trials = ""
    for trial in trials:
        string_with_all_trials += insertListIntoTemplate(temp_string,trial)
    
    print(string_with_all_trials)
    






        

if __name__ == "__main__":
    main()
    

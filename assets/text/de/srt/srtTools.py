#!/bin/python3

import argparse
import srt
from datetime import datetime, timedelta

def allignSubs(sub_list,padding=timedelta(seconds = 0.1)):

    if(len(sub_list)<2):
        return sub_list

    print("alligning srt file now.")
    for sub_index in range(1,len(sub_list)):
        prev_sub = sub_list[sub_index-1]
        current_sub = sub_list[sub_index]
        cur_duration = current_sub.end - current_sub.start
        current_sub.start = prev_sub.end + padding
        current_sub.end = current_sub.start + cur_duration
        
    
    return sub_list
    


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("-a","--allign",help="keeps the subtitles duration and aligns them so there is no overlap.",
                action="store_true")
    parser.add_argument("-o","--output",help="output file.")
    parser.add_argument("input_file",help="the input file")
    args = parser.parse_args()

    # if no output is given we use the input file and override it..
    if not args.output:
        args.output = args.input_file

    file_string = ""
    with open(args.input_file,"r") as infile:
        file_string = infile.read()


    subtitle_gen = srt.parse(file_string)
    subs_list = list(subtitle_gen)

    if args.allign:
        subs_list = allignSubs(subs_list)
        
    #print(srt.compose(subs_list)) 
    # write to output:
    with open(args.output,"w") as outfile:
        outfile.write(srt.compose(subs_list))

        


if __name__ == "__main__":
    main()
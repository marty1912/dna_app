import pysrt
import sys
import json

"""
this script converts a srt subtitle file to json format so we can use it in our haxe program more easily.

"""

def getseconds(timepoint):
    return (timepoint.hours*3600) + (timepoint.minutes *60) + timepoint.seconds + (timepoint.milliseconds / 1000)

def main():
    if (len(sys.argv) != 3):
        print("usage: ",sys.argv[0]," <inputfile>.srt", "outputfile.json")
        return
    inpath = sys.argv[1]
    outpath = sys.argv[2]

    srt_file = pysrt.open(sys.argv[1])
    
    json_list = []
    for  entry in srt_file:
        json_entry = {"t_start":getseconds(entry.start),
        "t_end":getseconds(entry.end),
        "text":entry.text
        }
        json_list.append(json_entry)
    
    

    with open(outpath, "w") as outfile:  
        json.dump(json_list, outfile) 



    

if __name__ == "__main__":
    main()
    
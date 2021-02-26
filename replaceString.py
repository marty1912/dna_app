import sys
import json


from os import listdir
from os.path import isfile, join, basename ,splitext
from os import walk
import sys

if __name__ == "__main__":
    if (len(sys.argv) != 3):
        print("invalid number of args. quitting...")
        quit()
    replace_string = sys.argv[1]
    replace_in_file = sys.argv[2]
    
    str_replace_in_file = ""
    with open(replace_in_file) as tempfile:
        str_replace_in_file = tempfile.read()
    input_string = sys.stdin.readlines()
    input_string = ''.join(input_string)
    print("input:",input_string)
    
        
    str_replace_in_file = str_replace_in_file.replace(replace_string,input_string)


    print(str_replace_in_file)
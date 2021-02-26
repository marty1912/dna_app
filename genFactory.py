import sys
import json


from os import listdir
from os.path import isfile, join, basename ,splitext
from os import walk



def getFilesList(path):
    files_list = [f for f in listdir(path) if isfile(join(path, f))]
    f = []
    for (dirpath, dirnames, filenames) in walk(path):
        for file in filenames:
            total_path = dirpath+ "/"+file
            total_path = total_path.replace("//","/")
            f.append(total_path)
    
    return f

if __name__ == "__main__":
    if (len(sys.argv) != 4):
        print("invalid number of args. quitting...")
        quit()
    template_else_if_filename = sys.argv[1]
    template_file = sys.argv[2]
    folder_path = sys.argv[3]
    file_list = getFilesList(folder_path)
    temp_string = ""
    with open(template_file) as tempfile:
        temp_string = tempfile.read()
    else_if_temp = ""
    with open(template_else_if_filename) as tempfile:
        else_if_temp = tempfile.read()
    
    for file_path in file_list:
        
        base = basename(file_path)
        split = splitext(base)
        without_ext = split[0]
        # if the string is already in our file we dont need to do anything.
        if(file_path in temp_string):
            continue
        
        my_if = else_if_temp.replace("STATE_NAME",without_ext)
        my_if = my_if.replace("PATH_TO_JSON",file_path)
        
        temp_string = temp_string.replace("INSERT_HERE",my_if)


    print(temp_string)
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
    template_file = sys.argv[1]
    states_folder_path = sys.argv[2]
    test_folder_path = sys.argv[3]
    file_list = getFilesList(states_folder_path)

    temp_string = ""

    with open(template_file) as tempfile:
        temp_string = tempfile.read()
    

    for file_path in file_list:
        
        base = basename(file_path)
        split = splitext(base)
        without_ext = split[0]
        test_name = test_folder_path + "/" + without_ext+"TEST.hx"
        # if the string is already in our file we dont need to do anything.
        if(file_path in temp_string):
            continue
        
        file_content = temp_string.replace("INSERT_HERE",without_ext)

        #print("will create new test:")
        #print(test_name)
        #print("with content:")
        #print(file_content)
        f = open(test_name,"w")
        f.write(file_content)
        f.close()

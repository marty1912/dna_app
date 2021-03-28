import sys
import json
import shutil
import os
import subprocess
import time


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

def getFolderListWithout(path,exclude_paths = ["test","export",".git"]):
    paths_list = []
    project_files = listdir(path)
    for path in project_files:
        ignore = False
        for ex_path in exclude_paths:
            if ex_path in path:
                ignore = True
                break
        if ignore:
            continue
        paths_list.append(path)
    return paths_list

def main():
    if (len(sys.argv) != 4):
        print("invalid number of args. quitting...")
        print("sys argv:",sys.argv)
        quit()
    project_folder = sys.argv[1]
    test_folder = sys.argv[2]
    testbed_folder = sys.argv[3]
    tests_list = getFilesList(test_folder)
    shutil.rmtree(testbed_folder)
    os.makedirs(testbed_folder)
    project_paths = getFolderListWithout(project_folder,["test","export",".git",".vscode"])
    for path in project_paths:
        print("copying:_",path)
        if os.path.isfile(path):
            shutil.copy(path,testbed_folder)
        else:
            folder_name = os.path.basename(path)
            shutil.copytree(path,testbed_folder+"/"+folder_name)

    working_dir = os.getcwd()

    neko_bin_dir = "./export/neko/bin/"
    for test in tests_list:
        os.chdir(working_dir)

        shutil.copy(test,testbed_folder+"/source/Main.hx")
        os.chdir(testbed_folder)

        # use the test as our main 
        output = ""
        # build the test
        subprocess.run(["lime","build","neko"])

        os.chdir(neko_bin_dir)

        process = subprocess.Popen(["./DNA"],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        time.sleep(3)
        print("now killing subprocess")
        process.terminate()
        out, err_out = process.communicate()
        print("killed subprocess")
        if len(err_out) != 0:
            print("output was:",out)
            print("error output was:",err_out)







        

if __name__ == "__main__":
    main()
    
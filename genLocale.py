import sys
import json


from os import listdir
from os.path import isfile, join, basename ,splitext
def getTranslationMapString(path):
    
    files_list = [f for f in listdir(path) if isfile(join(path, f))]
    map_string = ""
    
    
    map_string += "[\n"
    for i in range(0,len(files_list)):
        filename = files_list[i]
        base = basename(filename)
        split = splitext(base)
    
        without_ext = split[0]
        relative_path = path+ base
        line = ""
        line += "\""
        line += without_ext
        line += "\""
        line += " => "
        line += "ConfigFile.text(\"{0}\")".format(relative_path)
            
        if i != len(files_list) -1:
            line += ","
        
        
        map_string += line + '\n'        

    
    map_string += "];\n" 
    return map_string


if __name__ == "__main__":
    if (len(sys.argv) != 4):
        print("invalid number of args. quitting...")
        quit()
    template_filename = sys.argv[1]
    folder_path_text = sys.argv[2]
    folder_path_audio = sys.argv[3]
    my_trans_map = getTranslationMapString(folder_path_text)
    my_audio_map = getTranslationMapString(folder_path_audio).replace("ConfigFile.text","")
    with open(template_filename) as tempfile:
        temp_string = tempfile.read()
        temp_string = temp_string.replace("INSERT_TEXT_MAP_HERE",my_trans_map)
        temp_string = temp_string.replace("INSERT_AUDIO_MAP_HERE",my_audio_map)
        print(temp_string)
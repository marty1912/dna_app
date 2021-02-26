import sys
import json

def getSlotMappingString(path):
    with open(path) as f:
        content = json.load(f)
        map = []
        tex_list = content["SubTexture"]
        for i in range(0,len(tex_list)):
            map.append((tex_list[i]["name"],i))
        print(map)
        print("now showing you the map to copy and paste:")
        print("[")
        for i in range(0,len(map)):
            line = ""
            line += "\""
            line += map[i][0]
            line += "\""
            line += " => "
            line += str(i)
            
            if i != len(map) -1:
                line += ","
            print(line)
                

        print("];")



if __name__ == "__main__":
    if (len(sys.argv) != 2):
        print("invalid number of args. quitting...")
        quit()
    getSlotMappingString(sys.argv[1])
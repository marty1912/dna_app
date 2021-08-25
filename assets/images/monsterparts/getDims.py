import struct
from os import walk
from os.path import basename
import os.path 
from PIL import Image

import argparse
import imghdr
from resizeimage import resizeimage

def resize_to(filename,width,height):
    print("resize",filename,"to:",width,"x",height)
    with open(filename, 'r+b') as f:
        with Image.open(f) as image:
            cover = resizeimage.resize_crop(image, [width, height],validate=False)
            cover.save(filename, image.format)



def get_image_size(fname):
    '''Determine the image type of fhandle and return its size.
    from draco'''
    with open(fname, 'rb') as fhandle:
        head = fhandle.read(24)
        if len(head) != 24:
            return
        if imghdr.what(fname) == 'png':
            check = struct.unpack('>i', head[4:8])[0]
            if check != 0x0d0a1a0a:
                return
            width, height = struct.unpack('>ii', head[16:24])
        elif imghdr.what(fname) == 'gif':
            width, height = struct.unpack('<HH', head[6:10])
        elif imghdr.what(fname) == 'jpeg':
            try:
                fhandle.seek(0) # Read 0xff next
                size = 2
                ftype = 0
                while not 0xc0 <= ftype <= 0xcf:
                    fhandle.seek(size, 1)
                    byte = fhandle.read(1)
                    while ord(byte) == 0xff:
                        byte = fhandle.read(1)
                    ftype = ord(byte)
                    size = struct.unpack('>H', fhandle.read(2))[0] - 2
                # We are at a SOFn block
                fhandle.seek(1, 1)  # Skip `precision' byte.
                height, width = struct.unpack('>HH', fhandle.read(4))
            except Exception: #IGNORE:W0703
                return
        else:
            return
        return width, height

def get_pngs(path):

    filenames = next(walk(path), (None, None, []))[2]  # [] if no file
    filenames = [file for file in filenames if ".png" in file]
    print("+"*80)
    print("files:",filenames)
    print("+"*80)
    return filenames

def main():

    parser = argparse.ArgumentParser(description='get dimension of image.')
    parser.add_argument('sizes_from_folder',help="folder to get dimensions from")
    parser.add_argument('resize_folders',nargs="+",help="folder to set dimensions to")
    args = parser.parse_args()

    filenames = get_pngs(args.sizes_from_folder)



    # we wil get the largest image dimensions in here
    file_map = {}

    for folder in args.resize_folders:
        print("-"*80)
        print("now checking sizes in:",folder)
        for file in get_pngs(folder):
            
            base_key = basename(file)
            path_to_file = os.path.join(folder,file)
            cur_width,cur_height = get_image_size(path_to_file)
            if not base_key in file_map:
                file_map[base_key] = (cur_width,cur_height)
            else:
                max_width,max_height = file_map[base_key]
                max_width = max(max_width,cur_width)
                max_height = max(max_height,cur_height)
                file_map[base_key] = (max_width,max_height)

        print("done.")

    # we will resize everything x2 so we can get all the models to look nice.
    for key in file_map:
        w,h = file_map[key]
        file_map[key] = (w*2,h*2)

    print("map:",file_map)
    # then we will crop images (should then only enlarge by whitespace)
    for folder in args.resize_folders:
        print("-"*80)
        print("now starting to resize stuff in:",folder)
        for file in get_pngs(folder):
            # debug
            base_key = basename(file)
            path_to_file = os.path.join(folder,file)
            print("name:",path_to_file,"old:",get_image_size(path_to_file))
            width,height = file_map[base_key]
            resize_to(path_to_file,width,height)
            print("name:",path_to_file,"new:",get_image_size(path_to_file))

        print("done.")
 

if __name__ == "__main__":
    main()




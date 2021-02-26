#!/bin/bash
if [ $# -ne 2 ]
then 
    echo "invalid number of args"
    echo "usage: ${0} <input folder> <output_filename>"
    exit
fi


cd "$1"
    
montage -background none -tile 4x1 -geometry 122x128 *.png "../${2}"


#!/bin/sh

if [ $# -ne 1 ]; then
    echo "invalid number of args.. usage: $0 <folder with txt files to fix>"
    exit 1
fi

path_arg=$1

cd "$path_arg"
# this removes the \n from the files. making them usable for us.
for filename in *.txt; do echo "$filename" ; printf "%s" "$(< $filename)" > "$filename"  ; done


# 

echo "all done. those files should work nicely now."
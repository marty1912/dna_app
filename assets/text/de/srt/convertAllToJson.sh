#!/bin/bash

for srtfile in *.srt ; 
do json_filename="${srtfile%.*}";
json_filename="${json_filename}.json";
python3 srtTojson.py $srtfile $json_filename;
done

# move the converted files one folder up.
for i in *.json;
do mv "$i" ../ ;
done

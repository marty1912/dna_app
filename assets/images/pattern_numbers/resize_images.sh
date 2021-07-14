#!/bin/bash

command -v convert >/dev/null 2>&1 || {
    echo >&2 "Convert is not installed. Aborting.";
    exit 1;
}



for infile in *.PNG
do
    outfile="${infile}"
    convert "$infile" \
            -resize '256x256^' \
            "$outfile"
done



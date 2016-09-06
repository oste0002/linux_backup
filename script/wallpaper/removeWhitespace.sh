#!/bin/bash
#for filename in ~/storage/wallpapers/* ; do
    pushd ~/storage/wallpapers/Winter
    IFS="\n"
    for file in *.jpg ; do
        mv "$file" "${file//[[:space:]]}"
    done
#done

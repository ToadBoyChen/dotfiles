#!/usr/bin/env bash

# Random Art Selector for fastfetch

art=()

for file in art/*; do 
    art+=("$file")
done

printf "%s\n" "${art[@]}"

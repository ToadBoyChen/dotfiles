#!/usr/bin/env bash

set -e

run_launch=0

while [ "$run_launch" != -1 ];
do
    let run_launch+=1
    clear
    ./title-screen.sh

    echo ""
    echo "Stage $run_launch of 2"

    if [ "$run_launch" = 1 ]; then
        ./update-system.sh
    elif [ "$run_launch" = 2 ]; then 
        ./clean-system.sh 
    else 
        run_launch=-1
    fi
done

clear
echo "Launch Script Complete"
echo "Goodbye $USER!"

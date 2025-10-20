#!/usr/bin/env bash

set -e

run_launch=1

while [ "$run_launch" = 1 ];
do
    ./title-screen.sh
    ./update-system.sh
    ./clean-system.sh 

    run_launch=0
done

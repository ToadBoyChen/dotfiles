#!/usr/bin/env bash

set -e

run_launch=1

while [ "$run_launch" = 1 ];
do
    ./.config/hypr/scripts/launch/title-screen.sh
    ./.config/hypr/scripts/launch/update-system.sh
    ./.config/hypr/scripts/launch/clean-system.sh 

    run_launch=0
done

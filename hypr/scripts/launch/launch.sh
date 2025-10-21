#!/usr/bin/env bash

run_launch=0

while (( run_launch > -1 ));
do
    clear
    ./.config/hypr/scripts/launch/title-screen.sh
    (( run_launch++ ))

    case "$run_launch" in
        1)
            ./.config/hypr/scripts/launch/set-up-system.sh 
            ;;
        2)
            ./.config/hypr/scripts/launch/update-system.sh
            ;;
        3)
            ./.config/hypr/scripts/launch/clean-system.sh 
            ;;
    esac

    if (( run_launch == 3 )); then 
        run_launch=-1
    fi
done

./.config/hypr/scripts/launch/welcome-page.sh

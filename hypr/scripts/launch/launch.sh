#!/usr/bin/env bash

run_launch=0
Dir="$HOME/.config/hypr/scripts/launch"

while (( run_launch > -1 ));
do
    clear
    source "$Dir/title-screen.sh"
    (( run_launch++ ))

    case "$run_launch" in
        1)
            source "$Dir/set-up-system.sh "
            ;;
        2)
            source "$Dir/update-system.sh"
            ;;
        3)
            source "$Dir/clean-system.sh "
            ;;
    esac

    if (( run_launch == 3 )); then 
        run_launch=-1
    fi
done

source "$Dir/welcome-page.sh"

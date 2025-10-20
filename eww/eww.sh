#!/bin/bash

CFG="$HOME/.config/eww"
EWW=`which eww`

## run eww daemon if not running already
if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 1
fi

## open widgets 
run_eww() {
	${EWW} --config "$CFG" open-many \
		   profile \
		   clock \
		   uptime
}
run_eww

## launch or close widgets accordingly
# if [[ ! -f "$FILE" ]]; then
# 	touch "$FILE"
# 	run_eww
# else
# 	${EWW} --config "$CFG" close \
# 					profile clock uptime
# 	rm "$FILE"
# fi

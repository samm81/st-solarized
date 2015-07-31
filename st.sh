#!/bin/bash

if [ $(($RANDOM%2)) == 0 ]; then
	st-solarized-dark $@
else
	st-solarized-light $@
fi

#!/bin/bash

if [ $(($RANDOM%2)) == 0 ]; then
	/usr/local/bin/st-solarized-dark
else
	/usr/local/bin/st-solarized-light
fi

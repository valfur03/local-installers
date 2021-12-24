#!/bin/sh

QUIET=0
while getopts "q" option
do
	case $option in
		"q")
			QUIET=1;;
	esac
done

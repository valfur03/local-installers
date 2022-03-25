#!/bin/sh

QUIET=0
while getopts "qC:" option
do
	case $option in
		"q")
			QUIET=1;;
		"C")
			PACKAGE_DESTINATION="$OPTARG";;
	esac
done

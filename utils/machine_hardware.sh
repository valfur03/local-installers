#!/bin/sh

MACHINE_HARDWARE=$(uname -m)
if [ "$MACHINE_HARDWARE" = "unknown" ]
then
	printf "${YELLOW}Could not reliably retrieve the machine hardware name (%s)...\nUsing x86_64 by default.${NC}\n" $MACHINE_HARDWARE
	MACHINE_HARDWARE="x86_64"
fi

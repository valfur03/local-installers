#!/bin/sh

commands_exist()
{
	for cmd in "$@"
	do
		if ! command -v $cmd > /dev/null 2>&1
		then
			printf "${RED}command '%s' is not installed...${NC}\n" "$cmd"
			return 1
		fi
	done
	return 0
}

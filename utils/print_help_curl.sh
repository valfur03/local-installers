#!/bin/sh

print_help_curl()
{
	printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	printf "${RED}If you think that the problem comes from the script,\n"
	printf "${RED}you can open on issue on GitHub.${NC}\n"
	printf "https://github.com/valfur03/local-installers/issues/new/choose\n"
}

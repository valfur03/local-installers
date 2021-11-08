#!/bin/sh

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_issue.sh
. utils/print_debug_info.sh
. utils/print_help_path.sh

PACKAGE_NAME="jq"
PACKAGE_VERSION="1.5"
PACKAGE_SOURCE="https://github.com/stedolan/jq/releases/download/jq-$PACKAGE_VERSION/jq-linux64"

ERROR=""

if ! commands_exist curl
then
	exit 1
fi

printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! ERROR=$(curl -fsSL -o $PACKAGE_NAME $PACKAGE_SOURCE 2>&1)
then
	printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	exit 1
fi

if ! ERROR=$(chmod +x $PACKAGE_NAME 2>&1)
then
	printf "${RED}Could not give execution permissions to %s...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	rm $PACKAGE_NAME
	exit 1
fi

printf "${BLUE}Installing %s in \$HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
if ! ERROR=$(mkdir -p $HOME/.local/usr/bin 2>&1)
then
	printf "${RED}Could not create folder $HOME/.local/usr/bin...${NC}\n"
	print_help_issue
	print_debug_info "$ERROR"
	rm $PACKAGE_NAME
	exit 1
fi
if ! ERROR=$(mv jq $HOME/.local/usr/bin 2>&1)
then
	printf "${RED}Could not mv %s $HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	rm $PACKAGE_NAME
	exit 1
fi


printf "${GREEN}%s is installed!${NC}\n" $PACKAGE_NAME
print_help_path

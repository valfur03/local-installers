#!/bin/sh

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_issue.sh
. utils/print_debug_info.sh
. utils/print_help_path.sh
. utils/machine_hardware.sh

PACKAGE_NAME="jq"
PACKAGE_DESTINATION="$HOME/$PACKAGE_NAME"
PACKAGE_VERSION="1.5"
PACKAGE_SOURCE="https://github.com/stedolan/jq/releases/download/jq-$PACKAGE_VERSION/jq-linux64"

. utils/args.sh

ERROR=""

if ! commands_exist wget
then
	exit 1
fi

[ $QUIET == "0" ] && printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! ERROR=$(wget -O $PACKAGE_DESTINATION $PACKAGE_SOURCE 2>&1)
then
	[ $QUIET == "0" ] && printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	exit 1
fi

if ! ERROR=$(chmod +x $PACKAGE_DESTINATION 2>&1)
then
	[ $QUIET == "0" ] && printf "${RED}Could not give execution permissions to %s...${NC}\n" $PACKAGE_DESTINATION
	print_help_issue
	print_debug_info "$ERROR"
	rm -f $PACKAGE_DESTINATION
	exit 1
fi

[ $QUIET == "0" ] && printf "${BLUE}Installing %s in \$HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
if ! ERROR=$(mkdir -p $HOME/.local/usr/bin 2>&1)
then
	[ $QUIET == "0" ] && printf "${RED}Could not create folder $HOME/.local/usr/bin...${NC}\n"
	print_help_issue
	print_debug_info "$ERROR"
	rm -f $PACKAGE_NAME
	exit 1
fi
if ! ERROR=$(mv $PACKAGE_DESTINATION $HOME/.local/usr/bin 2>&1)
then
	[ $QUIET == "0" ] && printf "${RED}Could not mv %s $HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	rm -f $PACKAGE_NAME
	exit 1
fi


[ $QUIET == "0" ] && printf "${GREEN}%s is installed!${NC}\n" $PACKAGE_NAME
print_help_path

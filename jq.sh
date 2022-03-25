#!/bin/sh

cd $(dirname "$0")

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_issue.sh
. utils/print_debug_info.sh
. utils/print_help_path.sh
. utils/machine_hardware.sh

PACKAGE_NAME="jq"
PACKAGE_VERSION="1.5"
PACKAGE_DESTINATION="$HOME/.local"
PACKAGE_SOURCE="https://github.com/stedolan/jq/releases/download/jq-$PACKAGE_VERSION/jq-linux64"

. utils/args.sh
ARCHIVE_DESTINATION="$PACKAGE_DESTINATION/$PACKAGE_NAME"

ERROR=""

if ! commands_exist wget
then
	exit 1
fi

[ "$QUIET" = "0" ] && printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! ERROR=$(wget -O $ARCHIVE_DESTINATION $PACKAGE_SOURCE 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	exit 1
fi

if ! ERROR=$(chmod +x $ARCHIVE_DESTINATION 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not give execution permissions to %s...${NC}\n" $ARCHIVE_DESTINATION
	print_help_issue
	print_debug_info "$ERROR"
	rm -f $ARCHIVE_DESTINATION
	exit 1
fi

[ "$QUIET" = "0" ] && printf "${BLUE}Installing %s in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DESTINATION
if ! ERROR=$(mkdir -p $PACKAGE_DESTINATION/bin 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not create in folder $PACKAGE_DESTINATION...${NC}\n"
	print_help_issue
	print_debug_info "$ERROR"
	rm -f $ARCHIVE_DESTINATION
	exit 1
fi
if ! ERROR=$(mv $ARCHIVE_DESTINATION $PACKAGE_DESTINATION/bin/$PACKAGE_NAME 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not mv %s in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DESTINATION/bin/$PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	rm -f $PACKAGE_NAME
	exit 1
fi


[ "$QUIET" = "0" ] && printf "${GREEN}%s is installed!${NC}\n" $PACKAGE_NAME
print_help_path

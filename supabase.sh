#!/bin/sh

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_issue.sh
. utils/print_debug_info.sh
. utils/print_help_path.sh
. utils/machine_hardware.sh

case "$MACHINE_HARDWARE" in
	"x86_64")
		MACHINE_HARDWARE="amd64";;
	"aarch64")
		MACHINE_HARDWARE="arm64";;
	*)
		printf "${RED}Unknown machine hardware name (%s)...${NC}\n" $MACHINE_HARDWARE
		exit 1;;
esac

PACKAGE_NAME="supabase"
PACKAGE_VERSION="0.16.1"
PACKAGE_DIRECTORY="${PACKAGE_NAME}_${PACKAGE_VERSION}_linux_${MACHINE_HARDWARE}"
PACKAGE_ARCHIVE="$PACKAGE_DIRECTORY.tar.gz"
PACKAGE_DESTINATION="$HOME/$PACKAGE_ARCHIVE"
PACKAGE_SOURCE="https://github.com/$PACKAGE_NAME/cli/releases/download/v$PACKAGE_VERSION/$PACKAGE_ARCHIVE"

. utils/args.sh

ERROR=""

if ! commands_exist wget
then
	exit 1
fi

[ "$QUIET" = "0" ] && printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! ERROR=$(wget -O $PACKAGE_DESTINATION $PACKAGE_SOURCE 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	exit 1
fi

[ "$QUIET" = "0" ] && printf "${BLUE}Extracting %s archive in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DIRECTORY
if ! ERROR=$(tar x -C $HOME -f $PACKAGE_DESTINATION 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not extract %s...${NC}\n" $PACKAGE_ARCHIVE
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $PACKAGE_DESTINATION
	exit 1
fi

[ "$QUIET" = "0" ] && printf "${BLUE}Installing %s in \$HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
if ! ERROR=$(mkdir -p $HOME/.local/usr/bin 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not create in folder $HOME/.local/usr...${NC}\n"
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $PACKAGE_DESTINATION
	exit 1
fi
if ! ERROR=$(cp -rf $HOME/$PACKAGE_NAME $HOME/.local/usr/bin/$PACKAGE_NAME 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not cp %s $HOME/.local...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $PACKAGE_DESTINATION
	exit 1
fi

rm -r $PACKAGE_DESTINATION

[ "$QUIET" = "0" ] && printf "${GREEN}%s is installed!${NC}\n" $PACKAGE_NAME
print_help_path

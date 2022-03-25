#!/bin/sh

cd $(dirname "$0")

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_issue.sh
. utils/print_debug_info.sh
. utils/print_help_path.sh
. utils/machine_hardware.sh

case "$MACHINE_HARDWARE" in
	"x86_64")
		MACHINE_HARDWARE="x64";;
	"aarch64")
		MACHINE_HARDWARE="arm64";;
	"armv7l");;
	*)
		printf "${RED}Unknown machine hardware name (%s)...${NC}\n" $MACHINE_HARDWARE
		exit 1;;
esac

PACKAGE_NAME="node"
PACKAGE_VERSION="16.14.2"
PACKAGE_DIRECTORY="node-v$PACKAGE_VERSION-linux-$MACHINE_HARDWARE"
PACKAGE_ARCHIVE="$PACKAGE_DIRECTORY.tar.xz"
PACKAGE_DESTINATION="$HOME/.local"
PACKAGE_SOURCE="https://nodejs.org/dist/v$PACKAGE_VERSION/$PACKAGE_ARCHIVE"

. utils/args.sh
ARCHIVE_DESTINATION="$PACKAGE_DESTINATION/$PACKAGE_ARCHIVE"

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

[ "$QUIET" = "0" ] && printf "${BLUE}Extracting %s archive in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DIRECTORY
if ! ERROR=$(tar x -C $HOME -f $ARCHIVE_DESTINATION 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not extract %s...${NC}\n" $PACKAGE_ARCHIVE
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $ARCHIVE_DESTINATION
	exit 1
fi

[ "$QUIET" = "0" ] && printf "${BLUE}Installing %s in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DESTINATION
if ! ERROR=$(mkdir -p $PACKAGE_DESTINATION/bin 2>&1) \
	|| ! ERROR=$(mkdir -p $PACKAGE_DESTINATION/include 2>&1) \
	|| ! ERROR=$(mkdir -p $PACKAGE_DESTINATION/lib 2>&1) \
	|| ! ERROR=$(mkdir -p $PACKAGE_DESTINATION/share 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not create in folder $PACKAGE_DESTINATION...${NC}\n"
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $ARCHIVE_DESTINATION
	exit 1
fi
if ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/bin $PACKAGE_DESTINATION 2>&1) \
	|| ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/include $PACKAGE_DESTINATION 2>&1) \
	|| ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/lib $PACKAGE_DESTINATION 2>&1) \
	|| ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/share $PACKAGE_DESTINATION 2>&1)
then
	[ "$QUIET" = "0" ] && printf "${RED}Could not cp %s in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DESTINATION
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $ARCHIVE_DESTINATION
	exit 1
fi

rm -r $HOME/$PACKAGE_DIRECTORY $ARCHIVE_DESTINATION

[ "$QUIET" = "0" ] && printf "${GREEN}%s is installed!${NC}\n" $PACKAGE_NAME
print_help_path

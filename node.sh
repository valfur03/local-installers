#!/bin/sh

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
PACKAGE_VERSION="16.13.1"
PACKAGE_DIRECTORY="node-v$PACKAGE_VERSION-linux-$MACHINE_HARDWARE"
PACKAGE_ARCHIVE="$PACKAGE_DIRECTORY.tar.xz"
PACKAGE_DESTINATION="$HOME/$PACKAGE_ARCHIVE"
PACKAGE_SOURCE="https://nodejs.org/dist/v$PACKAGE_VERSION/node-v$PACKAGE_VERSION-linux-$MACHINE_HARDWARE.tar.xz"

ERROR=""

if ! commands_exist curl
then
	exit 1
fi

printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! ERROR=$(curl -fsSL -o $PACKAGE_DESTINATION $PACKAGE_SOURCE 2>&1)
then
	printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	exit 1
fi

printf "${BLUE}Extracting %s archive in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DIRECTORY
if ! ERROR=$(tar x -C $HOME -f $PACKAGE_DESTINATION 2>&1)
then
	printf "${RED}Could not extract %s...${NC}\n" $PACKAGE_ARCHIVE
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $PACKAGE_DESTINATION
	exit 1
fi

printf "${BLUE}Installing %s in \$HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
if ! ERROR=$(mkdir -p $HOME/.local/usr/bin 2>&1) \
	|| ! ERROR=$(mkdir -p $HOME/.local/usr/include 2>&1) \
	|| ! ERROR=$(mkdir -p $HOME/.local/usr/lib 2>&1) \
	|| ! ERROR=$(mkdir -p $HOME/.local/usr/share 2>&1)
then
	printf "${RED}Could not create in folder $HOME/.local/usr...${NC}\n"
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $PACKAGE_DESTINATION
	exit 1
fi
if ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/bin $HOME/.local/usr 2>&1) \
	|| ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/include $HOME/.local/usr 2>&1) \
	|| ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/lib $HOME/.local/usr 2>&1) \
	|| ! ERROR=$(cp -rf $HOME/$PACKAGE_DIRECTORY/share $HOME/.local/usr 2>&1)
then
	printf "${RED}Could not cp %s $HOME/.local...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	rm -rf $HOME/$PACKAGE_DIRECTORY
	rm -f $PACKAGE_DESTINATION
	exit 1
fi

rm -r $HOME/$PACKAGE_DIRECTORY $PACKAGE_DESTINATION

printf "${GREEN}%s is installed!${NC}\n" $PACKAGE_NAME
print_help_path

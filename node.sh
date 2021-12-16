#!/bin/sh

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_issue.sh
. utils/print_debug_info.sh
. utils/print_help_path.sh

PACKAGE_NAME="node"
PACKAGE_VERSION="14.18.1"
PACKAGE_DIRECTORY="node-v$PACKAGE_VERSION-linux-x64"
PACKAGE_ARCHIVE="$PACKAGE_DIRECTORY.tar.xz"
PACKAGE_SOURCE="https://nodejs.org/dist/v$PACKAGE_VERSION/node-v$PACKAGE_VERSION-linux-x64.tar.xz"

ERROR=""

if ! commands_exist curl
then
	exit 1
fi

printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! ERROR=$(curl -fsSL -o $PACKAGE_ARCHIVE $PACKAGE_SOURCE 2>&1)
then
	printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	exit 1
fi

printf "${BLUE}Extracting %s archive in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DIRECTORY
if ! ERROR=$(tar xf $PACKAGE_ARCHIVE 2>&1)
then
	printf "${RED}Could not extract %s...${NC}\n" $PACKAGE_ARCHIVE
	print_help_issue
	print_debug_info "$ERROR"
	rm -r $PACKAGE_DIRECTORY
	rm $PACKAGE_ARCHIVE
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
	rm -r $PACKAGE_DIRECTORY
	rm $PACKAGE_ARCHIVE
	exit 1
fi
if ! ERROR=$(cp -rf $PACKAGE_DIRECTORY/bin $HOME/.local/usr 2>&1) \
	|| ! ERROR=$(cp -rf $PACKAGE_DIRECTORY/include $HOME/.local/usr 2>&1) \
	|| ! ERROR=$(cp -rf $PACKAGE_DIRECTORY/lib $HOME/.local/usr 2>&1) \
	|| ! ERROR=$(cp -rf $PACKAGE_DIRECTORY/share $HOME/.local/usr 2>&1)
then
	printf "${RED}Could not cp %s $HOME/.local...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$ERROR"
	rm -r $PACKAGE_DIRECTORY
	rm $PACKAGE_ARCHIVE
	exit 1
fi

rm -r $PACKAGE_DIRECTORY $PACKAGE_ARCHIVE

printf "${GREEN}%s is installed!${NC}\n" $PACKAGE_NAME
print_help_path

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

CURL_ERROR=""
CHMOD_ERROR=""
MKDIR_ERROR=""
TAR_ERROR=""

if ! commands_exist curl
then
	exit 1
fi

printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! CURL_ERROR=$(curl -fsSL -o $PACKAGE_ARCHIVE $PACKAGE_SOURCE 2>&1)
then
	printf "${RED}%s could not be downloaded...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$CURL_ERROR"
	exit 1
fi

printf "${BLUE}Extracting %s arhive in %s...${NC}\n" $PACKAGE_NAME $PACKAGE_DIRECTORY
if ! TAR_ERROR=$(tar xf $PACKAGE_ARCHIVE 2>&1)
then
	printf "${RED}Could not extract %s...${NC}\n" $PACKAGE_ARCHIVE
	print_help_issue
	print_debug_info "$TAR_ERROR"
	rm -r $PACKAGE_DIRECTORY
	rm $PACKAGE_ARCHIVE
	exit 1
fi

printf "${BLUE}Installing %s in \$HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
if ! MKDIR_ERROR=$(mkdir -p $HOME/.local/usr/bin 2>&1) \
	|| ! MKDIR_ERROR=$(mkdir -p $HOME/.local/usr/include 2>&1) \
	|| ! MKDIR_ERROR=$(mkdir -p $HOME/.local/usr/lib 2>&1) \
	|| ! MKDIR_ERROR=$(mkdir -p $HOME/.local/usr/share 2>&1)
then
	printf "${RED}Could not create in folder $HOME/.local/usr...${NC}\n"
	print_help_issue
	print_debug_info "$MKDIR_ERROR"
	rm -r $PACKAGE_DIRECTORY
	rm $PACKAGE_ARCHIVE
	exit 1
fi
if ! CP_ERROR=$(cp -rf $PACKAGE_DIRECTORY/bin $HOME/.local/usr 2>&1) \
	|| ! CP_ERROR=$(cp -rf $PACKAGE_DIRECTORY/include $HOME/.local/usr 2>&1) \
	|| ! MV_ERROR=$(cp -rf $PACKAGE_DIRECTORY/lib $HOME/.local/usr 2>&1) \
	|| ! MV_ERROR=$(cp -rf $PACKAGE_DIRECTORY/share $HOME/.local/usr 2>&1)
then
	printf "${RED}Could not cp %s $HOME/.local...${NC}\n" $PACKAGE_NAME
	print_help_issue
	print_debug_info "$MV_ERROR"
	rm -r $PACKAGE_DIRECTORY
	rm $PACKAGE_ARCHIVE
	exit 1
fi

rm -r $PACKAGE_DIRECTORY $PACKAGE_ARCHIVE

printf "${GREEN}node is installed!${NC}\n"
print_help_path

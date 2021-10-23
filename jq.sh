#!/bin/sh

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_curl.sh
. utils/print_debug_info.sh
. utils/print_help_path.sh

PACKAGE_NAME="jq"
PACKAGE_VERSION="1.5"
PACKAGE_SOURCE="https://github.com/stedolan/jq/releases/download/jq-$PACKAGE_VERSION/jq-linux64"

CURL_ERROR=""

if ! commands_exist curl
then
	exit 1
fi

printf "${BLUE}Downloading %s...${NC}\n" "$PACKAGE_NAME"
if ! CURL_ERROR=$(curl -fsSL -o $PACKAGE_NAME ${PACKAGE_SOURCE} 2>&1)
then
	print_help_curl
	print_debug_info
	exit 1
fi
chmod +x $PACKAGE_NAME

printf "${BLUE}Installing %s in \$HOME/.local/usr/bin...${NC}\n" $PACKAGE_NAME
mkdir -p $HOME/.local/usr/bin
mv jq $HOME/.local/usr/bin

printf "${GREEN}jq is installed!${NC}\n"
print_help_path

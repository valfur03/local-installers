#!/bin/sh

. utils/colors.sh
. utils/commands_exist.sh
. utils/print_help_path.sh

if ! commands_exist curl
then
	exit 1
fi

printf "${BLUE}Downloading jq...${NC}\n"
curl -fsSL -o jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
chmod +x jq

printf "${BLUE}Installing jq in \$HOME/.local/usr/bin...${NC}\n"
mkdir -p $HOME/.local/usr/bin
mv jq $HOME/.local/usr/bin

print_help_path

printf "${YELLOW}You may need to restart your shell\n"
printf "for the PATH variable to change${NC}\n"

#!/bin/sh

. utils/colors.sh
. utils/commands_exist.sh

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

printf "${GREEN}jq is installed!${NC}\n"
printf "Now add the following lines to your .zshrc\n"
printf "(or .bashrc or whatever file your shell uses).\n"
printf "
if [ -d \$HOME/.local/usr/bin ]; then
    export PATH="\$HOME/.local/usr/bin:\$PATH"
fi\n\n"

printf "${YELLOW}You may need to restart your shell\n"
printf "for the PATH variable to change${NC}\n"

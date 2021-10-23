#!/bin/sh

print_help_path()
{
	printf "${GREEN}jq is installed!${NC}\n"
	printf "Now add the following lines to your .zshrc\n"
	printf "(or .bashrc or whatever file your shell uses).\n"
	printf "
if [ -d \$HOME/.local/usr/bin ]; then
    export PATH=\"\$HOME/.local/usr/bin:\$PATH\"
fi\n\n"
}

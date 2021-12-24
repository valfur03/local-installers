#!/bin/sh

print_help_path()
{
	if ! echo $PATH | grep "$HOME/.local/usr/bin" > /dev/null 2>&1 \
		&& ! echo $PATH | grep '$HOME/.local/usr/bin' > /dev/null 2>&1 \
		&& [ "$QUIET" = "0" ]
	then
		printf "Now add the following lines to your .zshrc\n"
		printf "(or .bashrc or whatever file your shell uses).\n"
		printf "\n"
		printf "if [ -d \$HOME/.local/usr/bin ]; then\n"
    	printf "export PATH=\"\$HOME/.local/usr/bin:\$PATH\"\n"
		printf "fi\n"
		printf "\n"
		printf "${YELLOW}You may need to restart your shell\n"
		printf "for the PATH variable to change${NC}\n"
	fi
}

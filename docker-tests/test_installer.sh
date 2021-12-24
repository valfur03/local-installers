#!/bin/sh

cd $(dirname "$0")

installer="$1"
[ $# -gt 1 ] && shift 1
./$installer.sh -q

commands="$@"
for command in $commands
do
	PATH="$HOME/.local/bin:$HOME/.local/usr/bin:$PATH" $command --version
done

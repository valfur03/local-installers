#!/bin/sh

print_debug_info()
{
	printf "\n====================\n\n"
	printf "%s\n" "$CURL_ERROR"
	printf "PACKAGE_NAME: %s\n" $PACKAGE_NAME
	printf "PACKAGE_VERSION: %s\n" $PACKAGE_VERSION
	printf "PACKAGE_SOURCE: %s\n" $PACKAGE_SOURCE
}

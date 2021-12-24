#!/bin/sh

PACKAGES="jq node"
ARCHS="amd64 arm32v7 arm64v8"

build_docker_images()
{
	for arch in $ARCHS
	do
		printf "Building image for %s architecture\n" "$arch"
		if ! docker build -t $arch-alpine-test -f docker-tests/$arch.Dockerfile docker-tests > /dev/null 2>&1
		then
			printf "An error occured...\n"
		fi
	done
}

test_scripts_on_arch()
{
	for arch in $ARCHS
	do
		printf "=== testing %s architecture ===\n" "$arch"
		for package in $PACKAGES
		do
			printf "package: %s " "$package"
			docker run --rm -it -v $PWD/$package.sh:/usr/src/$package.sh -v $PWD/utils:/usr/src/utils -v $PWD/docker-tests/test_installer.sh:/usr/src/test_installer.sh $arch-alpine-test /usr/src/test_installer.sh $package 2> /dev/null
			[ $? -eq 0 ] && printf "OK\n" || printf "KO\n"
		done
	done
}

cd $(dirname "$0")

build_docker_images
test_scripts_on_arch

#!/bin/sh

PACKAGES="jq node"
ARCHS="amd64 arm32v6 arm32v7 arm64v8"

test_scripts_on_arch()
{
	for arch in $ARCHS
	do
		docker build -t $arch-alpine-test -f tests/$arch.Dockerfile tests

		for package in $PACKAGES
		do
			docker run --rm -t -v $PWD/$package.sh:/usr/src/$package.sh -v $PWD/utils:/usr/src/utils -v $PWD/tests/test_installer.sh:/usr/src/test_installer.sh $arch-alpine-test /usr/src/test_installer.sh $package
		done
	done
}

cd $(dirname "$0")/..

test_scripts_on_arch

#!/usr/bin/env bash
# Copyright (c) 2003-2022, CKSource Holding sp. z o.o. All rights reserved.
# For licensing, see LICENSE.md or https://ckeditor.com/legal/ckeditor-oss-license

# Build CKEditor using the default settings (and build.js).

set -e

printf "CKBuilder - Builds a release version of ckeditor4.\n"
printf "\n"

CKBUILDER_VERSION="2.4.3"
CKBUILDER_URL="https://download.cksource.com/CKBuilder/$CKBUILDER_VERSION/ckbuilder.jar"

RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
UNDERLINE='\033[4m'
RESET_STYLE='\033[0m'

PROGNAME=$(basename $0)
MSG_UPDATE_FAILED="Warning: The attempt to update ckbuilder.jar failed. The existing file will be used.\n"
MSG_DOWNLOAD_FAILED="It was not possible to download ckbuilder.jar.\n"
MSG_INCORRECT_JDK_VERSION="${RED}Your JDK version is not supported, there may be a problem to finish build process. Please change the JDK version to 15 or lower.${RED} ${GREEN}https://jdk.java.net/archive/${GREEN}\n"
ARGS=" $@ "

if [ $# -ne 1 ]; then
  printf "usage: $0 <build version>"
  exit 1
fi

VERSION="$1"

function error_exit
{
	printf "${PROGNAME}: ${1:-"Unknown Error"}\n" 1>&2
	exit 1
}

function command_exists
{
	command -v "$1" > /dev/null 2>&1;
}

# Move to the script directory.
cd $(dirname $0)

# Download/update ckbuilder.jar.
mkdir -p ckbuilder/$CKBUILDER_VERSION
cd ckbuilder/$CKBUILDER_VERSION
if [ -f ckbuilder.jar ]; then
	printf "Checking/Updating CKBuilder...\n"
	if command_exists curl ; then
	curl -O -R -z ckbuilder.jar $CKBUILDER_URL || printf "$MSG_UPDATE_FAILED"
	else
	wget -N $CKBUILDER_URL || printf "$MSG_UPDATE_FAILED"
	fi
else
	printf "Downloading CKBuilder...\n"
	if command_exists curl ; then
	curl -O -R $CKBUILDER_URL || error_exit "$MSG_DOWNLOAD_FAILED"
	else
	wget -N $CKBUILDER_URL || error_exit "$MSG_DOWNLOAD_FAILED"
	fi
fi
cd ../..

# Run the builder.
printf "\n"
printf "Starting CKBuilder...\n"

# Disabled the built-in JDK check for now (missing `bc` command on Jenkins)
# jdk_version=$( echo `java -version 2>&1 | grep 'version' 2>&1 | awk -F\" '{ split($2,a,"."); print a[1]}'` | bc -l);
# regex='^[0-9]+$';
# Builder is crashing when JDK version is newer than 15.
# if ! [[ $jdk_version =~ $regex ]] || [ $jdk_version -gt 15 ]; then
#	printf "${MSG_INCORRECT_JDK_VERSION}\n";
#	printf "${UNDERLINE}${YELLOW}Actual version of JDK: ${jdk_version}${RESET_STYLE}\n";
#fi

printf "Copy external plugins from node_modules...\n"
cp -r ../../node_modules/ckeditor-codemirror-plugin/codemirror ../../plugins/
cp -r ../../node_modules/ckeditor-textselection-plugin/textselection ../../plugins/
cp -r ../../node_modules/ckeditor-wordcount-plugin/wordcount ../../plugins/
cp -r ../../node_modules/@bloomreach/hippo-ckeditor-youtube-plugin/youtube ../../plugins/

JAVA_ARGS=${ARGS// -t / } # Remove -t from args.
VERSION=$(grep '"version":' ./../../package.json | sed $'s/[\t\",: ]//g; s/version//g' | tr -d '[[:space:]]')
REVISION=$(git rev-parse --verify --short HEAD)

java -jar ckbuilder/$CKBUILDER_VERSION/ckbuilder.jar --build ../../ release $JAVA_ARGS --version="$VERSION" --revision="$REVISION" --overwrite --skip-omitted-in-build-config --no-tar --no-zip --no-ie-checks

# Copy and build tests.
if [[ "$ARGS" == *\ \-t\ * ]]; then
	printf "\n"
	printf "Copying tests...\n"

	cp -r ../../tests release/ckeditor/tests
	cp -r ../../package.json release/ckeditor/package.json
	cp -r ../../bender.js release/ckeditor/bender.js

	printf "\n"
	printf "Installing tests...\n"

	(cd release/ckeditor &&	npm install && bender init)
fi

printf "Copy icons of codemirror plugin...\n"
cp -r ../../plugins/codemirror/icons release/ckeditor/plugins/codemirror

printf "Use hdpi icon to fix blurry youtube toolbar icon...\n"
cp -f release/ckeditor/plugins/youtube/images/icon-hdpi.png release/ckeditor/plugins/youtube/images/icon.png

printf "\n"
printf "Release created in the \"release\" directory.\n"

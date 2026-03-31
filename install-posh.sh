#!/bin/bash

TMP_DIR="/tmp/oh-my-posh"

mkdir -p $TMP_DIR

wget "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v29.9.2/themes.zip" -O $TMP_DIR/themes.zip

unzip $TMP_DIR/themes.zip -d $TMP_DIR

mkdir -p ~/.poshthemes
mv -v $TMP_DIR/*.json ~/.poshthemes

rm -rf $TMP_DIR

curl -s https://ohmyposh.dev/install.sh | bash -s
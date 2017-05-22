#!/usr/bin/env bash
DATE=$(date +"%Y-%m-%d")
DIR=~/Pictures/Fuck/$DATE
mkdir -p $DIR
mv ~/Desktop/*.png $DIR/

DIR=~/Documents/Code/$DATE
mkdir -p $DIR
mv ~/*.go $DIR
mv ~/*.py $DIR

#!/bin/bash -e

DIR=/backup/bck_`date '+%Y-%m-%d-%H-%M-%S'`/
mkdir -p $DIR
slapcat -n 0 -l ${DIR}/config.ldif
slapcat -n 1 -l ${DIR}/data.ldif

find /backup/ -maxdepth 1 -mindepth 1 -ctime 15 -type d -name bck_* | xargs -i rm -rf {}

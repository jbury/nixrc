#!/usr/bin/env sh
set -eu

DIR=$(date +"~/Pictures/Screenshots/Work/%Y/%m/%d")
FILE=$(date +"%H:%M.png")
mkdir -p ${DIR}
scrot "${DIR}/${FILE}" -e 'optipng $f'

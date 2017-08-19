#!/bin/bash
# author: chat@jat.email

git submodule update --init --remote

HOSTSITE=${HOSTSITE:-127.0.0.1}
HOSTSITE=${HOSTSITE%/}
[ "${HOSTSITE:0:4}" != 'http' ] && HOSTSITE="http://$HOSTSITE"

i=1
while :; do
    ./qshell qupload -success-list lists/success_$i.txt "$(find haoutil/player/testmod/ -name '*.swf' -maxdepth 1 | wc -l)" .qupload.json && break
    ((i++))
done

for f in lists/*; do
    sed -ri "s#[^\t]+\t#$HOSTSITE/#" "$f"
    while :; do ./qshell cdnrefresh "$f" && break; done
done

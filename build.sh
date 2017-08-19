#!/bin/bash
# author: chat@jat.email

HOSTSITE=${HOSTSITE:-127.0.0.1}
HOSTSITE=${HOSTSITE%/}
[ "${HOSTSITE:0:4}" != 'http' ] && HOSTSITE="http://$HOSTSITE"

git submodule update --init --remote
mkdir lists

./qshell account "$QINIU_AK" "$QINIU_SK"
sed -i "s/#QINIU_BUCKET#/$QINIU_BUCKET/" .qupload.json

i=1
while :; do
    ./qshell qupload -success-list lists/success_$i.txt "$(find haoutil/player/testmod/ -name '*.swf' -maxdepth 1 | wc -l)" .qupload.json && break
    ((i++))
done

for f in lists/*; do
    sed -ri "s#[^\t]+\t#$HOSTSITE/#" "$f"
    while :; do ./qshell cdnrefresh "$f" && break; done
done

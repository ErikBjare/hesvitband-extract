#!/bin/bash

OUTFILE="hesvitband-data-$(date --iso-8601=seconds).sqlite"

rm -r tmp &> /dev/null
mkdir tmp
cd tmp

echo "Do not specify a password for the backup when asked!"

adb backup -f data.ab -noapk com.launch.bracelet \
&& dd if=data.ab bs=1 skip=24 \
 | python2 -c "import zlib,sys;sys.stdout.write(zlib.decompress(sys.stdin.read()))" \
 | tar -xvf - 1>&2 \
 && cp apps/com.launch.bracelet/db/bracelet.db "../$OUTFILE" \
|| exit 1

cd ..
echo "Cleaning up..."
rm -r tmp
echo "Done! The filename is '$OUTFILE', open with sqlite GUI of choice (such as sqliteman)"

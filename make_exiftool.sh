#!/bin/bash

echo "=== Starting ExifTool build/install."

export EXIFTOOL_VERSION=12.48

cd /home
apk add --no-cache perl make
cd /tmp
wget http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz 
tar -zxvf Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz 
cd Image-ExifTool-${EXIFTOOL_VERSION} 
perl Makefile.PL 
make test 
make install 
cd .. 
rm -rf Image-ExifTool-${EXIFTOOL_VERSION}

exiftool -ver
which exiftool

echo "=== Completed ExifTool build/install."

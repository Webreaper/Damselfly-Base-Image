#!/bin/bash

echo "=== Starting ExifTool build/install."

apt-get update
apt-get install -y build-essential curl git perl make

export EXIFTOOL_VERSION=12.48

cd /home
mkdir Image-ExifTool-${EXIFTOOL_VERSION}
curl http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz 
tar -zxvf Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz 
rm Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz 
cd /home/Image-ExifTool-${EXIFTOOL_VERSION} 
perl Makefile.PL 
make test 
make install 
cd .. 
rm -rf Image-ExifTool-${EXIFTOOL_VERSION}

exiftool -ver
which exiftool

echo "=== Completed ExifTool build/install."

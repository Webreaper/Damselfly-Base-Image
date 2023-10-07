#!/bin/bash

echo "=== Starting ExifTool build/install."

apt-get update
apt-get install -y build-essential curl git perl make

export EXIFTOOL_VERSION=12.67

cd /home
mkdir Image-ExifTool-${EXIFTOOL_VERSION}
curl https://exiftool.org/Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz | tar zx -C Image-ExifTool-${EXIFTOOL_VERSION} --strip-components 1
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

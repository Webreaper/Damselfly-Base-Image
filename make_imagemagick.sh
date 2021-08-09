#!/bin/bash

echo "=== Starting ImageMagick build/install."

sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

apt-get update
apt-get install -y build-essential curl git tee
apt-get build-dep -y imagemagick
apt-get install -y libde265-dev libopenjp2-7-dev librsvg2-dev libwebp-dev

echo "=== Building libheif..."
cd /home
git clone https://github.com/strukturag/libheif.git
cd /home/libheif
./autogen.sh
./configure
make
make install

cd /home
echo "=== Building ImageMagick..."
mkdir ImageMagick
curl https://download.imagemagick.org/ImageMagick/download/ImageMagick.tar.gz | tar zx -C ImageMagick --strip-components 1
rm ImageMagick.tar.gz
cd /home/ImageMagick
./configure --with-heic=yes
make
make install
cd ..

./ldconfig
rm -rf libheif ImageMagick 

convert -version | tee imagemagick_version.txt
# apt-get -y remove build-essential curl git build-dep 

echo "=== Completed ImageMagick build/install."

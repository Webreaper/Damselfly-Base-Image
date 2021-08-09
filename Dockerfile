FROM ubuntu:20.04

RUN apt update

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
                        # procps 
                        procps \
                        # exiftool
                        exiftool \
                        # and lastly, fonts
                        fontconfig fonts-liberation \
                        # GDI+ and ONNX 
                        libgomp1 apt-utils libgdiplus libc6-dev \
                        # Now the emgucv dependencies
                        libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev \
                        libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev 

# ImageMagick with HEIC support. From https://github.com/nekonenene/imagemagick_heic_image

RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y build-essential curl git
RUN apt-get build-dep -y imagemagick
RUN apt-get install -y libde265-dev libopenjp2-7-dev librsvg2-dev libwebp-dev

WORKDIR /home
RUN git clone https://github.com/strukturag/libheif.git
WORKDIR /home/libheif
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
RUN cd ..

WORKDIR /home

RUN mkdir ImageMagick
RUN curl https://www.imagemagick.org/download/ImageMagick.tar.gz
RUN tar xf -C ImageMagick 
WORKDIR /home/ImageMagick
RUN ./configure --with-heic=yes
RUN make
RUN make install
RUN cd ..

WORKDIR /home

RUN ldconfig
RUN rm -rf libheif ImageMagick

WORKDIR /

# init the font caches
RUN fc-cache -f -v

# Need sudo for the iNotify count increase
# RUN set -ex && apt-get install -y sudo

# Copy the entrypoint script
COPY ./entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

ADD VERSION .

ENTRYPOINT ["sh","/entrypoint.sh"]

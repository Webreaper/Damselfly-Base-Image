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

WORKDIR /home 
COPY ./make_imagemagick.sh .
RUN make_imagemagick.sh

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

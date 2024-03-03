FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
                        # procps 
                        procps \
                        # and lastly, fonts
                        fontconfig fonts-liberation \
                        # GDI+ and ONNX 
                        libgomp1 apt-utils libgdiplus libc6-dev \
                        # ufraw - for ImageMagick Sony conversions
                        dcraw \
                        # Now the emgucv dependencies
                        libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev \
                        libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev libc6-dev \
                  && rm -rf /var/lib/apt/lists/*
                  
# ImageMagick with HEIC support. From https://github.com/nekonenene/imagemagick_heic_image

WORKDIR /home 

COPY [ \
  "make_imagemagick.sh", \
  "make_exiftool.sh", \
  # "cleanup.sh", \
  "/home/" \
]

RUN set -eux \
    && chmod +x ./make_imagemagick.sh \
    && chmod +x ./make_exiftool.sh \
    && chmod +x ./cleanup.sh \
    && /home/make_imagemagick.sh \
    && /home/make_exiftool.sh \
    && /home/cleanup.sh

# init the font caches
RUN fc-cache -f -v

# Need sudo for the iNotify count increase
# RUN set -ex && apt-get install -y sudo

# Copy the entrypoint script
COPY ./entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

ADD VERSION .

ENTRYPOINT ["sh","/entrypoint.sh"]

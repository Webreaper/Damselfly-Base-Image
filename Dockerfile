FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
      && apt-get --no-install-recommends install -y \
      # libraw for imagemagick
      libraw-bin \
      # procps 
      procps \
      # and lastly, fonts
      fontconfig fonts-liberation \
      # GDI+ and ONNX 
      libgomp1 apt-utils libgdiplus libc6-dev \
      # ufraw - for ImageMagick Sony conversions
      dcraw \
      && rm -rf /var/lib/apt/lists/*
                  
# init the font caches
RUN fc-cache -f -v

WORKDIR /home 

COPY [ \
  "make_imagemagick.sh", \
  "make_exiftool.sh", \
  "cleanup.sh", \
  "validate.sh", \
  "/home/" \
]

RUN set -eux \
    && chmod +x ./make_imagemagick.sh \
    && chmod +x ./make_exiftool.sh \
    && chmod +x ./cleanup.sh \
    && chmod +x ./validate.sh \
    && /home/make_imagemagick.sh \
    && /home/make_exiftool.sh \
    && /home/cleanup.sh \
    && /home/validate.sh

# Need sudo for the iNotify count increase
# RUN set -ex && apt-get install -y sudo

# Copy the entrypoint script
COPY ./entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

ADD VERSION .

ENTRYPOINT ["sh","/entrypoint.sh"]

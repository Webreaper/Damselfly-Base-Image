# Build stage
FROM ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libtool \
    cmake \
    perl \
    make \
    libde265-dev \
    libopenjp2-7-dev \
    librsvg2-dev \
    libwebp-dev \
    libraw-dev \
    && apt-get build-dep -y imagemagick \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home

# Build libheif
ENV LIBHEIF_VERSION=1.19.5
RUN cd /home && git clone https://github.com/strukturag/libheif.git \
    && cd libheif \
    && git switch tags/v${LIBHEIF_VERSION} --detach \
    && mkdir build \
    && cd build \
    && cmake --preset=release .. \
    && make install

# Build libraw
ENV LIBRAW_VERSION=0.21.3
RUN cd /home && mkdir libraw \
    && curl https://www.libraw.org/data/LibRaw-${LIBRAW_VERSION}.tar.gz | tar zx -C libraw --strip-components 1 \
    && cd libraw \
    && ./configure \
    && make -j 4 \
    && make install

# Build ImageMagick
ENV IMAGEMAGICK_VERSION=7.1.1-43
RUN cd /home && mkdir ImageMagick \
    && curl https://imagemagick.org/archive/ImageMagick-${IMAGEMAGICK_VERSION}.tar.gz | tar zx -C ImageMagick --strip-components 1 \
    && cd ImageMagick \
    && ./configure --with-heic=yes --with-raw=yes \
    && make -j 4 \
    && make install \
    && ldconfig && convert -version

# Build ExifTool
ENV EXIFTOOL_VERSION=13.10
RUN cd /home && mkdir Image-ExifTool \
    && curl https://exiftool.org/Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz | tar zx -C Image-ExifTool --strip-components 1 \
    && cd Image-ExifTool \
    && perl Makefile.PL \
    && make test -j 4 \
    && make install -j 4 \
    && ldconfig && exiftool -ver

# Runtime stage
FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies only
RUN apt-get update && apt-get install --no-install-recommends -y \
    # libraw for imagemagick
    libraw-bin \
    # deps for imagemagick
    libjbig0 webp libopenjp2-7 liblcms2-2 libzstd1 libdeflate0 libbrotli1 libsharpyuv0 libmd0 libde265-0 librsvg2-2 liblzma5 liblqr-1-0 libdjvulibre21 openexr \
    procps \
    # and lastly, fonts
    fontconfig fonts-liberation \
    # GDI+ and ONNX 
    libgomp1 libgdiplus libc6-dev \
    # ufraw - for ImageMagick Sony conversions
    dcraw \
    && rm -rf /var/lib/apt/lists/* \
    && fc-cache -f -v

# Copy built artifacts from builder
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/share /usr/local/share
COPY --from=builder /usr/local/include /usr/local/include

# Update library cache
RUN ldconfig && convert -version | tee /home/imagemagick_version.txt

WORKDIR /home

ADD VERSION .

CMD ["/bin/bash"]
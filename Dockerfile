FROM ubuntu:20.04 as final

# Copy the entrypoint script
COPY ./entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]
ADD VERSION .

# Need sudo for the iNotify count increase
# RUN set -ex && apt-get install -y sudo

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
                        # proxps 
                        proxps \
                        # exiftool
                        exiftool \
                        # GDI+ and ONNX 
                        libgomp1 apt-utils libgdiplus libc6-dev \
                        # Now the emgucv stuff 
                        libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev \
                        libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev \
                        # and lastly, fonts
                        fontconfig fonts-liberation

# init the font caches
RUN fc-cache -f -v

# Clean the cache to save space
RUN apt-get clean 

ENTRYPOINT ["sh","/entrypoint.sh"]

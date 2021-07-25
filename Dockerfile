
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS final

# Copy the entrypoint script
COPY ./entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]
ADD VERSION .

RUN apt update
RUN apt install -y procps
 
# Need sudo for the iNotify count increase
# RUN set -ex && apt-get install -y sudo

# Add Microsoft fonts that'll be used for watermarking
RUN sed -i'.bak' 's/$/ contrib/' /etc/apt/sources.list
RUN apt-get update && apt-get install -y ttf-mscorefonts-installer fontconfig

# Add ExifTool
RUN apt install -y exiftool 

# Stuff for GDI+
RUN apt install -y libgomp1 apt-utils libgdiplus libc6-dev 

# Stuff for EmguCV
RUN apt install -y libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev

ENTRYPOINT ["sh","/entrypoint.sh"]

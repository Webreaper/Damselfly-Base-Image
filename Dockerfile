FROM ubuntu:20.04

RUN apt update

#Add basic packages required to install dotnet repo
RUN apt -y install wget 

# Add dotnet repo
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt update
RUN apt -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
                        lsb-release \
                        curl wget gnupg apt-transport-https \
                        # proxps 
                        procps \
                        # exiftool
                        exiftool \
                        # and lastly, fonts
                        fontconfig fonts-liberation \
                        # GDI+ and ONNX 
                        libgomp1 apt-utils libgdiplus libc6-dev 
                        

# init the font caches
RUN fc-cache -f -v

# === Now, all the stuff for building the emgu console app ===
# First, add the .net Repo for the SDK/Runtime
RUN apt -y install dotnet-sdk-5.0 aspnetcore-runtime-5.0 \
            # Now the emgucv dependencies
           libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev \
           libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev 
WORKDIR "/emgu"
COPY emgu .
RUN sh build_emgu_sample.sh
# === Done ===

# Need sudo for the iNotify count increase
# RUN set -ex && apt-get install -y sudo

# Copy the entrypoint script
COPY ./entrypoint.sh /
RUN ["chmod", "+x", "/entrypoint.sh"]

ADD VERSION .

ENTRYPOINT ["sh","/entrypoint.sh"]

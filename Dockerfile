FROM ubuntu:20.04

RUN apt update

#Add basic packages required to install bazel and dotnet repo
RUN apt -y install wget 

#Add dotnet repo
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt update
RUN apt -y upgrade
RUN apt -y install dotnet-sdk-5.0 aspnetcore-runtime-5.0

#Create a new folder for our project
RUN mkdir -p /emgu

#Change work dir
WORKDIR "/emgu"

#Create a new console program
RUN dotnet new console

#COPY the source code to the docker image
COPY Program.cs "/emgu/Program.cs"
COPY emgu.csproj "/emgu/emgu.csproj"
COPY Oscars.jpeg "/emgu/Oscars.jpeg"
COPY haarcascade_frontalface_default.xml "/emgu/haarcascade_frontalface_default.xml"

#Restore nuget packages
RUN dotnet restore

RUN dotnet publish emgu.csproj -r linux-x64 -f net5.0 -c Release --self-contained true /p:Version=$version /p:PublishSingleFile=true /p:PublishTrimmed=true /p:IncludeNativeLibrariesForSelfExtract=true
RUN ls emgu/bin/Release/net5.0/linux-x64/publish

RUN apt-get update
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
                        libgomp1 apt-utils libgdiplus libc6-dev \
                        # Now the emgucv stuff 
                        libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev \
                        libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev 

# init the font caches
RUN fc-cache -f -v

#run the program
ENTRYPOINT ["sh", "emgu/bin/Release/net5.0/linux-x64/publish"]

# Copy the entrypoint script
# COPY ./entrypoint.sh /
# RUN ["chmod", "+x", "/entrypoint.sh"]
# ADD VERSION .

# # Need sudo for the iNotify count increase
# # RUN set -ex && apt-get install -y sudo

# ENTRYPOINT ["sh","/entrypoint.sh"]

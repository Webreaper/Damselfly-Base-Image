FROM emgu/bazel-android:dotnet-5.0-bazel-4.0
#FROM ubuntu:20.04 as final

#Create a new folder for our project
RUN mkdir -p /emgu

#Change work dir
WORKDIR "/emgu"

#Add nuget.org as a source:
#RUN dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org

#Create a new console program
RUN dotnet new console

#Add Emgu.CV.runtime package
#RUN dotnet add package Emgu.CV.runtime.ubuntu.20.04-x64 --version 4.5.1.4349

#COPY the source code to the docker image
COPY Program.cs "/emgu/Program.cs"
COPY emgu.csproj "/emgu/emgu.csproj"
COPY Oscars.jpeg "/emgu/Oscars.jpeg"
COPY haarcascade_frontalface_default.xml "/emgu/haarcascade_frontalface_default.xml"

#Restore nuget packages
RUN dotnet restore

#Compile the program
RUN dotnet build

#run the program
ENTRYPOINT ["dotnet", "run"]

# Copy the entrypoint script
# COPY ./entrypoint.sh /
# RUN ["chmod", "+x", "/entrypoint.sh"]
# ADD VERSION .

# # Need sudo for the iNotify count increase
# # RUN set -ex && apt-get install -y sudo

# RUN apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
#                         lsb-release \
#                         curl wget gnupg apt-transport-https \
#                         # proxps 
#                         procps \
#                         # exiftool
#                         exiftool \
#                         # and lastly, fonts
#                         fontconfig fonts-liberation \
#                         # GDI+ and ONNX 
#                         libgomp1 apt-utils libgdiplus libc6-dev \
#                         # Now the emgucv stuff 
#                         libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev \
#                         libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev 

# # init the font caches
# RUN fc-cache -f -v

# ENTRYPOINT ["sh","/entrypoint.sh"]

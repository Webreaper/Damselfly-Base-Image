# Use the bazel-android image
# FROM emgu/bazel-android:dotnet-5.0-bazel-4.0
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS final

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

RUN apt-get update
RUN apt-get install -y libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev
RUN apt-get install -y build-essential libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev
RUN apt-get install -y cups libc6-dev libgdiplus libicu-dev libharfbuzz0b libfontconfig1 libfreetype6 libpango-1.0-0 libpangocairo-1.0

#run the program
ENTRYPOINT ["dotnet", "run"]


FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS final

WORKDIR /app
COPY EmguCVSample/bin/Release/net5.0/linux-x64/publish .
RUN chmod +x EmguCVSample

RUN apt-get update
RUN apt-get install -y build-essential libgtk-3-dev libgstreamer1.0-dev libavcodec-dev libswscale-dev libavformat-dev libdc1394-22-dev libv4l-dev cmake-curses-gui ocl-icd-dev freeglut3-dev libgeotiff-dev libusb-1.0-0-dev


COPY ./emgu-entrypoint.sh /
RUN ["chmod", "+x", "/emgu-entrypoint.sh"]

ENTRYPOINT ["sh","/emgu-entrypoint.sh"]

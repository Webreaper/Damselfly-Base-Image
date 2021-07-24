
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
RUN sudo apt install -y exiftool 

RUN apt install -y libgomp1 apt-utils libgdiplus libc6-dev 

ENTRYPOINT ["sh","/entrypoint.sh"]

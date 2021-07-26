#!/bin/bash

#Restore nuget packages
dotnet new console
dotnet restore
dotnet publish emgu.csproj -r linux-x64 -f net5.0 -c Release /p:Version=1.0.0 

echo "Build complete. Installing libcvextern.so...."
wget https://www.nuget.org/api/v2/package/Emgu.CV.runtime.ubuntu.20.04-x64/4.5.1.4349
unzip 4.5.1.4349
cp runtimes/ubuntu.20.04-x64/native/libcvextern.so /emgu/bin/Release/net5.0/linux-x64/publish

ls /emgu/bin/Release/net5.0/linux-x64/publish

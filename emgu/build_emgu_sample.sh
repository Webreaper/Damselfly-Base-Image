#!/bin/bash

#Restore nuget packages
dotnet new console
dotnet restore
dotnet publish emgu.csproj -r linux-x64 -f net5.0 -c Release /p:Version=1.0.0 

echo "Build complete. Publish folder contents:"
ls /emgu/bin/Release/net5.0/linux-x64/publish

unzip libcvextern.zip
cp libcvextern.so /emgu/bin/Release/net5.0/linux-x64/publish
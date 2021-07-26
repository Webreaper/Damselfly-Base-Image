#!/bin/bash
set -e

# echo "Increasing inotify watch limit..."
# echo fs.inotify.max_user_instances=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p    

echo "Dotnet Run:"
dotnet run

cd /emgu/bin/Release/net5.0/linux-x64/
echo "Run emgu in linux-x64"
./emgu
echo "Run emgu.dll in linux-x64"
./emgu.dll
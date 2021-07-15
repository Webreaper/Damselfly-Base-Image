export MSBuildEnableWorkloadResolver=false
dotnet publish EmguCVSample.sln -r linux-x64 -c Release --self-contained true /p:PublishSingleFile=true /p:Version=1.0.0 /p:IncludeNativeLibrariesForSelfExtract=true

docker buildx build --platform linux/amd64 --push -t webreaper/emgusample:dev .

#docker tag emgusample webreaper/emgusample:dev
#docker push webreaper/emgusample:dev
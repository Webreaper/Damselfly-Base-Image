export MSBuildEnableWorkloadResolver=false
dotnet publish EmguCVSample.sln -r linux-x64 -c Release /p:Version=1.0.0 # --self-contained true /p:PublishSingleFile=true /p:IncludeNativeLibrariesForSelfExtract=true

docker buildx build --platform linux/amd64 --push -t webreaper/emgusample:dev .

#docker tag emgusample webreaper/emgusample:dev
#docker push webreaper/emgusample:dev
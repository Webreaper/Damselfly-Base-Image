
if [ -z "$1" ]; then
    echo 'No docker tag specified. Pushing to dev'
    DOCKERTAG='dev'
else
    version=`cat VERSION`
    DOCKERTAG="${version}-beta"
    echo "Master specified - creating tag: ${DOCKERTAG}"
fi

echo "**** Building Docker Damselfly Base Image"
docker build -t damselfly-base . 

echo "*** Pushing docker image to webreaper/damselfly-base:${DOCKERTAG}"

docker tag damselfly-base webreaper/damselfly-base:$DOCKERTAG
docker push webreaper/damselfly-base:$DOCKERTAG

if [ -n "$1" ]
then
    echo "*** Pushing docker image to webreaper/damselfly-base:latest"
    docker tag damselfly-base webreaper/damselfly-base:latest
    docker push webreaper/damselfly-base:latest
fi

echo "Damselfly docker base image build complete."

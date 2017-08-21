#!/usr/bin/env bash

VERSIONS=$(git ls-remote --tags https://github.com/emqtt/emq-relx.git | awk  '{ print $2 }' | sed 's/refs\/tags\///g' | sed 's/\^{}//g' | uniq)

cat emq-docker-master/Dockerfile | sed 's/ENV EMQ_VERSION/ARG EMQ_VERSION/g' > emq-docker-master/Dockerfile.patched

cp -f emq-docker-master/Dockerfile.patched emq-docker-master/Dockerfile.patched-hacked
echo "COPY ../hacked-start.sh /opt/emqttd/" >> emq-docker-master/Dockerfile.patched-hacked
echo "CMD /opt/emqttd/hacked-start.sh" >> emq-docker-master/Dockerfile.patched-hacked

function docker_tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}

for VERSION in ${VERSIONS} ; do \
  if docker_tag_exists chrisns/emq ${VERSION}; then
    echo ${VERSION} already exists
  else
    echo ${VERSION} does not yet exist
    docker build -t chrisns/emq:${VERSION}        --build-arg EMQ_VERSION=${VERSION} -f emq-docker-master/Dockerfile.patched        emq-docker-master
    docker push chrisns/emq:${VERSION}
  fi

#hacked image builder
  if docker_tag_exists chrisns/emq ${VERSION}-hacked; then
    echo ${VERSION}-hacked already exists
  else
    echo ${VERSION}-hacked does not yet exist
    docker build -t chrisns/emq:${VERSION}-hacked --build-arg EMQ_VERSION=${VERSION} -f emq-docker-master/Dockerfile.patched-hacked emq-docker-master
    docker push chrisns/emq:${VERSION}-hacked
  fi


done

#!/usr/bin/env bash

VERSIONS=$(git ls-remote --tags git@github.com:emqtt/emq-relx.git | awk  '{ print $2 }' | sed 's/refs\/tags\///g' | sed 's/\^{}//g' | uniq)

cat emq-docker-master/Dockerfile | sed 's/ENV EMQ_VERSION/ARG EMQ_VERSION/g' > emq-docker-master/Dockerfile.patched


function docker_tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}



for VERSION in ${VERSIONS} ; do \
  if docker_tag_exists chrisns/emq ${VERSION}; then
    echo ${VERSION} already exists
  else
    echo ${VERSION} does not yet exist
    docker build -t chrisns/emq:${VERSION} --build-arg EMQ_VERSION=${VERSION} -f emq-docker-master/Dockerfile.patched emq-docker-master
    docker push chrisns/emq:${VERSION}
  fi
done




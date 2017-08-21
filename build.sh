#!/usr/bin/env bash

VERSIONS=$(git ls-remote --tags git@github.com:emqtt/emq-relx.git | awk  '{ print $2 }' | sed 's/refs\/tags\///g' | sed 's/\^{}//g' | uniq)

git clone -b master https://github.com/emqtt/emq_docker.git

cat emq_docker/Dockerfile | sed 's/ENV EMQ_VERSION/ARG EMQ_VERSION/g' > emq_docker/Dockerfile.patched


function docker_tag_exists() {
    curl --silent -f -lSL https://index.docker.io/v1/repositories/$1/tags/$2 > /dev/null
}



for VERSION in ${VERSIONS} ; do \
  if docker_tag_exists chrisns/emq ${VERSION}; then
    echo ${VERSION} already exists
  else
    echo ${VERSION} does not yet exist
    docker build -t chrisns/emq:${VERSION} --build-arg EMQ_VERSION=${VERSION} -f emq_docker/Dockerfile.patched emq_docker
    echo docker push chrisns/emq:${VERSION}
  fi
done




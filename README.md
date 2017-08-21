# Auto builder of #EMQ
[![Build Status](https://travis-ci.org/chrisns/docker-emq.svg?branch=master)](https://travis-ci.org/chrisns/docker-emq)
![](https://img.shields.io/docker/stars/chrisns/emq.svg)
![](https://img.shields.io/docker/pulls/chrisns/emq.svg)
[![license](https://img.shields.io/github/license/chrisns/emq.svg)]()
[![GitHub contributors](https://img.shields.io/github/contributors/chrisns/emq.svg)]()
[![GitHub issues](https://img.shields.io/github/issues/chrisns/emq.svg)]()

Runs every 24 hrs on Travis cron, builds a docker image for every emq-relx tagged release if one doesn't exist, then pushes that to docker hub

[List of available tags](https://hub.docker.com/r/chrisns/emq/tags/)

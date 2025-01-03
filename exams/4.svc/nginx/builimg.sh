#!/usr/bin/env bash
docker image rm ngovanhuy0241/k8s_container:nginx
docker build -t ngovanhuy0241/k8s_container:nginx --force-rm -f Dockerfile .
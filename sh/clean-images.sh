#/usr/bin/env bash

# docker ps -a |grep Exited | awk '{print $1}' | xargs docker rm

docker ps -a |grep -v Up | awk '{print $1}' | xargs docker rm

docker images | grep "<none>" |awk '{print $3}' | xargs docker rmi

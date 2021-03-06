#!/usr/bin/env bash

IMAGE=$1
img=""

if [[ "$IMAGE" =~ ^quay\.io.* ]]; then
    echo "--> Use qiniu mirror for quay.io"
    img="quay-mirror.qiniu.com"${IMAGE:7}

fi


if [[ "$IMAGE" =~ ^gcr\.io.* ]]; then
    echo "--> Use aliyun mirror for gci.io"
    img="registry.aliyuncs.com"${IMAGE:6}
fi


echo "--> Pulling $img"
docker pull $img
echo "--> Tag image"
docker tag $img $IMAGE

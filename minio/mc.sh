#!/usr/bin/env bash

set -x

which minio &>/dev/null || {
  pushd /var/tmp

  wget https://dl.min.io/client/mc/release/linux-amd64/mc
  chmod +x mc
  mv mc /usr/local/bin

  #mc config host add minio http://.xip.io:9000 minioadmin minioadmin
  #mc mb minio/consul-snapshot
  #mc admin policy add minio user https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/minio/policy/s3-snapshot.json

  popd
}
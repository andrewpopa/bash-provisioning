#!/usr/bin/env bash

set -x

which minio &>/dev/null || {
  pushd /var/tmp
  
  wget https://dl.min.io/server/minio/release/linux-amd64/minio
  chmod +x minio
  mv minio /usr/local/bin

  mkdir -p /data
  chown -R vagrant /data
  chmod u+rxw /data

  cp https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/minio/conf/minio /etc/default/minio
  cp https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/minio/conf/minio.service /etc/systemd/system/minio.service

  systemctl enable minio
  systemctl start minio
  systemctl status minio

  popd
}

#!/usr/bin/env bash

which curl tar &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y curl tar
}

# check arch
if [[ "`uname -m`" =~ "arm" ]]; then
  ARCH=arm
elif [[ "`uname -m`" == "aarch64" ]]; then
  ARCH=arm64
else
  ARCH=amd64
fi

which node_exporter &>/dev/null || {
  curl -sL -o /tmp/node_exporter.tgz https://github.com/prometheus/node_exporter/releases/download/v${NODE_VERSION}/node_exporter-${NODE_VERSION}.linux-${ARCH}.tar.gz
  tar zxvf /tmp/node_exporter.tgz -C /usr/local/
  ln -s /usr/local/node_exporter-${NODE_VERSION}.linux-${ARCH}/node_exporter /usr/local/bin/node_exporter
}

curl -sL -o /etc/systemd/system/node_exporter.service https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/prometheus/node_exporter.service

systemctl enable node_exporter.service
systemctl start node_exporter.service

[ -d /etc/consul.d ] && {
  curl -sL -o /etc/consul.d/node_exporter.hcl https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/prometheus/node_exporter.hcl
}

systemctl reload consul_client.service

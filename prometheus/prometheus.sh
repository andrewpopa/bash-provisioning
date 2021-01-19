#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

which prometheus &>/dev/null || {
  apt-get update
  apt-get install --no-install-recommends -y curl wget tar

  # check arch
  if [[ "`uname -m`" =~ "arm" ]]; then
    ARCH=arm
  elif [[ "`uname -m`" == "aarch64" ]]; then
    ARCH=arm64
  else
    ARCH=amd64
  fi

  cd /usr/local
  
  wget -q https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-${ARCH}.tar.gz
  tar zxvf prometheus-${PROMETHEUS_VERSION}.linux-${ARCH}.tar.gz

  ln -s /usr/local/prometheus-${PROMETHEUS_VERSION}.linux-${ARCH}/prometheus /usr/local/bin/prometheus
  ln -s /usr/local/prometheus-${PROMETHEUS_VERSION}.linux-${ARCH}/promtool /usr/local/bin/promtool
}

# create directory structure
mkdir -p /etc/prometheus
curl -sL -o /etc/prometheus/prometheus.yml https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/prometheus/prometheus.yml
curl -sL -o /etc/systemd/system/prometheus.service https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/prometheus/prometheus.service

systemctl enable prometheus.service
systemctl start prometheus.service

[ -d /etc/consul.d ] && {
  curl -sL -o /etc/consul.d/prometheus.hcl https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/prometheus/prometheus.hcl
}

systemctl reload consul_client.service
curl -sL -o /etc/prometheus/prometheus.ctpl https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/prometheus/prometheus.ctpl
curl -sL -o /tmp/consul_template.sh https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/consul/consul_template.sh
bash /tmp/consul_template.sh

curl -sL -o /etc/systemd/system/consul_template.service https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/consul/consul_template.service
systemctl enable consul_template.service
systemctl restart consul_template.service

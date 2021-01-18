#!/usr/bin/env bash

# we want the scrip to be verbose
set -x

# install packages if not installed
which curl wget unzip jq &>/dev/null || {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install --no-install-recommends -y curl wget unzip jq
}

# check arch
if [[ "`uname -m`" =~ "arm" ]]; then
  ARCH=arm
elif [[ "`uname -m`" == "aarch64" ]]; then
  ARCH=arm64
else
  ARCH=amd64
fi

# get current version of consul that is not beta/alpha
CONSULVER=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep 'ent' | egrep -v 'beta|rc' | tail -n1)

# check if consul is installed
# if not, download and configure service
which consul &>/dev/null || {
  pushd /var/tmp
  echo Installing consul ${CONSULVER}
  wget https://releases.hashicorp.com/consul/${CONSULVER}/consul_${CONSULVER}_linux_${ARCH}.zip
  unzip consul_${CONSULVER}_linux_${ARCH}.zip
  chown root:root consul
  mv consul /usr/local/bin
  consul -autocomplete-install
  complete -C /usr/local/bin/consul consul
  
  # create consul user
  useradd --system --home /opt/consul --shell /bin/false consul
  
  # consul data directory
  [ -d /opt/consul ] || {
    mkdir --parents /opt/consul
    chown --recursive consul:consul /opt/consul
  }
  
  # copy consul configuration 
  mkdir --parents /etc/consul.d
  curl -sL -o /etc/consul.d/server.hcl https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/consul/server.hcl
  chown --recursive consul:consul /etc/consul.d
  chmod 640 /etc/consul.d/server.hcl
  
  # copy service definition
  curl -sL -o /etc/systemd/system/consul.service https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/consul/consul.service
    
  # enable and start service
  systemctl enable consul
  systemctl start consul
}

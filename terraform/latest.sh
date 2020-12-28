#!/usr/bin/env bash

which terraform &>/dev/null || {
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

  TFVERSION=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)

  wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TFVERSION}/terraform_${TFVERSION}_linux_${ARCH}.zip
  unzip -o -d /usr/local/bin /tmp/terraform.zip
}

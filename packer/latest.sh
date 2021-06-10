#!/usr/bin/env bash

which packer &>/dev/null || {
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

  PACKERVERSION=$(curl -sL https://releases.hashicorp.com/packer/index.json | jq -r '.versions[].version' | sort -V | tail -n1)

  wget -q -O /tmp/packer.zip https://releases.hashicorp.com/packer/${PACKERVERSION}/packer_${PACKERVERSION}_linux_${ARCH}.zip
  unzip -o -d /usr/local/bin /tmp/packer.zip
}

# Jenkins

Will install Jenkins on linux box

- [Jenkins](https://www.jenkins.io/)

# How to consume

curl 

```bash
curl https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/jenkins/jenkins.sh | bash
```

vagrant

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "jenkins"
  config.vm.provision "shell", 
    path: "https://raw.githubusercontent.com/andrewpopa/bash-provisioning/main/jenkins/jenkins.sh"
end
```
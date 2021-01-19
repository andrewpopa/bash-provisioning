client_addr        = "127.0.0.1"
bind_addr          = "{{ GetInterfaceIP \"enp0s8\" }}"
data_dir           = "/opt/consul"
datacenter         = "dc1"
log_level          = "DEBUG"
server             = false
enable_syslog      = true
retry_join         = ["192.168.178.51", "192.168.178.52", "192.168.178.53"]
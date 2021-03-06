bootstrap_expect   = 3
client_addr        = "0.0.0.0"
bind_addr          = "{{ GetInterfaceIP \"enp0s8\" }}"
data_dir           = "/opt/consul"
datacenter         = "dc1"
log_level          = "INFO"
server             = true
ui                 = true
non_voting_server  = false
enable_local_script_checks = true
retry_join         = ["192.168.178.51", "192.168.178.52", "192.168.178.53"]

autopilot         = {
  cleanup_dead_servers      = true,
  last_contact_threshold    ="200ms",
  max_trailing_logs         = 250,
  server_stabilization_time = "10s",
  redundancy_zone_tag       = "zone",
  disable_upgrade_migration = false,
  upgrade_version_tag       = "",
}

telemetry = {
  prometheus_retention_time = "24h",
  disable_hostname = true
}

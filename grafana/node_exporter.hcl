service = {
  name = "node_exporter"
  port = 9100
  tags = ["http"]
}

checks = {
  name = "node_exporter-basic-connectivity"
  tcp = "localhost:9100"
  interval = "10s"
  timeout = "1s"
}
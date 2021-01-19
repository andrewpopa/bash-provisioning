service = {
  name = "prometheus"
  port = 9090
}
checks = {
  name = "prometheus-basic-connectivity"
  tcp = "localhost:9090"
  interval = "10s"
  timeout = "1s"
}

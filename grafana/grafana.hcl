{
  "service": {
    "name": "grafana",
    "port": 3000
  },
  "checks": [
    {
      "name": "grafana-basic-connectivity",
      "tcp": "localhost:3000",
      "interval": "10s",
      "timeout": "1s"
    }
  ]
}

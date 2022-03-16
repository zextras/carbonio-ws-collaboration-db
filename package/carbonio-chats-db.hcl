services {
  check {
    tcp      = "127.78.0.101:5432"
    timeout  = "1s"
    interval = "5s"
  }
  connect {
    sidecar_service {
      proxy {
        local_service_address = "127.78.0.101"
      }
    }
  }
  name = "carbonio-chats-db"
  port = 5432
}

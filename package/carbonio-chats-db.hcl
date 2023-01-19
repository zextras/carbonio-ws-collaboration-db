services {
  check {
    tcp      = "127.0.0.1:5432"
    timeout  = "1s"
    interval = "5s"
  }
  connect {
    sidecar_service {}
  }
  name = "carbonio-chats-db"
  port = 5432
}

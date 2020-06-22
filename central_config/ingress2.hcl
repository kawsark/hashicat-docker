Kind = "ingress-gateway"
Name = "ingress-gateway"

Listeners = [
  {
    Port     = 8080
    Protocol = "http"
        Services = [
      {
        Name  = "hashicat"
        Hosts = "*"
      }
    ]
  },
  {
    Port     = 8180
    Protocol = "http"
        Services = [
      {
        Name  = "hashicat-web"
        Hosts = "*"
      }
    ]
  }
]
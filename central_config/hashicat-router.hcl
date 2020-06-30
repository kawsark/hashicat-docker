# NOTE: Routes are evaluated in order. The first route to match will stop
# processing.

kind = "service-router"
name = "hashicat"
routes = [
  {
    match {
      http {
        path_prefix = "/"
      }
    }

    destination {
      service = "hashicat-web"
    }
  }
]
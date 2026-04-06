terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

# --- MySQL ---

resource "kubernetes_secret_v1" "mysql_secret" {
  metadata {
    name      = "${var.site_name}-mysql-credentials"
    namespace = var.namespace
  }

  data = {
    MYSQL_ROOT_PASSWORD = var.admin_password
    MYSQL_DATABASE      = "wordpress"
    MYSQL_USER          = "wordpress"
    MYSQL_PASSWORD      = var.admin_password
  }
}

resource "kubernetes_persistent_volume_claim_v1" "mysql_data" {
  metadata {
    name      = "${var.site_name}-mysql-data"
    namespace = var.namespace
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class

    resources {
      requests = {
        storage = "${var.storage_size}Gi"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "mysql" {
  metadata {
    name      = "${var.site_name}-mysql"
    namespace = var.namespace

    labels = {
      app                      = "${var.site_name}-mysql"
      "hybr.cloud/managed-by"  = "hybr"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.site_name}-mysql"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.site_name}-mysql"
        }
      }

      spec {
        container {
          name  = "mysql"
          image = "mysql:8.0"

          port {
            container_port = 3306
          }

          env_from {
            secret_ref {
              name = kubernetes_secret_v1.mysql_secret.metadata[0].name
            }
          }

          volume_mount {
            name       = "mysql-data"
            mount_path = "/var/lib/mysql"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "1Gi"
            }
          }
        }

        volume {
          name = "mysql-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.mysql_data.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mysql" {
  metadata {
    name      = "${var.site_name}-mysql"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "${var.site_name}-mysql"
    }

    port {
      port        = 3306
      target_port = 3306
    }

    type = "ClusterIP"
  }
}

# --- WordPress ---

resource "kubernetes_persistent_volume_claim_v1" "wordpress_data" {
  metadata {
    name      = "${var.site_name}-wp-data"
    namespace = var.namespace
  }

  spec {
    access_modes       = ["ReadWriteOnce"]
    storage_class_name = var.storage_class

    resources {
      requests = {
        storage = "${var.storage_size}Gi"
      }
    }
  }
}

resource "kubernetes_deployment_v1" "wordpress" {
  metadata {
    name      = "${var.site_name}-wordpress"
    namespace = var.namespace

    labels = {
      app                      = "${var.site_name}-wordpress"
      "hybr.cloud/managed-by"  = "hybr"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.site_name}-wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.site_name}-wordpress"
        }
      }

      spec {
        container {
          name  = "wordpress"
          image = "wordpress:6-apache"

          port {
            container_port = 80
          }

          env {
            name  = "WORDPRESS_DB_HOST"
            value = kubernetes_service_v1.mysql.metadata[0].name
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "wordpress"
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.mysql_secret.metadata[0].name
                key  = "MYSQL_PASSWORD"
              }
            }
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "wordpress"
          }

          volume_mount {
            name       = "wp-data"
            mount_path = "/var/www/html"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "512Mi"
            }
          }
        }

        volume {
          name = "wp-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.wordpress_data.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "wordpress" {
  metadata {
    name      = "${var.site_name}-wordpress"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "${var.site_name}-wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

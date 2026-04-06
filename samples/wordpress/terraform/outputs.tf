output "mysql_host" {
  description = "MySQL service hostname"
  value       = "${kubernetes_service_v1.mysql.metadata[0].name}.${var.namespace}.svc.cluster.local"
}

output "wordpress_host" {
  description = "WordPress service hostname"
  value       = "${kubernetes_service_v1.wordpress.metadata[0].name}.${var.namespace}.svc.cluster.local"
}

output "wordpress_port" {
  description = "WordPress service port"
  value       = "80"
}

variable "namespace" {
  description = "Kubernetes namespace for the WordPress deployment"
  type        = string
}

variable "site_name" {
  description = "Name for the WordPress site"
  type        = string
  default     = "my-wordpress"
}

variable "admin_email" {
  description = "WordPress admin email address"
  type        = string
  default     = ""
}

variable "admin_password" {
  description = "WordPress admin and MySQL password"
  type        = string
  sensitive   = true
}

variable "storage_class" {
  description = "Storage class for persistent volumes"
  type        = string
  default     = "default"
}

variable "storage_size" {
  description = "Storage size in Gi"
  type        = string
  default     = "10"
}

variable "container_registry" {
  description = "Container registry URL"
  type        = string
  default     = "registry.hybr.cloud:5000"
}

variable "mysql_host" {
  description = "MySQL service hostname (set by workflow)"
  type        = string
  default     = ""
}

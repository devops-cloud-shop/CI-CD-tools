variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "zone_name" {
  type        = string
  default     = "prav4cloud.online"
  description = "description"
}

variable "zone_id" {
  type        = string
  default     = "Z07156123N66DZ6JZ182I"
  description = "description"
}

variable "sonar" {
  default = false
}
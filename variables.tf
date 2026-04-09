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
  default     = "Z0258322TB5OSJHYCLEQ"
  description = "description"
}

variable "sonar" {
  default = false
}
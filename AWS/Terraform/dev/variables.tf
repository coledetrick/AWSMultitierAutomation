variable "name" {
  type    = string
  default = "app"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/28", "10.0.0.32/28"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.16/28", "10.0.0.48/28"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "ami_id" {
  type    = string
  default = "ami-0ebf411a80b6b22cb"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_name" {
  type    = string
  default = "db01"
}

variable "db_username" {
  type    = string
  default = "username"
}

variable "db_password" {
  type    = string
  default = "password"
  sensitive = true
}

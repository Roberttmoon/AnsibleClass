variable "subscription_id" {}
variable "client_id" {}
variable "secret" {}
variable "tenant" {}
variable "location" {}

variable "prefix" {
  default = "table3-rm"
}

variable "tags" {
  type = "map"
  default = {
    env   = "learning"
    owner = "robert"
    table = "table3"
  }
}

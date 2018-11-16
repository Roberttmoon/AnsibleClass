variable "resource_group_name" {}
variable "vm_count" {}
variable "location" {}
variable "prefix" {}
variable "app" {}

variable "computer_name" {
  description = "all lowercase, no symbles"
}

varaible "tags" {
  type = "map"
}

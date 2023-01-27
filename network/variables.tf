variable "vpc-cidr" {
#   default = "10.0.0.0/24"
}
variable "vpc-name" {
  
}
variable "igw-name" {
  
}
variable "nat-name" {
  
}
variable "subnet-cidr" {
  type = list
}
variable "availability-zone" {
 type = list
}
variable "subnet-name" {
  type = list
}
variable "subnet-cidr-2" {
  type = list
}
variable "availability-zone-2" {
 type = list
}
variable "subnet-name-2" {
  type = list
}
variable "route-table-public-cidr"{

}
variable "route-table-public"{

}
variable "route-table-private"{

}
variable "security-group-name"{
    
}

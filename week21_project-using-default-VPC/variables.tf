variable "region" {
  type    = string
  default = "us-east-1"
}
variable "ami_id" {
  type = map(any)
  default = {
    us-east-1 = "ami-053b0d53c279acc90"
  }
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "public_subnets" {

  type = list(string)
  default = [
  "public_subnet_a", "public_subnet_b"]
}
#variable "private_subnets" {

#type = list(string)
#default = [
#"private_subnet_a", "private_subnet_b"]
#}
#variable "vpc_cidr" {
#type    = string
#default = "10.0.0.0/16"
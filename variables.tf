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

  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
  }

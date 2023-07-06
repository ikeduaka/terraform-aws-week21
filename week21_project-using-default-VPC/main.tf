# Configure the AWS Provider

provider "aws" {
  region = "us-east-1"
}

# default VPC 

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
  enable_dns_hostnames = true
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

#Create subnets in the first two available availability zones

resource "aws_subnet" "public_subnet-1" {
  #for_each                = var.public_subnets
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.96.0/20"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet-1"
  }

}
resource "aws_subnet" "public_subnet-2" {
  #for_each                = var.public_subnets
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = "172.31.112.0/20"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public_subnet-2"
  }
}

# Creating Launch-Template for autoscaling

resource "aws_launch_template" "week21_launch_template" {
  name = "week21-ec2-${random_id.random.hex}"

  image_id      = lookup(var.ami_id, var.region)
  instance_type = var.instance_type

  key_name  = "jenkins-new"
  user_data = filebase64("${path.module}/user-data.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_default_security_group.default.id]
  }
  tags = {
    Name = "week21-ec2-${random_id.random.hex}"
  }
}

# Creating a default security group 

resource "aws_default_security_group" "default" {
  #name        = "default"
  vpc_id = aws_default_vpc.default.id

  ingress {
    # SSH Port 22 allowed 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # inbound traffic from anywhere 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "week21-sg"
  }
}

resource "random_id" "random" {
  byte_length = 8
}

#output "launch_template_id" {
  #description = "The ID of the launch template"
  #value       = aws_launch_template.week21_launch_template.id
#}

module "asg" {
  source  = "./modules/autoscaling_module"

  # Autoscaling group
  name = "week21_asg"
  #security_groups    = [aws_default_security_group.default.id]
  #target_group_arns = [aws_lb_target_group.week21_tg.arn]
  subnets            = [aws_subnet.public_subnet-1.id, aws_subnet.public_subnet-2.id]
  
  launch_template      = aws_launch_template.week21_launch_template.id
}


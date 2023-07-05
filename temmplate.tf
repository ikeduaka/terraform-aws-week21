# Deploy EC2 Instance using Launch Template

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
resource "random_id" "random" {
  byte_length = 16
}

# creating 2 public subnet in the default VPC

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = "172.31.96.0/20"

  availability_zone = "us-east-1b"

  tags = {
    Name = "public_subnet_a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = "172.31.112.0/20"

  availability_zone = "us-east-1c"

  tags = {
    Name = "public_subnet_b"
  }
}

resource "aws_default_security_group" "default" {
  #name        = "default"
  #description = "inbound traffic
  vpc_id = aws_default_vpc.default.id
  ingress {
    # SSH Port 22 allowed 
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    #security_groups = [aws_security_group.week21_lb.id]
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # inbound traffic from anywhere 
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #security_groups = [aws_security_group.week21_lb.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    #security_groups = [aws_security_group.week21_lb.id]
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "week21-sg"
  }
}

resource "aws_autoscaling_group" "week21_asg" {

  name             = "week21_asg"
  max_size         = 5
  min_size         = 3
  desired_capacity = 3
  #target_group_arns = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]


  launch_template {
    id      = aws_launch_template.week21_launch_template.id
    version = "$Latest"
  }
}
# default VPC 

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
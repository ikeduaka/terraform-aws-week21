resource "aws_instance" "week21-ec2" {
  ami           = "${lookup(var.ami_id, var.region)}"
  instance_type = "${var.instance_type}"
  key_name      = "jenkins-new"

  user_data = filebase64("${path.module}/user-data.sh")
  
  
  tags   = {
    Name = "week21-ec2-${random_id.random.hex}"
  }
}
resource "random_id" "random" {
  byte_length = 16
}

# default VPC 

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Security group for the resource

resource "aws_default_security_group" "default" {
  #name        = "default"
  #description = "inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    # SSH Port 22 allowed 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # inbound traffic from port 8080 
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
}

resource "aws_s3_bucket" "s3-week21-backend" {
  bucket = "s3-jenkins-${random_id.random.hex}"
  tags = {
    Name = "mynew_backend_S3 Bucket"

}
}
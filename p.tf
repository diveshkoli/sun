provider "aws" {
      region = "ap-south-1"
      access_key = "AKIAXSSUW3UQLCFEHBAL"
      secret_key = "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"
}

variable "public" {
  type = string
}
 resource "aws_key_pair" "key" {
   
   key_name = "sanjay"
   public_key = "var.public"
 }

variable "aws_vpc_cidr" {
  description = "aws_vpc_cidr"
}

variable "my_ip" {
  
}


resource "aws_vpc" "myvpc1" {
  cidr_block = var.aws_vpc_cidr
  tags = {
    Name = "Myvpc"
  }
}

resource "aws_subnet" "mysubnwt1" {
  
  vpc_id     = aws_vpc.myvpc1.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc1.id

  tags = {
    Name = "internetgateway"
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.myvpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  
  tags = {
    Name = "routetable"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysubnwt1.id
  route_table_id = aws_route_table.r.id
}

resource "aws_security_group" "mysg" {

   name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc1.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
  
 
}
resource "aws_instance" "ubuntu" {
  ami           = "ami-06033ec4cfa17096c"
  instance_type = "t2.micro"
  key_name = "sanajy"
  subnet_id = aws_subnet.mysubnwt1.id
  vpc_security_group_ids = [aws_security_group.mysg.id]
    associate_public_ip_address = true
    availability_zone = "ap-south-1a"
  

  tags = {
    Name = "HelloWorld"
  }

}

resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
  availability_zones = ["ap-south-1"]

  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = [aws_instance.ubuntu.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}

resource "aws_ebs_volume" "example" {
  availability_zone = "ap-south-1a"
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.ubuntu.id
}


output "ami" {
  value = aws_instance.ubuntu.id
}
output "myvpc-id" {
  value = aws_vpc.myvpc1.id
}

output "mysubnet-id" {
  value = aws_subnet.mysubnwt1.id
}

output "gatewayid" {
  value = aws_internet_gateway.gw.id
}

output "routetableid" {
  value = aws_route_table.r.id
}

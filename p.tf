provider "aws" {
      region = "ap-south-1"
      access_key = "AKIAXSSUW3UQLCFEHBAL"
      secret_key = "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"
}

}


resource "aws_vpc" "myvpc1" {
  cidr_block = "10.0.0.0/16"
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

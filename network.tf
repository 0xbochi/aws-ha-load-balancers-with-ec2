
resource "aws_vpc" "VPC_Projet" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "internetGateway_Projet" {
  vpc_id = aws_vpc.VPC_Projet.id
}

resource "aws_subnet" "az_subnet_1a" {
  vpc_id                  = aws_vpc.VPC_Projet.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "private-subnet-1a"
  }
}

resource "aws_subnet" "az_subnet_1b" {
  vpc_id                  = aws_vpc.VPC_Projet.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  tags = {
    Name = "private-subnet-1b"
  }
}

resource "aws_subnet" "az_subnet_2a" {
  vpc_id                  = aws_vpc.VPC_Projet.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2a"
  }
}

resource "aws_subnet" "az_subnet_2b" {
  vpc_id                  = aws_vpc.VPC_Projet.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2b"
  }
}

resource "aws_route_table" "RouteTable_Projet_Private" {
  vpc_id = aws_vpc.VPC_Projet.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "RT-Private"
  }

}

resource "aws_route_table" "RouteTable_Projet_Public" {
  vpc_id = aws_vpc.VPC_Projet.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetGateway_Projet.id
  }
  tags = {
    Name = "RT-Public"
  }
}

resource "aws_route_table_association" "az_subnet_1a_association" {
  subnet_id      = aws_subnet.az_subnet_1a.id
  route_table_id = aws_route_table.RouteTable_Projet_Private.id
}

resource "aws_route_table_association" "az_subnet_1b_association" {
  subnet_id      = aws_subnet.az_subnet_1b.id
  route_table_id = aws_route_table.RouteTable_Projet_Private.id
}

resource "aws_route_table_association" "az_subnet_2a_association" {
  subnet_id      = aws_subnet.az_subnet_2a.id
  route_table_id = aws_route_table.RouteTable_Projet_Public.id
}

resource "aws_route_table_association" "az_subnet_2b_association" {
  subnet_id      = aws_subnet.az_subnet_2b.id
  route_table_id = aws_route_table.RouteTable_Projet_Public.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.az_subnet_2a.id
}



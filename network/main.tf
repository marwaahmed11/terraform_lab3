# vpc
resource "aws_vpc" "iti-vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = var.vpc-name
  }
}

# igw 
resource "aws_internet_gateway" "gw" { 
  vpc_id =  aws_vpc.iti-vpc.id 

  tags = {
    Name = var.igw-name
  }
}
# public subnet
resource "aws_subnet" "subnets-public" {

  vpc_id = aws_vpc.iti-vpc.id 
  cidr_block       = var.subnet-cidr[count.index]
  count = length(var.subnet-cidr)
  availability_zone = var.availability-zone[count.index]
  
  tags = {
    Name = var.subnet-name[count.index]
  }

}

# private subnet
resource "aws_subnet" "subnets-private" {

  vpc_id = aws_vpc.iti-vpc.id 
  cidr_block       = var.subnet-cidr-2[count.index]
  count = length(var.subnet-cidr-2)
  availability_zone = var.availability-zone-2[count.index]
  
  tags = {
    Name = var.subnet-name-2[count.index]
  }

}

# nat 
resource "aws_eip" "eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.subnets-public[0].id
  tags = {
    Name = var.nat-name
  }
  depends_on = [aws_internet_gateway.gw]
}

# public routing table
resource "aws_route_table" "publicRoute" {

  vpc_id = aws_vpc.iti-vpc.id 

  route {
    cidr_block = var.route-table-public-cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.route-table-public
  }
}

# private routing table
resource "aws_route_table" "privateRoute" {
  vpc_id =  aws_vpc.iti-vpc.id

  route {
    cidr_block = var.route-table-public-cidr
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.route-table-private
  }
}

resource "aws_route_table_association" "public-subnet-route" {  
  subnet_id = aws_subnet.subnets-public[0].id
  route_table_id = aws_route_table.publicRoute.id
}

resource "aws_route_table_association" "public-subnet-route-2" {  
  subnet_id = aws_subnet.subnets-public[1].id
  route_table_id = aws_route_table.publicRoute.id
}

resource "aws_route_table_association" "private-subnet-route" {  
  subnet_id = aws_subnet.subnets-private[0].id
  route_table_id = aws_route_table.privateRoute.id
}

resource "aws_route_table_association" "private-subnet-route-2" {  
  subnet_id = aws_subnet.subnets-private[1].id
  route_table_id = aws_route_table.privateRoute.id
}


# security group
resource "aws_security_group" "allow_tls" {
  name        = var.security-group-name
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.iti-vpc.id

  ingress {
    from_port        = 80 #http
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.route-table-public-cidr]
  }
  ingress {
    from_port        = 22 #ssh
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.route-table-public-cidr]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.route-table-public-cidr]
  }

 
}
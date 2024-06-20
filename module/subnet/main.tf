# CREATE PUBLIC SUBNET 1 IN AZ1
resource "aws_subnet" "k8s-proj-pubsub1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "k8s-proj-pubsub1"
  }
}

# CREATE PUBLIC SUBNET 2 IN AZ2
resource "aws_subnet" "k8s-proj-pubsub2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "k8s-proj-pubsub2"
  }
}

# CREATE PUBLIC SUBNET 3 IN AZ3
resource "aws_subnet" "k8s-proj-pubsub3" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "k8s-proj-pubsub3"
  }
}


#  CREATE PRIVATE SUBNET 1 IN AZ1
resource "aws_subnet" "k8s-proj-privsub1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-2a"  

  tags = {
    Name = "k8s-proj-privsub1"
  }
}

#  CREATE PRIVATE SUBNET 2 IN AZ2
resource "aws_subnet" "k8s-proj-privsub2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "k8s-proj-privsub2"
  }

}

#  CREATE PRIVATE SUBNET 3 IN AZ3
resource "aws_subnet" "k8s-proj-privsub3" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "eu-west-2c"

  tags = {
    Name = "k8s-proj-privsub3"
  }

}


# CREATE AN INTERNET GATEWAY THAT WILL BE ATTACHED TO THE CUSTOM VPC
resource "aws_internet_gateway" "k8s-proj-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "k8s-proj-igw"
  }
}

# CREATE ELASTIC IP FOR NAT GATEWAY
resource "aws_eip" "k8s-proj-eip" {
  domain = "vpc"
}


# CREATE A NAT GATEWAY and ATTACH THE ELASTIC IP TO NAT GATEWAY
resource "aws_nat_gateway" "k8s-proj-natgw" {
  allocation_id = aws_eip.k8s-proj-eip.id
  subnet_id     = aws_subnet.k8s-proj-pubsub1.id

  tags = {
    Name = "k8s-proj-natgw"
  }
}


# CREATE ROUTETABLES
# CREATE PUBLIC ROUTE TABLE, ATTACHED TO VPC,ALLOW ACCESS FROM EVERY IP, ATTACHED TO THE IGW
resource "aws_route_table" "k8s-proj-rt-pub-subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s-proj-igw.id
  }

  tags = {
    Name = "k8s-proj-rt-pub-subnet"
  }
}

# CREATE PRIVATE ROUTE TABLE, ATTACHED TO VPC,ALLOW ACCESS FROM EVERY IP, ATTACHED TO THE NAT GATEWAY
resource "aws_route_table" "k8s-proj-rt-priv-subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.k8s-proj-natgw.id
  }

  tags = {
    Name = "k8s-proj-rt-priv-subnet"
  }
}

# Creating Route Table Associations 
resource "aws_route_table_association" "k8s-proj-rta-pub1" {
  subnet_id      = aws_subnet.k8s-proj-pubsub1.id
  route_table_id = aws_route_table.k8s-proj-rt-pub-subnet.id
}
resource "aws_route_table_association" "k8s-proj-rta-pub2" {
  subnet_id      = aws_subnet.k8s-proj-pubsub2.id
  route_table_id = aws_route_table.k8s-proj-rt-pub-subnet.id
}

resource "aws_route_table_association" "k8s-proj-rta-pub3" {
  subnet_id      = aws_subnet.k8s-proj-pubsub3.id
  route_table_id = aws_route_table.k8s-proj-rt-pub-subnet.id
}

resource "aws_route_table_association" "k8s-proj-rta-priv1" {
  subnet_id      = aws_subnet.k8s-proj-privsub1.id
  route_table_id = aws_route_table.k8s-proj-rt-priv-subnet.id
}
resource "aws_route_table_association" "k8s-proj-rta-priv2" {
  subnet_id      = aws_subnet.k8s-proj-privsub2.id
  route_table_id = aws_route_table.k8s-proj-rt-priv-subnet.id
}

resource "aws_route_table_association" "k8s-proj-rta-priv3" {
  subnet_id      = aws_subnet.k8s-proj-privsub3.id
  route_table_id = aws_route_table.k8s-proj-rt-priv-subnet.id
}
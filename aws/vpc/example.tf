provider "aws" {
  profile = "default"
  region = "ap-northeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.14.0.0/16"
  tags = {
    Name = "[made by TF] main"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "[made by TF] main"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.14.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "[made by TF] public-a"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "public-c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.14.1.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "[made by TF] public-c"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "private-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.14.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "[made by TF] private-a"
  }
}

resource "aws_subnet" "private-c" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.14.3.0/24"
  availability_zone = "ap-northeast-1c"
  tags = {
    Name = "[made by TF] private-c"
  }
}

resource "aws_eip" "nat-main-a" {
  vpc = true
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "[made by TF] nat-main-a"
  }
}

resource "aws_eip" "nat-main-c" {
  vpc = true
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "[made by TF] nat-main-c"
  }
}

resource "aws_nat_gateway" "main-a" {
  subnet_id = aws_subnet.public-a.id
  allocation_id = aws_eip.nat-main-a.id
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "[made by TF] main-a"
  }
}

resource "aws_nat_gateway" "main-c" {
  subnet_id = aws_subnet.public-c.id
  allocation_id = aws_eip.nat-main-c.id
  depends_on = [aws_internet_gateway.main]
  tags = {
    Name = "[made by TF] main-c"
  }
}
  
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "[made by TF] public"
  }
}

resource "aws_route_table" "private-a" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-a.id
  }
  tags = {
    Name = "[made by TF] private-a"
  }
}

resource "aws_route_table" "private-c" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main-c.id
  }
  tags = {
    Name = "[made by TF] private-c"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id = aws_subnet.public-a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id = aws_subnet.public-c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private-a" {
  subnet_id = aws_subnet.private-a.id
  route_table_id = aws_route_table.private-a.id
}

resource "aws_route_table_association" "private-c" {
  subnet_id = aws_subnet.private-c.id
  route_table_id = aws_route_table.private-c.id
}

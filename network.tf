resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/22"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  depends_on = [aws_vpc.main]

  cidr_block              = "10.0.1.0/28"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
}

resource "aws_subnet" "private" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.public
  ]

  cidr_block = "10.0.2.0/28"
  vpc_id     = aws_vpc.main.id
}

resource "aws_internet_gateway" "main" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.private,
    aws_subnet.public
  ]

  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.main
  ]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  depends_on = [
    aws_route_table.main,
    aws_subnet.private,
    aws_subnet.public,
    aws_vpc.main
  ]

  route_table_id = aws_route_table.main.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_eip" "main" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  depends_on = [
    aws_subnet.public,
    aws_eip.main
  ]

  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public.id
}


resource "aws_route_table" "nat" {
  depends_on = [
    aws_vpc.main,
    aws_nat_gateway.nat
  ]

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "nat" {
  depends_on = [
    aws_subnet.private,
    aws_route_table.nat
  ]
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.nat.id
}

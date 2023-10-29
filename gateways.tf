#InternetGateway
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}
resource "aws_default_route_table" "public" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
}


resource "aws_route" "internet_route" {
  route_table_id         = aws_default_route_table.public.id # Use the ID of my public subnet's route table
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}
#Network Gateway 

resource "aws_eip" "nat_eip" {
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id # Use one of your public subnets
  tags = {
    Name = "MyNATGateway"
  }
}
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.my_nat_gateway.id # Replace with your gateway or destination
}
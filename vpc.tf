resource "aws_vpc" "dash_count_app" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.prefix}-vpc-${var.region}"
    environment = var.environment
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dash_count_app.id
  tags   = { Name = "${var.prefix}-igw" }
}

######### Public subnets (1,2,3) - ALB + jump host #########

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.dash_count_app.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = { Name = "${var.prefix}-public-${count.index + 1}" }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.dash_count_app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "${var.prefix}-public-rtb" }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

######### NAT (single, shared by all private subnets) #########

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "${var.prefix}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags          = { Name = "${var.prefix}-nat-gateway" }
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.dash_count_app.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = { Name = "${var.prefix}-private-rtb" }
}

######### Private subnets 1 & 2 - dashboard v1 #########

resource "aws_subnet" "dashboard_v1" {
  count             = length(var.dashboard_v1_subnet_cidrs)
  vpc_id            = aws_vpc.dash_count_app.id
  cidr_block        = var.dashboard_v1_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { Name = "${var.prefix}-private-${count.index + 1}-dashboard-v1" }
}

resource "aws_route_table_association" "dashboard_v1_assoc" {
  count          = length(aws_subnet.dashboard_v1)
  subnet_id      = aws_subnet.dashboard_v1[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

######### Private subnets 3 & 4 - dashboard v2 #########

resource "aws_subnet" "dashboard_v2" {
  count             = length(var.dashboard_v2_subnet_cidrs)
  vpc_id            = aws_vpc.dash_count_app.id
  cidr_block        = var.dashboard_v2_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { Name = "${var.prefix}-private-${count.index + 3}-dashboard-v2" }
}

resource "aws_route_table_association" "dashboard_v2_assoc" {
  count          = length(aws_subnet.dashboard_v2)
  subnet_id      = aws_subnet.dashboard_v2[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

######### Private subnets 5 & 6 - counting #########

resource "aws_subnet" "counting" {
  count             = length(var.counting_subnet_cidrs)
  vpc_id            = aws_vpc.dash_count_app.id
  cidr_block        = var.counting_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = { Name = "${var.prefix}-private-${count.index + 5}-counting" }
}

resource "aws_route_table_association" "counting_assoc" {
  count          = length(aws_subnet.counting)
  subnet_id      = aws_subnet.counting[count.index].id
  route_table_id = aws_route_table.private_rtb.id
}

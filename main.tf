provider "aws" {
  region = "us-west-2"
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# Define public key to be used to access instances
resource "aws_key_pair" "auth" {
  key_name   = "aws_key"
  public_key = "${file(var.public_key_path)}"
}

# Create VPC for instances
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}


# Create a subnet from VPC to run instances
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}" # lookup id from "aws_vpc" resource named "default" above
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Create security group to allow ssh in and all outbound connections
resource "aws_security_group" "basic" {
  name        = "basic_security_group"
  description = "Allow SSH in and outbound internet access"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create 1 instance of this name
resource "aws_instance" "example01" {
  instance_type = "t3.nano"
  ami = "${var.ubuntu_1804_uswest_2}" #Variable defined in variables.tf

  connection {
    user = "ubuntu"
  } 
  key_name = "${aws_key_pair.auth.id}"

  vpc_security_group_ids = ["${aws_security_group.basic.id}"]
  subnet_id = "${aws_subnet.default.id}"

}

# Create DNS record on CloudFlare
resource "cloudflare_record" "example01" {
  domain = "varokas.com"
  name   = "example01"
  value  = "${aws_instance.example01.public_ip}"
  type   = "A"
  ttl    = 3600
}

# Define output that will print out when done and can be queried later
# `terraform output example01-ip`
output "example01-ip" {
  value = "${aws_instance.example01.public_ip}"
}
    

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
  
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*20*-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "cyber_vpc" {
    cidr_block = "10.1.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "sfe-cyber"
    }
}

resource "aws_subnet" "sub-cyber_vpc" {
    cidr_block = "10.1.0.0/24"
    vpc_id = aws_vpc.cyber_vpc.id
    tags = {
        Name = "sfe-cyber"
    }
}


#Define the internet gateway
resource "aws_internet_gateway" "kafka-gw" {
  vpc_id = aws_vpc.cyber_vpc.id
  tags = {
    Name = "cyber-igw"
  }
}

#Define the public route table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.cyber_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kafka-gw.id
  }
  tags = {
    Name = "cyber-subnet-rt"
  }
}

#Assign the Dev public route table to the public Subnet
resource "aws_route_table_association" "public-rt-association" {
  subnet_id = aws_subnet.sub-cyber_vpc.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_security_group" "sg-cyber" {
    name = "allow_kafka_listener_ports"
    description = "Amend for your needs"
    vpc_id = aws_vpc.cyber_vpc.id

    ingress {
        description = "All traffic from VPC"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [aws_vpc.cyber_vpc.cidr_block]
    }

    ingress {
        description = "Inbound SSH Access"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Inbound Kafka Listener"
        from_port = 9094
        to_port = 9094
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   
   ingress {
        description = "Inbound Kafka Listener"
        from_port = 9092
        to_port = 9092
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
   
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "kafka" {
  ami                         = data.aws_ami.ubuntu.id
  vpc_security_group_ids      = [aws_security_group.sg-cyber.id]
  subnet_id                   = aws_subnet.sub-cyber_vpc.id
  associate_public_ip_address = true
  instance_type               = var.instance_type
  key_name                    = var.instance_keypair
  user_data                   = file("install.sh")

  root_block_device {
    volume_size = "50"
    volume_type = "gp2"
    delete_on_termination = true
  } 

  tags = {
    Name = "Cyber-Kafka-Host"
  }
}





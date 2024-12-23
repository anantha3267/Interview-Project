provider "aws" {
  region = "us-east-1" # Adjust to your desired region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Create a subnet in the VPC (public subnet)
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Change to your desired availability zone
  map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
  }
}

# Create Route Table for Public Subnet (necessary for internet access)
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# Create Security Group for Jenkins and related tools
resource "aws_security_group" "jenkins_tools" {
  name        = "jenkins-tools-sg"
  description = "Security group for Jenkins and related tools"
  vpc_id      = aws_vpc.main.id

  # Allow Jenkins access
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SonarQube access
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow Git SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP/HTTPS for web access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic for updates and external connectivity
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-tools-sg"
  }
}

# Create an EC2 instance for Jenkins
resource "aws_instance" "jenkins" {
  ami                   = "ami-0e2c8caa4b6378d8c" # Update with a valid AMI ID for your region (e.g., Ubuntu Server)
  instance_type         = "t2.medium"
  subnet_id             = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.jenkins_tools.id]
  key_name              = "ec2" # Replace with your SSH key name

  tags = {
    Name = "Jenkins-Instance"
  }

  # Reference the external script for initial setup
  user_data = templatefile("./userdata.sh", {})
}

# Output the public IP of the Jenkins instance
output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

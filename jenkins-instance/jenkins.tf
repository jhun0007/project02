terraform {
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }

  backend "s3" {
    bucket = "project02-s3-tf-state"
    key = "terraform/jenkins.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "project02-lock-table"
    encrypt = "true"
  }
}

provider "aws" {
  region = var.aws_region
}




resource "aws_instance" "jenkins" {
  ami                         = "ami-0f93b09b4a229b989"
  instance_type               = "t3.large"
  key_name                    = "project02-key"
  private_ip                  = "10.2.64.100" 
  security_groups             = [aws_security_group.project02-jenkins-sg.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.private-subnet-2a-id

  user_data = templatefile("templates/userdata.sh", {})  

  tags = {
    Name = "project02-jenkins"
  }
}


// jenkins SSH
resource "aws_security_group" "project02-jenkins-sg" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  name = "project02-jenkins-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { //target HTTP
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress { //HTTP
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //HTTPS
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
    ingress { //ICMP
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project02-jenkins-sg"
  }
}
data "aws_vpc" "robodev" {
  filter {
    name = "tag:Name"
    values = ["roboshop-dev"]
  }
}

data "aws_subnet" "sub-dev" {
  filter {
    name   = "tag:Name"
    values = ["roboshop-dev-sub-01"]  # Replace with the subnet's tag value
  }
}

data "aws_ami" "devcloud" {

    most_recent = true
    owners = ["973714476881"]

    filter {
        name   = "name"
        values = ["Redhat-9-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_ami" "sonarqube" {
  most_recent = true
  owners      = ["309956199498"] # Solve DevOps Not working 

  filter {
    name   = "name"
    values = ["RHEL-10.1.0_HVM-*-x86_64-0-Hourly2-GP3"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
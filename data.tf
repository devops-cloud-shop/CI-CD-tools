data "aws_vpc" "robodev" {
  filter {
    name = "name"
    values = ["roboshop-dev"]
  }
}

data "aws_subnet" "sub-dev" {
  filter {
    name   = "name"
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
  owners      = ["679593333241"] # Solve DevOps

  filter {
    name   = "name"
    values = ["SolveDevOps-SonarQube-Server-Ubuntu24.04-*"]
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
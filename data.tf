data "aws_vpc" "robodev" {
  filter {
    name = "tag:Name"
    # values = ["roboshop-dev"]
    values = ["default-dev"] #used this to create jenkins master and agent in def vpc with tf
  }
}

data "aws_subnet" "sub-dev" {
  filter {
    name   = "tag:Name"
    # values = ["roboshop-dev-sub-01"]  # Replace with the subnet's tag value
    values = ["default-dev-sub-01"] #used this to create jenkins master and agent in def vpc with tf
  }
}

data "aws_ami" "daws-main" {

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


# data "aws_ami" "sonarqube" {
#   most_recent = true
#   owners      = ["679593333241"] # Solve DevOps

#   filter {
#     name   = "name"
#     values = ["SolveDevOps-SonarQube-Server-Ubuntu24.04-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }
# }
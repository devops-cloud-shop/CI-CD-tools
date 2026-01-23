resource "aws_instance" "jenkins" {
  ami           = local.ami_id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = data.aws_subnet.sub-dev.id #replace your Subnet in default VPC

  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("jenkins.sh")
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-jenkins"
    }
  )
}

resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  domain   = "vpc"
}

resource "aws_instance" "jenkins_agent" {
  ami           = local.ami_id
  instance_type = "t3.small"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id = data.aws_subnet.sub-dev.id #replace your Subnet

  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("jenkins-agent.sh")
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-jenkins-agent"
    }
  )
}

# resource "aws_instance" "sonar" {
#   count = var.sonar ? 1 : 0
#   ami           = local.sonar_ami_id
#   instance_type = "t3.large"
#   vpc_security_group_ids = [aws_security_group.main.id]
#   subnet_id = data.aws_subnet.sub-dev.id #replace your Subnet in default VPC
#   key_name = "aws-prav"

  resource "aws_instance" "sonar" {
  ami                    = local.sonar_ami_id
  instance_type          = "m7i-flex.large"
  subnet_id              = data.aws_subnet.sub-dev.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = "aws-prav"

  user_data = file("sonar.sh")
              
  # need more for terraform
  root_block_device {
    volume_size = 20
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-sonar"
    }
  )
}

resource "aws_security_group" "main" {
  name        =  "${var.project}-${var.environment}-jenkins"
  description = "Created to attatch Jenkins and its agents"
  vpc_id = local.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-jenkins"
    }
  )
}

#SG for sonar
resource "aws_security_group" "sonar" {
  name   = "sonar-sg"
  vpc_id = local.vpc_id.id

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-sonar-sg"
    }
  )
}


resource "aws_route53_record" "jenkins" {
  zone_id = var.zone_id
  name    = "jenkins.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_eip.jenkins.public_ip]
  allow_overwrite = true

  depends_on = [aws_instance.jenkins]
}

resource "aws_route53_record" "sonar" {
  count = var.sonar ? 1 : 0
  zone_id = var.zone_id
  name    = "sonar.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.sonar[0].public_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "jenkins-agent" {
  zone_id = var.zone_id
  name    = "jenkins-agent.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.jenkins_agent.private_ip]
  allow_overwrite = true

  depends_on = [aws_instance.jenkins_agent]
}
module "aws_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.0.0"
  
  name = "jenkins-instance"
  #shared_credentials_file = "~/.aws/credentials"
  
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.micro"
 
  vpc_security_group_ids = [aws_security_group.ec2-security-group.id]
  subnet_id              = module.vpc.public_subnets[3]
 
  tags = {
    Name = "jenkins-instance"
  }

  user_data = file("install_jenkins.sh")

  associate_public_ip_address = true 
  monitoring = true
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

resource "aws_security_group" "ec2-security-group" {
  name_prefix = "ec2-security-group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  
}

output "jenkins_ip_address" {
  value = module.aws_ec2_instance.public_dns
}
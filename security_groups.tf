
resource "aws_security_group" "SG_LB_Projet" {
  name        = "SG-LB_Projet"
  description = "SG-LB_Projet"
  vpc_id      = aws_vpc.VPC_Projet.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "SG_EC2_Projet" {
  name        = "SG-EC2_Projet"
  description = "SG-EC2_Projet"
  vpc_id      = aws_vpc.VPC_Projet.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.SG_LB_Projet.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for the bastion
resource "aws_security_group" "bastion_sg" {
  name        = "BastionSG"
  description = "Security group for the bastion host"
  vpc_id      = aws_vpc.VPC_Projet.id

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
}
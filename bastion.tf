resource "aws_instance" "BASTION" {
  ami                         = "ami-09fd16644beea3565"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.alb_keypair.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = aws_subnet.az_subnet_2b.id
  associate_public_ip_address = true

  tags = {
    Name = "BASTION"
  }
}

provider "aws" {
  region = "us-west-1"
}
resource "aws_instance" "server" {
  ami           = "ami-017c001a88dd93847"
  instance_type = "t2.micro"
  subnet_id = "subnet-04bce4ad9e5274836"
  security_groups = [ "sg-055b0017b699f19cb" ]
  key_name = aws_key_pair.key.id

  tags = {
    Name = "Terraform-EC2"
  }
}
resource "aws_key_pair" "key" {
  key_name   = "sample-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD8bYIzz5nCDSAYfey2cdAl1C9iTEgVKGk3jE1TLk+Eu1F6Gbv6ogqsQKZfY0OQQeh47eF6EO7rbog/AMjHgluUE1FAhE/zlEuXt1D0wMAF0dBlw+hRjHr7hHlATGjhFsuN1Ie/4iRwEQMhTKpU4n3LfoeSXJAHrICC/nSg9U26CMwpQHJ8mqQWJnjcWdIh8cDNljDcKrY0NtHFYAQE5H/w0RKQC7su31VvozgFlB9NpxW7n16FCC5Fp6zlAa/KDLVxNir60D20ycL7AYae5Su4s/J2t0KQ7gGor6Ll8hh6oLivn6hEAa2QBr3yeBe5TYnYTOYhF91+SWEeGjNx+vvCSQXWvj6rF2DggZehOkoZT2uReCf1YyHcqDHyWl3LdTQ94ovzX2PS2dR4vcXpSWOAGG297do5XGRQ2zksrUvfrfqyi9eQ5U48B02hijDCxZlHEGh3MXc0q3pnRb4pWAQokTtvGbQ1HPVvOnnB7+O6u5XpV/RmGKfYvsadUN44jZE= rajesh@DESKTOP-FDLON32"
}

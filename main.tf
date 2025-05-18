provider "aws" {
region = "us-east-1"
}
resource "aws_key_pair" "mykey" {
  key_name   = "deployer-key"
  public_key = file("C:/Users/Omar/.ssh/id_rsa.pub") # Adjust path as needed
}


resource "aws_instance" "web" {
    ami = "ami-0a7d80731ae1b2435"
    instance_type = "t2.micro"
    tags = {
        Name = "Best-EC2-Container"
    }  
    key_name  = aws_key_pair.mykey.key_name

    vpc_security_group_ids = [aws_security_group.web_sg.id]
}


resource "aws_security_group" "web_sg" {
  name = "web_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

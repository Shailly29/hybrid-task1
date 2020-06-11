provider "aws" {
  region   = "ap-south-1"
  profile  = "shailly_shah"
}

resource "aws_key_pair" "taskkey1" {
  key_name    = "taskkey1"
  public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCUq/YAlVDk0LJnrX700LphB194pc5ceH6nLDAsz39AmFSaIvkq6s+nW6TgL0OV5llI57RGCQvNIMTxxeVC1eWgP7wYqD+qDxX8OgykDAdeKGjZ1jbuss67ucm10NeaHoiUwPPFEBgF7+B7VQSGLuSpYjn54D39JbortLbeYCfPl5WctgN1ejOQ3mois+fb0qsr39B8taj6WzxE4eQbKOdq9TXCKPwMsdXtiqRXEuYrscwTGapRTkwt5fBFiW5r26auUzL5NO/wDWjPxkYOVIvkMi1+zqgguplJ4Rl9zlEj4TZod5N+5sJOLqLvhTP8tCs7rnckHvuROYq3EFxnNJ+3"
}

resource "aws_security_group" "tasksg1" {
  name        = "tasksg1"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-377c605f"


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tasksg1"
  }
}

resource "aws_ebs_volume" "taskebs1" {
  availability_zone = "ap-south-1a"
  size              = 1

  tags = {
    Name = "taskebs1"
  }
}
resource "aws_volume_attachment" "taskattach1" {
 device_name = "/dev/sdf"
 volume_id = "${aws_ebs_volume.taskebs1.id}"
 instance_id = "${aws_instance.taskinst1.id}"
}
resource "aws_instance" "taskinst1" {
  ami           = "ami-0d855078e0e5b532c"
  instance_type = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name      = "taskkey1"
  security_groups = [ "tasksg1" ]
  user_data = <<-EOF
                #! /bin/bash
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo yum install git -y
                mkfs.ext4 /dev/xvdf1
                mount /dev/xvdf1 /var/www/html
                cd /var/www/html
                git clone https://github.com/Shailly29/hybrid-task1
                
  EOF

  tags = {
    Name = "taskinst1"
  }
}
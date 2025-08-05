#Need key pair for ec2 instance to login

resource "aws_key_pair" "my_key"{
    key_name   = "terra-key-ec2"
    public_key = file("terraform_key.pub")
}
# VPC and Security GRP

resource "aws_default_vpc" "default"{
}

resource "aws_security_group" "my_sg"{
    name = "automate-sg"
    description = "This will add a TF generated security group"
    vpc_id = aws_default_vpc.default.id #interpolation
    
    #inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #allow ssh from anywhere
        description = "SSH access"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #HTTP open
        description = "HTTP OPEN"
    }        
    #outbound rules

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "All access open outbound"
    }
}
#Ec2 Instance

resource "aws_instance" "ubuntu" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = ["aws_security_group.my_sg.name"]
    instance_type = "t2.micro"

    ami = "ami-0f918f7e67a3323f0" #ubuntu
    
    root_block_device {
      volume_size = 15
      volume_type = "gp3"
    }

    tags = {
        Name = "tf-automate-instance"
    }

}

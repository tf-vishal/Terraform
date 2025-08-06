#Need key pair for ec2 instance to login

resource "aws_key_pair" "my_key"{
    key_name   = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
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

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Port 8000"
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

resource "aws_instance" "my_instance"{
    count = 2 # meta arguments, creates number of resources of the respective resource here it's instance.
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_sg.name]
    instance_type = var.ec2_instance_type
    user_data = file("install-nginx.sh")

    ami = var.ec2_ami_id
    
    root_block_device {
      volume_size = var.ec2_root_storage_size
      volume_type = "gp3"
    }

    tags = {
        Name = "tf-automate-instance"
    }

}

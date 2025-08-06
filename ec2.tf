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
    #count = 1 # creates number of resources of thre respective block, here it is instance
    for_each = tomap({
        "Terra-Instance-T2-Micro" : "t2.micro"
        "Terra-Instance-T3-Micro" : "t3.micro"
    }) #tomap is just key:value pair #Meta arguments
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_sg.name]
    instance_type = each.value

    depends_on = [ aws_security_group.my_sg , aws_key_pair.my_key ] #this is also a meta argument, which is without sg we can't have any instance

    ami = var.ec2_ami_id
    
    root_block_device {
      volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
      volume_type = "gp3"
    }

    #In computer lang it's known as ternary operator and in tf it's knwon as conditional exp
    # var is comparing env == prod
    # ? is  like, if it's true then use the after ?
    # if it's not then use the later one that is after colon (:)

    tags = {
        Name = each.key
    }

}

variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
}

variable "ec2_default_root_storage_size" {
    default = 10
    type = number
}

variable "ec2_ami_id" {
    default = "ami-0f918f7e67a3323f0"
    type = string
}

variable "env" {
    default = "prd" # use prd or anything else
    type = string
}
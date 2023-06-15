# TERRAFORM

## HOW TO USE DYNAMIC AMI
you can set your IasC for always get the last available AMI you need.
You can see how to create AMI on this [page](../packer/01_use_packer.md)

In this example, you will:
- create an aws datasource
- configure a filter
    This one will permit you to always get the last available AMI. It work for public AMI or private
- create an aws instance
    set the datasourced AMI
```
data "aws_ami" "my_ami" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["000000000000", "111111111111"]
  filter {
    name   = "name"
    values = ["my_ami_name-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "my_instance" {
  ami = data.aws_ami.my_ami.id
  instance_type          = "t3.medium"
  tags = {
    Name                 = "my_app"
  }
}
```
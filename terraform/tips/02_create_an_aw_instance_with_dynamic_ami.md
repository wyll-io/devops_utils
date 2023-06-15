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
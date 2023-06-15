    This one will permit you to always get the last available AMI. It work for public AMI or private

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
```
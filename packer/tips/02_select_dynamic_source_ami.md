It always got the last version of this AMI

```
{
    "variables": {
      "AWS_PROFILE": "{{env `AWS_PROFILE`}}
      },
    "builders": [{
      "type": "amazon-ebs",
      "profile": "{{user `AWS_PROFILE` }}",
      "source_ami_filter": {
        "filters": {
        "virtualization-type": "hvm",
        "name": "amzn2-ami-hvm-2.0*",
        "root-device-type": "ebs"
        },
        "owners":["amazon"],
        "most_recent": true
      },
      "instance_type": "t2.small",
      "ssh_username": "ec2-user",
      "ami_name": "my_ami_name-{{timestamp}}"
      }],
      [...]
}

```
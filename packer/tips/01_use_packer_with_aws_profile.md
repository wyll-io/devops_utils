```
{
    "variables": {
      "AWS_PROFILE": "{{env `AWS_PROFILE`}}
    },
    "builders": [{
        "type": "amazon-ebs",
        "profile": "{{user `AWS_PROFILE` }}",
        "source_ami": "my_source_ami",
        "instance_type": "t2.small",
        "ssh_username": "ec2-user",
        "ami_name": "my_ami_name-{{timestamp}}"
    }]
}
```
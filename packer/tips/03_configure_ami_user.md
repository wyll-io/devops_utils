AMI users are able to use the created AMI from other account on the same tenant

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
        "ami_users": ["000000000000","111111111111","222222222222","333333333333"],
        "ami_name": "my_ami_name-{{timestamp}}"
    }]
}
```
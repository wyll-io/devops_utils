# PACKER

## HOW TO USE PACKER WITH AWS PROFILE

This exemple of on way to use packer if your client use AWS SSO solution.

It is really simple to implement packer on a AWS infrastructure. you just need to know your `AWS_PROFILE` name. This feature only work with amazon-ebs image.

In this example you will:
  - set different variables
  - create an `amazon-ebs` image builders
  - use your current `AWS_PROFILE` 
  - select a dynamic source AMI
    It always got the last version of this AMI
  - configure multiple AMI users
    AMI users are able to use the created AMI from other account on the same tenant
  - set a custom name to your AMI
  - import a local file to your image
  - run a `sh` installation script with parameters
    you can set a ansible provisionner too if you need
```
{
    "variables": {
      "AWS_PROFILE": "{{env `AWS_PROFILE`}}
      "VAR_1": "{{env `my_environment_variable_1`}}",
      "VAR_2": "{{env `my_environment_variable_2`}}"
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
      "ami_users": ["000000000000","111111111111","222222222222","333333333333"],
      "ami_name": "my_ami_name-{{timestamp}}"
      }],
      "provisioners": [   
        {
          "type": "file",
          "source": "config/custom.properties",
          "destination": "/tmp/custom.properties"
        },
        {
          "type": "shell",
          "environment_vars": 
          [
            "VAR_1={{user `VAR_1` }}",
            "VAR_2={{user `VAR_2` }}"
          ],
          "script": "provision.sh"
        }
      ]
    }
```

you can set your IasC for using your just created ami dynamicly on this [page](../terraform/01_use_terraform.md)
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
        [...]
    }],
    [...]
}
```
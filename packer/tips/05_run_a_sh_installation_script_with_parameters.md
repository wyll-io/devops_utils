```
.
├── config
├── custom.properties
├── packer.json
└── provision.sh
```

```
{
    "variables": {
      "VAR_1": "{{env `my_environment_variable_1`}}",
      "VAR_2": "{{env `my_environment_variable_2`}}"
    },
    "builders": [{
        [...]
    }],
    "provisioners": [   
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
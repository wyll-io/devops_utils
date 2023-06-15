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
        [...]
    },
    "builders": [{
        [...]
    }],
    "provisioners": [   
        {
        "type": "file",
        "source": "config/custom.properties",
        "destination": "/tmp/custom.properties"
        }
    ]
}
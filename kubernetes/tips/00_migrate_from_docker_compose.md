```
cd < your docker compose directory>
curl -L https://github.com/kubernetes/kompose/releases/download/v1.26.0/kompose-linux-amd64 -o kompose
chmod +x kompose
sudo mv ./kompose /usr/local/bin/kompose
```

```
# kompose convert
    WARN Restart policy 'unless-stopped' in service influxdb is not supported, convert it to 'always'
    WARN Restart policy 'unless-stopped' in service homeassistant is not supported, convert it to 'always'
    WARN Volume mount on the host "/local/home-assistant" isn't supported - ignoring path on the host
    WARN Volume mount on the host "/etc/localtime" isn't supported - ignoring path on the host
    WARN Volume mount on the host "/local/influxdb" isn't supported - ignoring path on the host
    INFO Kubernetes file "homeassistant-service.yaml" created
    INFO Kubernetes file "influxdb-service.yaml" created
    INFO Kubernetes file "homeassistant-deployment.yaml" created
    INFO Kubernetes file "homeassistant-claim0-persistentvolumeclaim.yaml" created
    INFO Kubernetes file "homeassistant-claim1-persistentvolumeclaim.yaml" created
    INFO Kubernetes file "influxdb-deployment.yaml" created
    INFO Kubernetes file "influxdb-claim0-persistentvolumeclaim.yaml" created

```

```
# ls
    docker-compose.yml                homeassistant-service.yaml
    homeassistant-claim0-persistentvolumeclaim.yaml   influxdb-claim0-persistentvolumeclaim.yaml
    homeassistant-claim1-persistentvolumeclaim.yaml   influxdb-deployment.yaml
    homeassistant-deployment.yaml         influxdb-service.yaml
 ```
# Provider Proxmox
pm_api_url      = "https://10.0.0.5:8006/api2/json"
pm_tls_insecure = true
pm_debug        = true
subnet_mask     = "16"

# All the VM to build the Kubernetes cluster
kubernetes_masters_node = {
  "k8s-master" : {
    name         = "k8s-master",
    description  = "Kubernetes Master Configuration",
    host         = "pve1-infra",
    clone        = "template-cloudinit-ubuntu-22-04-LTS",
    cpu_core     = "2",
    cpu_socket   = "2",
    memory_mb    = "4096",
    disk_size_gb = "20",
    ssh_user     = "adm"
  }
}
kubernetes_worker_node = {
  "k8s-node" : {
    name         = "k8s-node",
    description  = "Kubernetes Nodes configuration",
    host         = "pve1-infra",
    clone        = "template-cloudinit-ubuntu-22-04-LTS",
    cpu_core     = "2",
    cpu_socket   = "4",
    memory_mb    = "16384",
    disk_size_gb = "20",
    ssh_user     = "adm"
  }
}

# All the VM to build the Vault cluster

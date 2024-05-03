# Provider Proxmox
pm_api_url          = "https://pve01.devoups.local:8006/api2/json"
pm_api_token_id     = "brice@pve!terraform_token"
pm_api_token_secret = "0aa45740-d05a-4778-88bf-2170285567cc"
pm_tls_insecure     = true
pm_debug            = true
subnet_mask         = "16"
vm_ssh_keys         = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4MLfARKh8R7Pa/mPlUCwnEU0HM2OkrxgKb2tDLrq4Y"

# All the VM to build the Kubernetes cluster
kubernetes_masters_node = {
  "master" : {
    name         = "k8s-master",
    description  = "Kubernetes Master Configuration",
    host         = "CBO-IT-S-PVE-1",
    clone        = "debian-base",
    cpu_core     = "2",
    cpu_socket   = "2",
    memory_mb    = "4096",
    disk_size_gb = "20",
    ipconfig0    = "",
    #    ssh_user     = "adm_test"
    ssh_user = "root"

  }
}
kubernetes_worker_node = {
  "worker" : {
    name         = "k8s-node",
    description  = "Kubernetes Nodes configuration",
    host         = "CBO-IT-S-PVE-1",
    clone        = "debian-base",
    cpu_core     = "2",
    cpu_socket   = "4",
    memory_mb    = "16384",
    disk_size_gb = "20",
    ipconfig0    = "",
    ssh_user     = "root"
    #    ssh_user     = "adm_test"
  }
}

# All the VM to build the Vault cluster
vault_cluster = {
  "vault-01" : {
    name         = "vault-01",
    description  = "Vault 01",
    host         = "pve1-infra",
    clone        = "debian-base",
    cpu_core     = "1",
    cpu_socket   = "2",
    memory_mb    = "2048",
    disk_size_gb = "20",
    ipconfig0    = "ip=10.0.0.50/24,gw=10.0.0.1",
    ssh_user     = "adm-test"
  },
  "vault-02" : {
    name         = "vault-02",
    description  = "Vault 02",
    host         = "pve2-infra",
    clone        = "debian-base",
    cpu_core     = "1",
    cpu_socket   = "2",
    memory_mb    = "2048",
    disk_size_gb = "20",
    ipconfig0    = "ip=10.0.0.51/24,gw=10.0.0.1",
    ssh_user     = "adm-test"
  },
  "vault-03" : {
    name         = "vault-03",
    description  = "Vault 03",
    host         = "pve3-infra",
    clone        = "debian-base",
    cpu_core     = "1",
    cpu_socket   = "2",
    memory_mb    = "2048",
    disk_size_gb = "20",
    ipconfig0    = "ip=10.0.0.52/24,gw=10.0.0.1",
    ssh_user     = "adm-test"
  }
}

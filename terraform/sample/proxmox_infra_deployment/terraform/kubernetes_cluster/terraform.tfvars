# All the VM to build the Kubernetes cluster
kubernetes_master_node = {
  "master" : {
    name         = "k8s-master",
    description  = "Kubernetes Master Configuration",
    host         = "",
    clone        = "kube-base-pkr",
    cpu_core     = "2",
    cpu_socket   = "2",
    memory_mb    = "4096",
    disk_size_gb = "20",
    ipconfig0    = "",
    ssh_user     = ""

  }
}
kubernetes_worker_node = {
  "worker" : {
    name         = "k8s-node",
    description  = "Kubernetes Nodes configuration",
    host         = "",
    clone        = "kube-base-pkr",
    cpu_core     = "2",
    cpu_socket   = "4",
    memory_mb    = "16384",
    disk_size_gb = "20",
    ipconfig0    = "",
    ssh_user     = ""
  }
}

cloud_init_storage_pool = "datastore"
vm_storage_class        = "datastore"
iso_storage_pool        = "local"
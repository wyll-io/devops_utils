locals {
#  vars_path    = "."
  ZONES       = yamldecode(file("./vars/vars.yaml"))["ZONE"]
  master_provision = flatten([
    for zone in local.ZONES: [
      for instance_count in range(zone.K8S.MASTER_COUNT) : { 
        site = zone.NAME,
        master_name = "${zone.NAME}-${instance_count}" ,
        proxmox_node = zone.PROXMOX_NODE_NAME
        ip = "${zone.K8S.IP_PREFIX}.${instance_count}/${var.vm_subnet_mask},gw=${zone.GW}"
        }
    ]
  ])
  worker_provision = flatten([
    for zone in local.ZONES: [
      for instance_count in range(zone.K8S.WORKER_COUNT) : { 
        site = zone.NAME,
        worker_name = "${zone.NAME}-${instance_count}" ,
        proxmox_node = zone.PROXMOX_NODE_NAME
        ip = "${zone.K8S.IP_PREFIX}.${instance_count}/${var.vm_subnet_mask},gw=${zone.GW}"
        }
    ]
  ])
}

######################################################
######################  PROXMOX  #####################
######################################################
variable "pm_api_url" {
  type        = string
  description = "url d'acces api proxmox"
}

variable "pm_api_token_id" {
  type        = string
  description = "token id username proxmox"
}

variable "pm_api_token_secret" {
  type        = string
  description = "secret user api promox"
}

variable "pm_debug" {
  type        = bool
  description = "debug mode"
  default     = false
}

variable "pm_tls_insecure" {
  type        = bool
  description = "insecure TLS"
  default     = false
}

######################################################
################  Default VM values  #################
######################################################

variable "vm_nameserver" {
  type        = string
  description = "Nameserver for DNS"
  default     = "8.8.8.8"
}

variable "vm_os_type" {
  type        = string
  description = "OS type"
  default     = "cloud-init"
}

variable "vm_storage_class" {
  type        = string
  description = "Storage class"
  default     = "instances"
}

variable "vm_ssh_keys" {
  type        = string
  description = "SSH Keys"
}

variable "vm_subnet_mask" {
  type        = string
  description = "Subnet mask of VMs "
  default     = "24"
}
######################################################
####################  KUBERNETES  ####################
######################################################


variable "kubernetes_master_node" {
  type = map(object({
    name         = string
    description  = string
    host         = string
    clone        = string
    cpu_core     = string
    cpu_socket   = string
    memory_mb    = string
    disk_size_gb = string
    ipconfig0    = string
    ssh_user     = string
  }))
  description = "all the VM for the Kubernetes cluster"
  default = {
    "master" = {
      name         = "k8s-master",
      description  = "Kubernetes Master node",
      host         = ""
      clone        = ""
      cpu_core     = "2",
      cpu_socket   = "2",
      memory_mb    = "4096",
      disk_size_gb = "20",
      ipconfig0    = ""
      ssh_user     = "adm-eurofiber"
    }
  }
}

variable "kubernetes_worker_node" {
  type = map(object({
    name         = string
    description  = string
    host         = string
    clone        = string
    cpu_core     = number
    cpu_socket   = number
    memory_mb    = number
    disk_size_gb = number
    ipconfig0    = string
    ssh_user     = string
  }))
  description = "all the VM for the Kubernetes cluster"
  default = {
    "worker" = {
      name         = "k8s-worker",
      description  = "Kubernetes Worker node",
      host         = ""
      clone        = ""
      cpu_core     = "2",
      cpu_socket   = "4",
      memory_mb    = "16384",
      disk_size_gb = "20",
      ipconfig0    = ""
      ssh_user     = "adm-eurofiber"
    }
  }
}
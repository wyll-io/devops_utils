packer {
  required_plugins {
    proxmox = {
      version = "1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_api_url" {
  type    = string
  default = ""
}

variable "proxmox_api_token_id" {
  type    = string
  default = ""
}

variable "proxmox_api_token_secret" {
  type      = string
  default   = ""
  sensitive = true
}

variable "ssh_username" {
  type    = string
  default = "admin"
}

variable "ssh_password" {
  type    = string
  default = ""
}

variable "proxmox_node" {
  type    = string
  default = ""
}

variable "cloud_init_storage_pool" {
  type        = string
  description = "Storage class "
  default     = "datastore"
}

variable "vm_storage_class" {
  type        = string
  description = "Storage class"
  default     = "datastore"
}


source "proxmox-clone" "kube-base" {
  proxmox_url = var.proxmox_api_url
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret

  node = var.proxmox_node

  clone_vm             = "debian-base-pkr"
  vm_name              = "kube-base-pkr"
  template_name        = "kube-base-pkr"
  template_description = "Kubernetes Base Image"

  insecure_skip_tls_verify = true
  task_timeout  = "5m"
  qemu_agent = true

  scsi_controller = "virtio-scsi-pci"

  cpu_type = "host"
  cores    = "2"
  sockets  = "1"
  memory   = "2048"

  cloud_init              = true
  cloud_init_storage_pool = var.cloud_init_storage_pool

  vga {
    type = "virtio"
  }
  
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }


  communicator           = "ssh"
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_timeout            = "15m"
  ssh_pty                = true
  ssh_handshake_attempts = 15
}

build {
  sources = ["source.proxmox-clone.kube-base"  ]
  # provisioner "shell" {
  #   inline = [
  #     "echo -n ${var.ssh_password} | sudo -S DEBIAN_FRONTEND=noninteractive apt update",
  #     "echo -n ${var.ssh_password} | sudo -S DEBIAN_FRONTEND=noninteractive apt upgrade",
  #     "echo -n ${var.ssh_password} | sudo -S swapoff -a",
  #     "echo -n ${var.ssh_password} | sudo -S sed -i '/swap/d' /etc/fstab"
  #   ]
  # }

}

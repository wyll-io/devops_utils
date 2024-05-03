resource "proxmox_vm_qemu" "kubernetes_masters" {
  for_each = tomap({
    for provisionning in local.master_provision : "${provisionning.master_name}" => provisionning
  })

  name                    = "${each.value.master_name}-kubernetes-master"
  desc                    = var.kubernetes_master_node.master.description
  ci_wait                 = 60
  cores                   = var.kubernetes_master_node.master.cpu_core
  sockets                 = var.kubernetes_master_node.master.cpu_socket
  memory                  = var.kubernetes_master_node.master.memory_mb
  os_type                 = var.vm_os_type
  full_clone              = true
  cloudinit_cdrom_storage = var.vm_storage_class
  agent                   = 0
  nameserver              = var.vm_nameserver
  ssh_user                = var.kubernetes_master_node.master.ssh_user
  scsihw                  = "virtio-scsi-pci"
  target_node             = each.value.proxmox_node
  ipconfig0               = each.value.ip

    # WORK IN PROGRESS
  # clone                   = each.value.clone
  # sshkeys                 = var.vm_ssh_keys

  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.kubernetes_master_node.master.disk_size_gb
          storage = var.vm_storage_class
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

resource "proxmox_vm_qemu" "kubernetes_workers" {
  for_each = tomap({
    for provisionning in local.worker_provision : "${provisionning.worker_name}" => provisionning
  })

  desc                    = var.kubernetes_worker_node.master.description
  ci_wait                 = 60
  cores                   = var.kubernetes_worker_node.master.cpu_core
  sockets                 = var.kubernetes_worker_node.master.cpu_socket
  memory                  = var.kubernetes_worker_node.master.memory_mb
  os_type                 = var.vm_os_type
  full_clone              = true
  cloudinit_cdrom_storage = var.vm_storage_class
  agent                   = 0
  nameserver              = var.vm_nameserver
  ssh_user                = var.kubernetes_worker_node.master.ssh_user
  scsihw                  = "virtio-scsi-pci"
  target_node             = each.value.proxmox_node
  ipconfig0               = each.value.ip

    # WORK IN PROGRESS
  # clone                   = each.value.clone
  # sshkeys                 = var.vm_ssh_keys


  disks {
    scsi {
      scsi0 {
        disk {
          size    = var.kubernetes_worker_node.worker.disk_size_gb
          storage = var.vm_storage_class
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}
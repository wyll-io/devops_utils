resource "proxmox_vm_qemu" "kubernetes_masters" {
  for_each = tomap({
    for provisionning in local.master_provision : "${provisionning.master_name}" => provisionning
  })

  name                    = each.value.master_name
  desc                    = var.kubernetes_master_node.master.description
  ci_wait                 = 60
  cores                   = var.kubernetes_master_node.master.cpu_core
  sockets                 = var.kubernetes_master_node.master.cpu_socket
  memory                  = var.kubernetes_master_node.master.memory_mb
  os_type                 = var.vm_os_type
  full_clone              = true
  cloudinit_cdrom_storage = var.vm_storage_class
  agent                   = 1
  nameserver              = var.vm_nameserver
  ssh_user                = var.kubernetes_master_node.master.ssh_user
  scsihw                  = "virtio-scsi-pci"
  target_node             = each.value.proxmox_node
  ipconfig0               = "ip=${each.value.ip}/${each.value.ip_param}"
  clone                   = "debian-base"
  define_connection_info  = true
  sshkeys                 = var.vm_ssh_keys
  ssh_private_key         = var.vm_ssh_keys


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
  name                    = each.value.worker_name
  desc                    = var.kubernetes_worker_node.worker.description
  ci_wait                 = 60
  cores                   = var.kubernetes_worker_node.worker.cpu_core
  sockets                 = var.kubernetes_worker_node.worker.cpu_socket
  memory                  = var.kubernetes_worker_node.worker.memory_mb
  os_type                 = var.vm_os_type
  full_clone              = true
  cloudinit_cdrom_storage = var.vm_storage_class
  agent                   = 1
  nameserver              = var.vm_nameserver
  ssh_user                = var.kubernetes_worker_node.worker.ssh_user
  scsihw                  = "virtio-scsi-pci"
  target_node             = each.value.proxmox_node
  ipconfig0               = "ip=${each.value.ip}/${each.value.ip_param}"
  clone                   = "debian-base"
  define_connection_info  = true
  sshkeys                 = var.vm_ssh_keys
  ssh_private_key         = var.vm_ssh_keys

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


resource "local_file" "ansible_inventory" {
  filename = "./ansible/playbooks/kubespray/inventory/test/inventory.ini"
  content = templatefile("../templates/inventory.tpl", {
    master_nodes = [for vm in proxmox_vm_qemu.kubernetes_masters : vm.ssh_host]
    worker_nodes = [for vm in proxmox_vm_qemu.kubernetes_workers : vm.ssh_host]

  })
}

resource "null_resource" "kubernetes_clustert_creation" {
  depends_on = [local_file.ansible_inventory, proxmox_vm_qemu.kubernetes_masters, proxmox_vm_qemu.kubernetes_workers]
  triggers = {
    kubernetes_cluster = local_file.ansible_inventory.content_md5
  }
  provisioner "local-exec" {
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_USER              = "adm_test"
      ANSIBLE_SSH_PASS          = "test"
      ANSIBLE_BECOME            = "yes"
      ANSIBLE_BECOME_METHOD     = "su"
      ANSIBLE_BECOME_USER       = "root"
      ANSIBLE_BECOME_PASSWORD   = "toor"
    }
    command = "ansible-playbook -i ./ansible/playbooks/kubespray/inventory/test/inventory.ini --extra-vars \"ansible_user=$ANSIBLE_USER ansible_password=$ANSIBLE_SSH_PASS ansible_become_user=$ANSIBLE_BECOME_USER ansible_become_password=$ANSIBLE_BECOME_PASSWORD\"  --become --become-user=root ./ansible/playbooks/kubespray/cluster.yml"
  }

}

resource "proxmox_vm_qemu" "kubernetes_masters" {
  depends_on = [null_resource.packer_image_creation]
  for_each = tomap({
    for provisionning in local.master_provision : "${provisionning.master_name}" => provisionning
  })

  name                   = each.value.master_name
  desc                   = var.kubernetes_master_node.master.description
  ci_wait                = 60
  vcpus                  = var.kubernetes_master_node.master.cpu_core
  cores                  = var.kubernetes_master_node.master.cpu_core
  sockets                = var.kubernetes_master_node.master.cpu_socket
  memory                 = var.kubernetes_master_node.master.memory_mb
  os_type                = var.vm_os_type
  full_clone             = true
  agent                  = 1
  nameserver             = var.vm_nameserver
  scsihw                 = "virtio-scsi-pci"
  target_node            = each.value.proxmox_node
  ipconfig0              = "ip=${each.value.ip}/${each.value.ip_param}"
  clone                  = var.kubernetes_master_node.master.clone
  define_connection_info = true
  ssh_user               = local.GENERAL.VM_SSH_USER
  sshkeys                = local.GENERAL.VM_SSH_KEYS
  ssh_private_key        = local.GENERAL.VM_SSH_KEYS


  disks {
    virtio {
      virtio0 {
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
  depends_on = [null_resource.packer_image_creation]
  for_each = tomap({
    for provisionning in local.worker_provision : "${provisionning.worker_name}" => provisionning
  })
  name                   = each.value.worker_name
  desc                   = var.kubernetes_worker_node.worker.description
  ci_wait                = 60
  vcpus                  = var.kubernetes_master_node.master.cpu_core
  cores                  = var.kubernetes_worker_node.worker.cpu_core
  sockets                = var.kubernetes_worker_node.worker.cpu_socket
  memory                 = var.kubernetes_worker_node.worker.memory_mb
  os_type                = var.vm_os_type
  full_clone             = true
  agent                  = 1
  nameserver             = var.vm_nameserver
  scsihw                 = "virtio-scsi-pci"
  target_node            = each.value.proxmox_node
  ipconfig0              = "ip=${each.value.ip}/${each.value.ip_param}"
  clone                  = var.kubernetes_worker_node.worker.clone
  define_connection_info = true
  ssh_user               = local.GENERAL.VM_SSH_USER
  sshkeys                = local.GENERAL.VM_SSH_KEYS
  ssh_private_key        = local.GENERAL.VM_SSH_KEYS

  disks {
    virtio {
      virtio0 {
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

resource "null_resource" "ansible_directory" {
  depends_on = [proxmox_vm_qemu.kubernetes_masters, proxmox_vm_qemu.kubernetes_workers]
  triggers = {
  file_exist = fileexists("./ansible/playbooks/kubespray/inventory/${local.GENERAL.CLUSTER_NAME}/artifacts/admin.conf") ? "exists" : "not_exists" }
  provisioner "local-exec" {
    command = "mkdir -p ./ansible/playbooks/kubespray/inventory/${each.key}"
  }
  provisioner "local-exec" {
    command = "cp -r ./ansible/playbooks/kubespray/inventory/sample/* ./ansible/playbooks/kubespray/inventory/${each.key}/."
  }
}

resource "local_file" "ansible_inventory" {
  filename = "./ansible/playbooks/kubespray/inventory/${local.GENERAL.CLUSTER_NAME}/inventory.ini"
  content = templatefile("./templates/inventory.tpl", {
    master_nodes = [for vm in proxmox_vm_qemu.kubernetes_masters : vm.ssh_host]
    worker_nodes = [for vm in proxmox_vm_qemu.kubernetes_workers : vm.ssh_host]

  })
}

resource "null_resource" "kubernetes_cluster_creation" {
  depends_on = [local_file.ansible_inventory, proxmox_vm_qemu.kubernetes_masters, proxmox_vm_qemu.kubernetes_workers]
  triggers = {
    file_exist = fileexists("./ansible/playbooks/kubespray/inventory/${local.GENERAL.CLUSTER_NAME}/artifacts/admin.conf") ? "exists" : "not_exists"
  }
  provisioner "local-exec" {
    working_dir = "./ansible/playbooks/kubespray/"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
      ANSIBLE_USER              = local.GENERAL.VM_SSH_USER
      ANSIBLE_SSH_PASS          = random_password.user_password.result
      ANSIBLE_BECOME            = "yes"
      ANSIBLE_BECOME_METHOD     = "su"
      ANSIBLE_BECOME_USER       = "root"
      ANSIBLE_BECOME_PASSWORD   = random_password.root_password.result
    }
    command = "ansible-playbook -i inventory/${local.GENERAL.CLUSTER_NAME}/inventory.ini --extra-vars \"ansible_user=$ANSIBLE_USER ansible_password=$ANSIBLE_SSH_PASS ansible_become_user=$ANSIBLE_BECOME_USER ansible_become_password=$ANSIBLE_BECOME_PASSWORD\"  --become --become-user=root cluster.yml"
  }
}

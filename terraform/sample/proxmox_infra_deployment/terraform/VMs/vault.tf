# resource "proxmox_vm_qemu" "vault_cluster" {
#   for_each = var.vault_cluster

#   name                    = each.value.name
#   desc                    = each.value.description
#   target_node             = each.value.host
#   clone                   = each.value.clone
#   full_clone              = true
#   cloudinit_cdrom_storage = var.vm_storage_class
#   agent                   = 0
#   scsihw                  = "virtio-scsi-pci"
#   ci_wait                 = 60
#   cores                   = each.value.cpu_core
#   sockets                 = each.value.cpu_socket
#   memory                  = each.value.memory_mb
#   os_type                 = var.vm_os_type
#   ipconfig0               = each.value.ipconfig0
#   nameserver              = var.vm_nameserver
#   ssh_user                = each.value.ssh_user
#   sshkeys                 = var.vm_ssh_keys

#   disks {
#     scsi {
#       scsi0 {
#         disk {
#           size    = each.value.disk_size_gb
#           storage = var.vm_storage_class
#         }
#       }
#     }
#   }

#   network {
#     model  = "virtio"
#     bridge = "vmbr0"
#   }

#   timeouts {
#     create = "5m"
#     update = "5m"
#     delete = "5m"
#   }
# }
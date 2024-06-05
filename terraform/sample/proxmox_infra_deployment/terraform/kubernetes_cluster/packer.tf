resource "local_file" "debian_preseed" {
  filename = "./packer/http/preseed.cfg"
  content = templatefile("./templates/preseed.cfg.tpl", {
    vm_name       = "debian-base"
    ssh_username  = local.GENERAL.VM_SSH_USER
    root_password = random_password.root_password.result
    user_password = random_password.user_password.result

  })
}

resource "random_password" "root_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?/"
}

output "root_password" {
  value     = random_password.root_password.result
  sensitive = true
}

resource "random_password" "user_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?/"
}

output "user_password" {
  value     = random_password.user_password.result
  sensitive = true
}

resource "null_resource" "debian_base_image_creation" {
  depends_on = [local_file.debian_preseed]
  for_each   = local.NODES
  triggers = {
    data_hash            = sha256(join(",", [local.BASE_IMAGE.ISO_URL, local.BASE_IMAGE.ISO_CHECKSUM]))
    debian_base_pkr_hash = filesha256("./packer/debian_base.pkr.hcl")
  }

  provisioner "local-exec" {
    when = create

    environment = {
      proxmox_api_url          = local.GENERAL.PM_API_URL
      proxmox_api_token_id     = local.GENERAL.PM_API_TOKEN_ID
      proxmox_api_token_secret = local.GENERAL.PM_API_TOKEN_SECRET
      proxmox_node             = each.value.PROXMOX_NODE_NAME
      ssh_username             = local.GENERAL.VM_SSH_USER
      ssh_password             = random_password.user_password.result
      cloud_init_storage_pool  = var.cloud_init_storage_pool
      iso_url                  = local.BASE_IMAGE.ISO_URL
      iso_checksum             = local.BASE_IMAGE.ISO_CHECKSUM
      iso_storage_pool         = var.iso_storage_pool
      vm_storage_class         = var.vm_storage_class
    }
    command = <<-EOF
    cd ./packer
    packer init debian_base.pkr.hcl
    packer build \
      -var "proxmox_api_url=$proxmox_api_url" \
      -var "proxmox_api_token_id=$proxmox_api_token_id" \
      -var "proxmox_api_token_secret=$proxmox_api_token_secret" \
      -var "ssh_password=$ssh_password" \
      -var "ssh_username=$ssh_username" \
      -var "proxmox_node=$proxmox_node" \
      -var "cloud_init_storage_pool=$cloud_init_storage_pool" \
      -var "iso_storage_pool=$iso_storage_pool" \
      -var "vm_storage_class=$vm_storage_class" \
      -var "iso_url=$iso_url" \
      -var "iso_checksum=$iso_checksum" \
      debian_base.pkr.hcl

    EOF
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "k8s_base_image_creation" {
  depends_on = [null_resource.debian_base_image_creation, local_file.debian_preseed]
  for_each   = local.NODES
  triggers = {
    data_hash            = sha256(join(",", [local.BASE_IMAGE.ISO_URL, local.BASE_IMAGE.ISO_CHECKSUM]))
    debian_base_pkr_hash = filesha256("./packer/debian_base.pkr.hcl")
  }

  provisioner "local-exec" {
    when = create

    environment = {
      proxmox_api_url          = local.GENERAL.PM_API_URL
      proxmox_api_token_id     = local.GENERAL.PM_API_TOKEN_ID
      proxmox_api_token_secret = local.GENERAL.PM_API_TOKEN_SECRET
      proxmox_node             = each.value.PROXMOX_NODE_NAME
      ssh_username             = local.GENERAL.VM_SSH_USER
      ssh_password             = random_password.user_password.result
      cloud_init_storage_pool  = var.cloud_init_storage_pool
      iso_url                  = local.BASE_IMAGE.ISO_URL
      iso_checksum             = local.BASE_IMAGE.ISO_CHECKSUM
      vm_storage_class         = var.vm_storage_class
    }
    command = <<-EOF
    cd ./packer
    packer init k8s-base.pkr.hcl  
    packer build \
      -var "proxmox_api_url=$proxmox_api_url" \
      -var "proxmox_api_token_id=$proxmox_api_token_id" \
      -var "proxmox_api_token_secret=$proxmox_api_token_secret" \
      -var "ssh_password=$ssh_password" \
      -var "ssh_username=$ssh_username" \
      -var "proxmox_node=$proxmox_node" \
      -var "cloud_init_storage_pool=$cloud_init_storage_pool" \
      -var "vm_storage_class=$vm_storage_class" \
      k8s-base.pkr.hcl

    EOF
  }
  lifecycle {
    create_before_destroy = true
  }
}
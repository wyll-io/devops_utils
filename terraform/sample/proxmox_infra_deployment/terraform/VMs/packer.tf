resource "local_file" "debian_preseed" {
  filename = "./packer/http/preseed.cfg"
  content = templatefile("../templates/preseed.cfg.tpl", {
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
  value = random_password.root_password.result
}

resource "random_password" "user_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?/"
}

output "user_password" {
  value = random_password.user_password.result
}

resource "null_resource" "packer_image_creation" {
  depends_on = [local_file.debian_preseed]
  for_each   = local.NODES
  triggers = {
    kubernetes_cluster = local_file.debian_preseed.content_md5
  }
  provisioner "local-exec" {
    environment = {
      proxmox_api_url          = local.GENERAL.PM_API_URL
      proxmox_api_token_id     = local.GENERAL.PM_API_TOKEN_ID
      proxmox_api_token_secret = local.GENERAL.PM_API_TOKEN_SECRET
      proxmox_node             = each.value.PROXMOX_NODE_NAME
      ssh_username             = local.GENERAL.VM_SSH_USER
      ssh_password             = random_password.user_password.result

    }
    command = <<-EOF
    packer build \
      -var 'proxmox_api_url=$proxmox_api_url' \
      -var 'proxmox_api_token_id=$proxmox_api_token_id' \
      -var 'proxmox_api_token_secret=$proxmox_api_token_secret
      -var 'ssh_password=$ssh_password' \
      -var 'ssh_username=$ssh_username' \
      -var 'proxmox_node=$proxmox_node' \
    packer/debian_base.pkr.hcl"
 EOF
  }
}
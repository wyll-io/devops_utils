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
  default = "admin"
}

variable "proxmox_node" {
  type    = string
  default = ""
}

source "proxmox-iso" "debian-cloud" {
  proxmox_url = var.proxmox_api_url
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret

  node                 = var.proxmox_node
  vm_name              = "debian-base-pkr"
  template_description = "Debian Cloud Image"

  insecure_skip_tls_verify = true

  iso_url          = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
  iso_checksum     = "sha256:013f5b44670d81280b5b1bc02455842b250df2f0c6763398feb69af1a805a14f"
  iso_storage_pool = "local"
  unmount_iso      = true
  qemu_agent       = true

  scsi_controller = "virtio-scsi-pci"

  cores   = "2"
  sockets = "1"
  memory  = "2048"

  cloud_init              = true
  cloud_init_storage_pool = "datastore"

  vga {
    type = "virtio"
  }

  disks {
    disk_size    = "20G"
    format       = "raw"
    storage_pool = "datastore"
    type         = "virtio"
  }

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  boot_command = [
    "<esc><wait>",
    "auto <wait>",
    "console-keymaps-at/keymap=fr <wait>",
    "console-setup/ask_detect=false <wait>",
    "debconf/frontend=noninteractive <wait>",
    "debian-installer=fr_FR <wait>",
    "fb=false <wait>",
    "install <wait>",
    "packer_host={{ .HTTPIP }} <wait>",
    "packer_port={{ .HTTPPort }} <wait>",
    "kbd-chooser/method=fr <wait>",
    "keyboard-configuration/xkb-keymap=fr <wait>",
    "locale=fr_FR <wait>",
    "netcfg/get_hostname=debian-base <wait>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg <wait>",
    "DEBIAN_FRONTEND=text <wait>",
    "DEBCONF_DEBUG=5 <wait>",
    "BOOT_DEBUG=2 <wait>",
    "<enter><wait>"
  ]

  boot      = "c"
  boot_wait = "6s"

  http_directory = "./http"

  communicator           = "ssh"
  ssh_username           = var.ssh_username
  ssh_password           = var.ssh_password
  ssh_timeout            = "15m"
  ssh_pty                = true
  ssh_handshake_attempts = 15
}

build {
  name = "debian_base_pkr"
  sources = [
    "source.proxmox-iso.debian-cloud"
  ]

  provisioner "shell" {
    inline = ["cloud-init status --wait"]
  }

  provisioner "shell" {
    execute_command = "echo -e '<user>' | sudo -S -E bash '{{ .Path }}'"
    inline = [
      "echo 'Clean'",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync",
      "echo 'Done Stage: Provisioning the VM Template for Cloud-Init Integration in Proxmox'"
    ]
  }
}

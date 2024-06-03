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

variable "cloud_init_storage_pool" {
  type        = string
  description = "Storage class "
  default     = "datastore"
}

variable "iso_storage_pool" {
  type        = string
  description = "Storage class "
  default     = "local"
}

variable "vm_storage_class" {
  type        = string
  description = "Storage class"
  default     = "datastore"
}

variable "iso_url" {
  type        = string
  description = "Url de l'iso"
  default     = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.5.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type        = string
  description = "Storage class"
  default     = "sha256:013f5b44670d81280b5b1bc02455842b250df2f0c6763398feb69af1a805a14f"
}

source "proxmox-iso" "debian-cloud" {
  proxmox_url = var.proxmox_api_url
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret

  node                 = var.proxmox_node
  vm_name              = "debian-base-pkr"
  template_description = "Debian Cloud Image"

  insecure_skip_tls_verify = true

  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  iso_storage_pool = var.iso_storage_pool
  unmount_iso      = true
  qemu_agent       = true

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

  disks {
    disk_size    = "20G"
    format       = "raw"
    storage_pool = var.vm_storage_class
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
    "packer_host=10.10.0.234 <wait>",
    "packer_port={{ .HTTPPort }} <wait>",
    "kbd-chooser/method=fr <wait>",
    "keyboard-configuration/xkb-keymap=fr <wait>",
    "locale=fr_FR <wait>",
    "netcfg/get_hostname=debian-base <wait>",
    "preseed/url=http://10.10.0.234:{{ .HTTPPort }}/preseed.cfg <wait>",
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
}

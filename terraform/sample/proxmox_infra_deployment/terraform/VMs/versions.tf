terraform {
  required_version = ">= 1.6.5"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}
provider "proxmox" {
  pm_debug            = var.pm_debug
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_parallel         = 1
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# provider "ansible" {


# }

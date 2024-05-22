provider "proxmox" {
  pm_debug            = local.GENERAL.PM_DEBUG
  pm_api_url          = local.GENERAL.PM_API_URL
  pm_api_token_id     = local.GENERAL.PM_API_TOKEN_ID
  pm_api_token_secret = local.GENERAL.PM_API_TOKEN_SECRET
  pm_parallel         = 1
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "random" {
}

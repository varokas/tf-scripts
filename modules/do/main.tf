provider "digitalocean" {
  token = "${var.do_token}"
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

resource "digitalocean_ssh_key" "terraform" {
  name       = "terraform"
  public_key = "${file(var.public_key_path)}"
}

resource "digitalocean_droplet" "winter" {
  image  = "ubuntu-18-04-x64"
  name   = "winter"
  region = "sfo2"
  size   = "s-1vcpu-1gb"
  backups = "true"
  ssh_keys = ["${var.terraform_ssh_fingerprint}"]
}

# Create DNS record on CloudFlare
resource "cloudflare_record" "winter" {
  domain = "varokas.com"
  name   = "blog"
  value  = "${digitalocean_droplet.winter.ipv4_address}"
  type   = "A"
  ttl    = 3600
}
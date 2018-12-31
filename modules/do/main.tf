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

resource "digitalocean_droplet" "wordpress" {
  image  = "ubuntu-18-04-x64"
  name   = "wordpress"
  region = "sfo2"
  size   = "s-1vcpu-1gb"
  backups = "true"
  ssh_keys = ["89:1b:3e:b1:cd:37:53:9c:78:19:48:6b:e6:df:81:fe"] # ssh-keygen -E md5 -lf ~/.ssh/terraform.pub | awk '{print $2}' (after MD5: part)
}

# Create DNS record on CloudFlare
resource "cloudflare_record" "blog" {
  domain = "varokas.com"
  name   = "blog"
  value  = "${digitalocean_droplet.wordpress.ipv4_address}"
  type   = "A"
  ttl    = 3600
}
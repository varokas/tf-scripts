module "varokas_com" {
  source  = "modules/do"
  do_token = "${var.do_token}"
  cloudflare_email = "${var.cloudflare_email}"
  cloudflare_token = "${var.cloudflare_token}"
}
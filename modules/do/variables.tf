variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION
  default = "~/.ssh/terraform.pub"
}

variable "do_token" {
  description = "Digital Ocean access token"
}

variable "cloudflare_email" { }
variable "cloudflare_token" { } 
variable "terraform_ssh_fingerprint" { }
variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION
  default = "~/.ssh/terraform.pub"
}

variable "ubuntu_1804_uswest_2" {
  default = "ami-05705259d15c98ef1" #Ubuntu 18.04 AMI for us-west-02 region
}

variable "cloudflare_email" { }
variable "cloudflare_token" { } 

# Terraform Scripts

## Install
```
brew install terraform

brew install ansible
brew install terraform-inventory
```

## Prerequisite 
1. Create ~/.aws/credentials. Obtain keys from Profile -> "My Security Credentials"
```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

2. Create or copy a public-private key pair to access instances to `~/.ssh/terraform.pub`
```
ssh-keygen -f ~/.ssh/terraform
```

3. Create `terraform.tfvars`
```
cloudflare_email="<cloudflare_email>"
cloudflare_token="<cloudflare_token>" # From My Profile -> API Keys
```

## Usage 
1. `terraform init`. This will download plugins needed.
2. `terraform apply`. Will create/update/destroy EC2 instances as defined in `main.tf`

First execution plan will be shown
```
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_vpc.default
      id:                               <computed>
      arn:                              <computed>
      assign_generated_ipv6_cidr_block: "false"
      cidr_block:                       "10.0.0.0/16"
      default_network_acl_id:           <computed>
      default_route_table_id:           <computed>
      default_security_group_id:        <computed>
      dhcp_options_id:                  <computed>
      enable_classiclink:               <computed>
      enable_classiclink_dns_support:   <computed>
      enable_dns_hostnames:             <computed>
      enable_dns_support:               "true"
      instance_tenancy:                 "default"
      ipv6_association_id:              <computed>
      ipv6_cidr_block:                  <computed>
      main_route_table_id:              <computed>


Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: 

```

Then it is applied after keyboard confirmation

```
  Enter a value: yes

aws_vpc.default: Creating...
  arn:                              "" => "<computed>"
  assign_generated_ipv6_cidr_block: "" => "false"
  cidr_block:                       "" => "10.0.0.0/16"
  default_network_acl_id:           "" => "<computed>"
  default_route_table_id:           "" => "<computed>"
  default_security_group_id:        "" => "<computed>"
  dhcp_options_id:                  "" => "<computed>"
  enable_classiclink:               "" => "<computed>"
  enable_classiclink_dns_support:   "" => "<computed>"
  enable_dns_hostnames:             "" => "<computed>"
  enable_dns_support:               "" => "true"
  instance_tenancy:                 "" => "default"
  ipv6_association_id:              "" => "<computed>"
  ipv6_cidr_block:                  "" => "<computed>"
  main_route_table_id:              "" => "<computed>"
[aws_vpc.default: Creation complete after 6s (ID: vpc-080051c8aaca21b68)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

example01-ip = 44.252.122.77
```

Outputs we see are what is defined in the `output` block in `main.tf`

3. ssh to the instance

We can query for it or use in the ssh script to the instance, or use DNS entry created by cloudflare.
```
❯❯❯ terraform output example01-ip
44.252.122.77
❯❯❯ ssh -i ~/.ssh/terraform ubuntu@`terraform output example01-ip`

### DNS should work after a while
❯❯❯ ssh -i ~/.ssh/terraform ubuntu@example01.varokas.com

```

4. State of the execution is kept in `terraform.tfstate.*`. Check this in a repository to share system state with others.

## Notes on using Ansible with Terraform
* Ansible dynamic scripts downloaded from https://github.com/adammck/terraform-inventory via brew
* Put it as default inventory source via `ansible.cfg`
* ansible.cfg is configured to read files in inventory/ as inventory file, so we need to symlink from `/usr/local/bin/terraform-inventory`

```
 ❯❯❯ ansible all --list-hosts
  hosts (1):
    35.165.28.244

 ❯❯❯ ansible role_example --list-hosts
  hosts (1):
    35.165.28.244

 ❯❯❯ ansible-playbook playbooks/example.yml

PLAY [role_example] *********************************

TASK [Gathering Facts] ******************************
ok: [35.162.30.126]

TASK [ufw : Enable Firewall and allow SSH] **********
changed: [35.162.30.126]

PLAY RECAP ******************************************
35.162.30.126              : ok=2    changed=1    unreachable=0    failed=0  
```

## Reference
* https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/two-tier
* https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html
* https://cloud-images.ubuntu.com/locator/ec2/
* https://github.com/adammck/terraform-inventory
* https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04

# Terraform Scripts

## Install
```
brew install terraform
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

We can query for it or use in the ssh script to the instance.
```
❯❯❯ terraform output example01-ip
44.252.122.77
❯❯❯ ssh -i ~/.ssh/terraform ubuntu@`terraform output example01-ip`
```

4. State of the execution is kept in `terraform.tfstate.*`. Check this in a repository to share system state with others.

## Reference
* https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/two-tier
* https://cloud-images.ubuntu.com/locator/ec2/

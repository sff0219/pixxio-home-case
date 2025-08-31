# Pixxio Home Case

Repository for the home case of the pixxio interview. This repository contains a small Terraform project that provisions a VPC with a public subnet and a private subnet, and a Terraform module for an EC2 instance and a S3 bucket.

## Development environment setup

### Prerequisites:

- OpenTofu (v1.10.5) with AWS provider (6.11.0)
- AWS CLI (2.28.11)
- AWS credentials configured (via `~/.aws/credentials` or environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`)
- An AWS S3 bucket for storing Terraform state files - referenced by the `bucket` variable in the [Terraform backend config file](./backend.config)
- An AWS key pair for SSH connection to EC2 instances - referenced by the `key_name` variable in the [Terraform variable file](./terraform.tfvars)

## How to deploy

### Adapt Terraform config and variable files

The repository uses AWS S3 for the Terraform state management and provides a [`backend.config`](./backend.config) file to setup.
Edit [`backend.config`](./backend.config) to set `bucket` and `key`, which define where the state file should be stored in AWS S3.

Example [`backend.config`](./backend.config) values to set before `tofu init`:

```hcl
bucket = "your-backend-bucket-name"
key    = "your-terraform-state-file.tfstate"
region = "eu-central-1"
```

The repository also provides [`variables.tf`](./variables.tf) as default definition and a [`terraform.tfvars`](./terraform.tfvars) file for local values.
Edit [`terraform.tfvars`](./terraform.tfvars) to set `bucket_name`, `prefix` and `key_name` at minimum.
Other variables can be set as well based on user need.

Example [`terraform.tfvars`](./terraform.tfvars) values to set before `tofu apply`:

```hcl
bucket_name = "your-bucket-name"
prefix      = "your-project"
key_name    = "your-ec2-keypair"
```

### Deploy Terraform templates

1. Initialize Terraform

```bash
tofu init -backend-config=backend.config
```

2. Inspect the planned changes:

```bash
tofu plan
```

3. Apply the plan:

```bash
tofu apply
```

### Clean up

When done, destroy resources to avoid charges:

```bash
tofu destroy
```

## Repository overview

This repository defines Terraform templates in [the root directory](./) and Terraform modules located under [the modules directory](./modules/).

Top-level files:

- `main.tf` contains the root module wiring submodules together.
- `variables.tf` defines variables used by the root module.
- `terraform.tfvars` provides variables values (local overrides).
- `backend.tf` defines Terraform backend configuration via AWS S3.
- `backend.config` provides bucket/key/region variables for Terraform backend configuration.
- `outputs.tf` defines outputs after `tofu apply`.
- `provider.tf` defines which plugin or dependency to install and use, in order to interact with services and cloud providers.
- `.terraform.lock.hcl` locks provider checksums and versions for reproducible runs.

Modules:

- `modules/vpc` defines the network infrastructure and creates one VPC with two subnets, one public and one private.
- `modules/ec2_s3` creates one public EC2 instance in the region `eu-central-1` and a S3 bucket in the region `us-east-1`. Here its own providers are also defined.

## Deployment architecture

High-level architecture created by this Terraform project:

- A VPC with the CIDR configured via the variable `vpc_cidr` (by default `10.0.0.0/16`).

- A public subnet configurable via the variable `public_subnet_cidr` (by default `10.0.1.0/24`) and a private subnet configurable via the variable `private_subnet_cidr` (by default `10.0.2.0/24`).

- An Internet Gateway attached to the VPC and a public route table with a default route to the IGW, associated with the public subnet.

- An NAT Gateway and a private route table with a default route to the NAT gateway, associated with the private subnet.

- A S3 bucket placed in the region `us-east-1`.

- A security group that allows inbound SSH (22) from anywhere (0.0.0.0/0) and allows all outbound traffic.

- An EC2 instance with a public IP launched in the public subnet using the provided AMI (`ami_id`) and instance type (`instance_type`). It uses the security group and can read, write, delete and list items in the bucket.

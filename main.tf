module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "ec2_s3" {
  source           = "./modules/ec2_s3"
  ami_id           = var.ami_id
  public_subnet_id = module.vpc.public_subnet_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  bucket_name      = var.bucket_name
  vpc_id           = module.vpc.vpc_id
  prefix           = var.prefix
}

module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

module "compute" {
  source = "./modules/compute"
  subnet_id = module.networking.public_subnet_ids[0]
  security_group_ids = module.security.instance_security_group_ids
  instance_type = var.instance_type
}

module "storage" {
  source = "./modules/storage"
  bucket_name = var.bucket_name
}
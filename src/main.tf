module "networking" {
  source = "./modules/networking"

  vpc_cidr           = var.vpc_cidr
  environment        = var.environment
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
}

module "security" {
  source = "./modules/security"

  vpc_id      = module.networking.vpc_id
  environment = var.environment
}

module "compute" {
  source = "./modules/compute"

  environment        = var.environment
  vpc_id            = module.networking.vpc_id
  subnet_ids        = module.networking.private_subnet_ids
  security_group_id = module.security.security_group_id
}

module "storage" {
  source = "./modules/storage"

  environment = var.environment
  kms_key_id  = module.security.kms_key_id
}

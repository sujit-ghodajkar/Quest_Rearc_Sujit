provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs" {
  source = "./modules/ecs"
}

module "alb" {
  source = "./modules/alb"
}

module "auto_scaling" {
  source = "./modules/auto-scaling"
}

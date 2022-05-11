terraform {
  cloud {
    organization = "zfc"
    workspaces {
      name = "terraform-modules-quickstart"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region = "us-east-1"

    default_tags {
      tags = {
          hashicorp-learn = "module-use"
      }
    }
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.14.0"
    name = var.vpc_name
    cidr = var.vpc_cidr
    azs = var.vpc_azs
    private_subnets = var.vpc_private_subnets
    public_subnets = var.vpc_public_subnets
    enable_nat_gateway = var.vpc_enable_nat_gateway
    tags = var.vpc_tags
}

module "ec2_instances" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "3.5.0"
    count = 2
    name = "my-ec2-cluster"
    ami = "ami-09d56f8956ab235b3"
    instance_type = "t2.micro"
    vpc_security_group_ids = [module.vpc.default_security_group_id]
    subnet_id = module.vpc.public_subnets[0]
    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}
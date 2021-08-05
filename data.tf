# Default VPC

data "aws_subnet_ids" "default_subnets" {
  vpc_id = var.elastic_beanstalk_env.default_vpc_id
}


# Availabile zone in region

data "aws_availability_zones" "available" {
  state = "available"
}

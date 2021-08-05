# Beanstalk pixelapp application

resource "aws_elastic_beanstalk_application" "pixelapp" {
  name        = var.elastic_beanstalk_app.name
  description = var.elastic_beanstalk_app.description
  tags        = var.tags_for_app
}


# Beanstalk environment WebTier

resource "aws_elastic_beanstalk_environment" "pixelapp-env-test" {
  name                = var.elastic_beanstalk_env.name
  application         = aws_elastic_beanstalk_application.pixelapp.name
  description         = var.elastic_beanstalk_env.description
  solution_stack_name = var.elastic_beanstalk_env.solution_stack_name
  tier                = var.elastic_beanstalk_env.tier
  tags                = var.tags_for_app


  # Default vpc in region

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.elastic_beanstalk_env.default_vpc_id
  }


  # Available subnets for vpc

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", data.aws_subnet_ids.default_subnets.ids)
  }


  # Assign public ip to instances

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = var.elastic_beanstalk_env.associate_public_ip_address
  }


  # Available subnets for load-balancer

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", data.aws_subnet_ids.default_subnets.ids)
  }


  # Role for beanstalk

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.elastic_beanstalk_env.eb_iam_instance_profile
  }


  # Set a public ssh key

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.my_own_private_key.key_name
  }

}
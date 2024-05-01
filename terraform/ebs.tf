# Service role creation for elastic beanstalk
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "elasticbeanstalk.amazonaws.com",
        "ecs.amazonaws.com",
        "cloudformation.amazonaws.com"
      ]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "aws_ebs_service_role" {
  name               = "aws_ebs_service_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.common_tags
}

# Attaching policies to role
resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWebTier" {
  role       = aws_iam_role.aws_ebs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWorkerTier" {
  role       = aws_iam_role.aws_ebs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkMulticontainerDocker" {
  role       = aws_iam_role.aws_ebs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

# Environment and application setup
module "key_pair" {
  source             = "terraform-aws-modules/key-pair/aws"
  key_name           = "ebs-ec2-key"
  create_private_key = true
}

resource "aws_elastic_beanstalk_application" "virtual_spider_zoo_app" {
  name        = "virtual_spider_zoo_app"
  description = "Virtual Spider Zoo App"
  tags        = var.common_tags
}

resource "aws_elastic_beanstalk_environment" "virtual_spider_zoo_app_env" {
  name                = "virtual_spider_zoo_app-env"
  application         = aws_elastic_beanstalk_application.virtual_spider_zoo_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.3 running Node.js 20"
  cname_prefix        = "virtual_spider_zoo"
  tags                = var.common_tags

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.default_vpc.id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.public_subnets[0].id},${aws_subnet.public_subnets[1].id}"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro,t3.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.aws_ebs_service_role.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = module.key_pair.key_pair_name
  }
}

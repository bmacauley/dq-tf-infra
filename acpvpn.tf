module "acpvpn" {
  source = "github.com/ukhomeoffice/dq-tf-mock-acp?ref=initial-mock-acp"

  providers = {
    aws = "aws.MOCK"
  }

  cidr_block            = "10.4.0.0/16"
  vpc_subnet_cidr_block = "10.4.1.0/24"
  az                    = "eu-west-2a"
  name_prefix           = "dq-"
}

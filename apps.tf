module "apps" {
  source = "github.com/UKHomeOffice/dq-tf-apps"

  providers = {
    aws = "aws.APPS"
  }

  cidr_block                      = "10.1.0.0/16"
  public_subnet_cidr_block        = "10.1.0.0/24"
  ad_subnet_cidr_block            = "10.1.16.0/24"
  az                              = "eu-west-2a"
  az2                             = "eu-west-2b"
  adminpassword                   = "${data.aws_kms_secret.ad_admin_password.ad_admin_password}"
  ad_aws_ssm_document_name        = "${module.ad.ad_aws_ssm_document_name}"
  ad_writer_instance_profile_name = "${module.ad.ad_writer_instance_profile_name}"
  naming_suffix                   = "${local.naming_suffix}"

  s3_bucket_name = {
    archive_log  = "s3-dq-log-archive-bucket-${var.NAMESPACE}"
    archive_data = "s3-dq-data-archive-bucket-${var.NAMESPACE}"
    working_data = "s3-dq-data-working-bucket-${var.NAMESPACE}"
    landing_data = "s3-dq-data-landing-bucket-${var.NAMESPACE}"
  }

  s3_bucket_acl = {
    archive_log  = "log-delivery-write"
    archive_data = "private"
    working_data = "private"
    landing_data = "private"
  }

  vpc_peering_connection_ids = {
    peering_to_peering = "${aws_vpc_peering_connection.peering_to_apps.id}"
    peering_to_ops     = "${aws_vpc_peering_connection.apps_to_ops.id}"
  }

  route_table_cidr_blocks = {
    peering_cidr = "${module.peering.peeringvpc_cidr_block}"
    ops_cidr     = "${module.ops.opsvpc_cidr_block}"
  }

  ad_sg_cidr_ingress = [
    "${module.peering.peeringvpc_cidr_block}",
    "${module.ops.opsvpc_cidr_block}",
    "${module.ad.cidr_block}",
    "10.1.0.0/16",
  ]
}

output "appsvpc_id" {
  value = "${module.apps.appsvpc_id}"
}

output "appsvpc_cidr_block" {
  value = "${module.apps.appsvpc_cidr_block}"
}

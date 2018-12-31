variable "credentials_file" {}
variable "credentials_profile" {}
variable "region" {}
variable "public_key" {}
variable "project_name" {}
variable "project_user" {}
variable "project_password" {}

provider "aws" {
	region = "${var.region}"
	shared_credentials_file = "${var.credentials_file}"
	profile = "${var.credentials_profile}"
}

resource "aws_key_pair" "terraform_key" {
	key_name = "terraform_key"
	public_key = "${var.public_key}" 
}

# Create a random EC2 ubuntu machine
#resource "aws_instance" "random" {
#	ami = "ami-00035f41c82244dab"
#	instance_type = "t1.micro"
#	key_name = "terraform_key"
#}

resource aws_db_instance "postgres" {
	# And not "postgresql"!! see https://github.com/terraform-providers/terraform-provider-aws/issues/4492
	engine = "postgres"
	allocated_storage = 20
	instance_class = "db.t2.small"
	publicly_accessible = true
	name = "${var.project_name}"
	username = "${var.project_user}"
	password = "${var.project_password}"
}

resource "aws_security_group_rule" "allow_ssh" {
	type = "ingress"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "sg-2db30c5c"
}

resource "aws_security_group_rule" "allow_postgres" {
	type = "ingress"
	from_port = 5432
	to_port = 5432
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "sg-2db30c5c"
}

output "instances_host" {
	value = ["${aws_db_instance.postgres.*.endpoint}"]
}


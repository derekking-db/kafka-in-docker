variable "region" {
	description = "The region to deploy the instance"
}

variable "instance_type" {
	description = "The instance type to deploy"
	default = "t2.xlarge"
	type = string
}

variable "instance_keypair" {
	description = "Key pair to login"
	type = string
	default = "us-west-2-all"
}

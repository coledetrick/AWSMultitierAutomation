locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  subnets = {
    private_az01 = { cidr = "10.0.0.0/28",  az = local.azs[0], public = false, name = "PrivateSubnet01AZ01" }
    public_az01  = { cidr = "10.0.0.16/28", az = local.azs[0], public = true,  name = "PublicSubnet01AZ01" }
    private_az02 = { cidr = "10.0.0.32/28", az = local.azs[1], public = false, name = "PrivateSubnet01AZ02" }
    public_az02  = { cidr = "10.0.0.48/28", az = local.azs[1], public = true,  name = "PublicSubnet01AZ02" }
  }
}

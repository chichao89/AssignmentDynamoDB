# Fetch all subnets matching the filter
data "aws_subnets" "public_subnets" {
  filter {
    name   = "tag:Name"
    values = ["*public*"] # Match subnets with a tag Name containing "public"
  }

}

# Fetch details of the first subnet to retrieve the VPC ID
data "aws_subnet" "first_public_subnet" {
  id = data.aws_subnets.public_subnets.ids[0] # Use the first public subnet
}
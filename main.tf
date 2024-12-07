# Create a DynamoDB table
resource "aws_dynamodb_table" "basic_table" {
  name           = var.name_prefix
  billing_mode   = var.pay_per_request # No provisioned capacity required
  hash_key       = var.hash_key
  range_key      = var.range_key

  # Define the attributes
  attribute {
    name = var.data1_prefix
    type = "S" # String type
  }

  attribute {
    name = var.data2_prefix
    type = "S" # String type

  }

  tags = {
    Environment = "Dev"
    Name        = "ExampleDynamoDBTable"
  }
}

# Create the policy, scoped to the specific DynamoDB table
resource "aws_iam_policy" "chichao_dynamodb_reader_policy" {
  name        = "chichao-dynamodb-reader"
  description = "Policy allowing all list and read actions for the specific DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = aws_dynamodb_table.basic_table.arn
      },
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:ListTables"
        ],
        Resource = "*"
      }
    ]
  })
}

# Create an IAM role for EC2
resource "aws_iam_role" "chichao_ec2_dynamodb_reader_role" {
  name = "chichao-ec2-dynamodb-reader-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "chichao_attach_policy_to_role" {
  role       = aws_iam_role.chichao_ec2_dynamodb_reader_role.name
  policy_arn = aws_iam_policy.chichao_dynamodb_reader_policy.arn
}

# Create an instance profile for EC2
resource "aws_iam_instance_profile" "chichao_ec2_instance_profile" {
  name = "chichao-ec2-dynamodb-reader-profile"
  role = aws_iam_role.chichao_ec2_dynamodb_reader_role.name
}

# Create a security group to allow inbound SSH access
resource "aws_security_group" "chichao_ec2_sg" {
  name        = "chichao-ec2-sg"
  description = "Allow SSH and HTTPS traffic"
  vpc_id = data.aws_subnet.first_public_subnet.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (not recommended for production)
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# Define the EC2 instance
resource "aws_instance" "chichao_ec2_instance" {
  ami                         = "ami-0f935a2ecd3a7bd5c" # Replace with your region's Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.chichao_ec2_instance_profile.name
  subnet_id                   = data.aws_subnets.public_subnets.ids[0]# Reference the public subnet
  associate_public_ip_address = true                        # Enable public IP
  key_name                    = "chichao-iam"
  vpc_security_group_ids = [aws_security_group.chichao_ec2_sg.id]

  tags = {
    Name = "chichao-ec2-dynamodb-reader-instance"
  }
}






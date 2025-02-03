provider "aws" {
  region = "us-east-1"  # Change as needed
  profile = "ch"  # Use your AWS CLI profile
}

resource "aws_instance" "ec2_pipeline" {
  ami           = "ami-0e1bed4f06a3b463d"  # Ubuntu 20.04 LTS AMI ID (Check latest for your region)
  instance_type = "t2.small"
  key_name      = "pipelinekey.pem"  # Ensure this key pair exists

  vpc_security_group_ids = ["sg-079188a152b08d717"]  # Replace with your existing Security Group ID
  subnet_id             = "subnet-726dcd3f" # Replace with an existing subnet ID in your VPC

  tags = {
    Name = "Pipeline-EC2"
  }
}

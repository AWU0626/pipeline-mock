# configure iam role
resource "aws_iam_role" "ec2_role" {
  name = "auth-service-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# configure policy, put & get item
resource "aws_iam_role_policy" "dynamodb_access" {
  name = "dynamodb-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["dynamodb:PutItem", "dynamodb:GetItem"]
      Effect   = "Allow"
      Resource = var.dynamodb_table_arn
    }]
  })
}

# attach iam role to ec2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "auth-service-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# configure security group
resource "aws_security_group" "ec2_sg" {
  name   = "auth-service-ec2-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# configure ec2 instance
resource "aws_instance" "auth_service" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y java-21-amazon-corretto
    cd /home/ec2-user
    aws s3 cp s3://${var.jar_s3_bucket}/${var.jar_s3_key} app.jar
    nohup java -jar app.jar --server.port=8080 &
  EOF

  tags = {
    Name = "auth-service"
  }
}
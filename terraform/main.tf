# Configure AWS Provider
provider "aws" {
  region = var.aws_region
}

# Data source to fetch latest Amazon Linux 2 AMI if ami_id is not provided
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# S3 Bucket Resource
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Static Website Bucket"
    Environment = "DevOps Assignment"
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.website_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# S3 Bucket Public Access Block - Disable all blocks to allow public website hosting
resource "aws_s3_bucket_public_access_block" "website_public_access" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy - Allow public read access for all objects
resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  # Ensure public access block is configured before applying policy
  depends_on = [aws_s3_bucket_public_access_block.website_public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website_bucket.arn}/*"
      }
    ]
  })
}

# Upload index.html to S3 Bucket
resource "aws_s3_object" "website_index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "${path.module}/s3_website/index.html"
  content_type = "text/html"
  etag         = filemd5("${path.module}/s3_website/index.html")

  # Ensure bucket policy and website configuration are applied before uploading
  depends_on   = [
    aws_s3_bucket_policy.website_policy,
    aws_s3_bucket_website_configuration.website_config
  ]
}

# Security Group for Web Server
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Security group for web server allowing HTTP and SSH access"

  # Ingress rule for HTTP (port 80)
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress rule for SSH (port 22)
  ingress {
    description = "SSH from Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule allowing all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Web Server Security Group"
    Environment = "DevOps Assignment"
  }
}

# Generate SSH Private Key for EC2 access
resource "tls_private_key" "instance_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS Key Pair
resource "aws_key_pair" "generated_key" {
  key_name   = "unlox-devops-key"
  public_key = tls_private_key.instance_key.public_key_openssh
}

# Save Private Key locally for SSH connection
resource "local_file" "private_key" {
  content         = tls_private_key.instance_key.private_key_pem
  filename        = "${path.module}/unlox-devops-key.pem"
  file_permission = "0600"
}

# EC2 Instance Resource
resource "aws_instance" "web_server" {
  ami                    = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # User data script for automated Nginx installation and configuration
  user_data = <<-EOF
              #!/bin/bash
              # Detect OS and install Nginx
              if command -v apt-get &> /dev/null; then
                # Ubuntu/Debian system
                apt-get update -y
                apt-get install -y nginx
                systemctl start nginx
                systemctl enable nginx
                echo "<h1>Hello from EC2 Nginx</h1>" > /var/www/html/index.html
              elif command -v yum &> /dev/null; then
                # Amazon Linux / RHEL system
                yum update -y
                if command -v amazon-linux-extras &> /dev/null; then
                  amazon-linux-extras install nginx1 -y
                else
                  yum install -y nginx
                fi
                systemctl start nginx
                systemctl enable nginx
                echo "<h1>Hello from EC2 Nginx</h1>" > /usr/share/nginx/html/index.html
              fi
              EOF

  tags = {
    Name = "WebServer"
  }
}

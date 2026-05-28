# Output for S3 bucket website endpoint URL
output "s3_website_endpoint" {
  description = "S3 bucket website endpoint URL"
  value       = "http://${aws_s3_bucket_website_configuration.website_config.website_endpoint}"
}

# Output for EC2 instance public IP address
output "ec2_public_ip" {
  description = "EC2 instance public IP address"
  value       = aws_instance.web_server.public_ip
}

# Output for S3 bucket name
output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website_bucket.id
}

# Output for EC2 SSH connection command
output "ssh_connection_command" {
  description = "SSH connection command for the EC2 web server"
  value       = "ssh -i unlox-devops-key.pem ec2-user@${aws_instance.web_server.public_ip}"
}


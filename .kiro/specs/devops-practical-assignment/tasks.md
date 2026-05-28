# Implementation Plan: DevOps Practical Assignment

## Overview

This implementation plan breaks down the DevOps practical assignment into discrete, actionable tasks. The assignment demonstrates Infrastructure as Code (IaC) using Terraform for AWS resource provisioning, Docker containerization for application deployment, and cloud infrastructure setup with S3 static website hosting and EC2 with Nginx.

The implementation follows a logical progression:
1. Project setup and prerequisites
2. Terraform infrastructure configuration
3. Docker application development and deployment
4. AWS resource provisioning and verification
5. Documentation and cleanup

## Tasks

- [x] 1. Initialize project structure and verify prerequisites
  - Create project directory structure (terraform/, docker/, docs/)
  - Verify Terraform CLI installation (`terraform --version`)
  - Verify Docker installation (`docker --version`)
  - Verify AWS CLI installation (`aws --version`)
  - Configure AWS credentials using `aws configure`
  - Create .gitignore file to exclude terraform.tfstate, .terraform/, and sensitive files
  - _Requirements: 1.1, 11.1, 11.2, 11.3, 11.4_

- [x] 2. Create Terraform configuration files for AWS infrastructure
  - [x] 2.1 Create variables.tf with input variable definitions
    - Define `aws_region` variable (default: "us-east-1")
    - Define `bucket_name` variable with unique naming convention
    - Define `ami_id` variable for EC2 instance (Amazon Linux 2 or Ubuntu 22.04)
    - Define `key_pair_name` variable for SSH access (optional)
    - Add variable descriptions and validation rules
    - _Requirements: 1.1, 2.1, 7.1, 7.5_

  - [x] 2.2 Create main.tf with AWS provider and resource definitions
    - Configure AWS provider with region from variables
    - Define aws_s3_bucket resource with unique bucket name
    - Define aws_s3_bucket_versioning resource with enabled status
    - Define aws_s3_bucket_website_configuration with index.html
    - Define aws_s3_bucket_public_access_block with all settings set to false
    - Define aws_s3_bucket_policy with public read access for all objects
    - Define aws_security_group with HTTP (port 80) and SSH (port 22) ingress rules
    - Define aws_security_group egress rule allowing all outbound traffic
    - Define aws_instance resource with t2.micro instance type
    - Configure EC2 user_data script for automated Nginx installation
    - Add resource tags (Name: "WebServer" for EC2)
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 2.1, 2.2, 2.3, 2.4, 2.5, 7.1, 7.2, 7.3, 7.4, 7.6, 7.7_

  - [x] 2.3 Create outputs.tf with resource output values
    - Define output for S3 bucket website endpoint URL
    - Define output for EC2 instance public IP address
    - Define output for S3 bucket name
    - Add descriptions for all outputs
    - _Requirements: 1.6, 1.7_

- [x] 3. Checkpoint - Validate Terraform configuration
  - Run `terraform fmt` to format configuration files
  - Run `terraform validate` to check syntax and configuration
  - Review validation output and fix any errors
  - Ensure all tests pass, ask the user if questions arise.

- [x] 4. Create Docker Flask application
  - [x] 4.1 Create Flask application file (app.py)
    - Import Flask module
    - Initialize Flask application
    - Define root route ("/") returning "Hello from Docker"
    - Configure app.run() with host='0.0.0.0' and port=5000
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

  - [x] 4.2 Create Python dependencies file (requirements.txt)
    - Specify Flask==2.3.0 dependency
    - _Requirements: 5.3_

  - [x] 4.3 Create Dockerfile for containerization
    - Use python:3.9-slim as base image
    - Set WORKDIR to /app
    - Copy requirements.txt and run pip install
    - Copy app.py to container
    - Expose port 5000
    - Define CMD to run Flask application
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7_

- [x] 5. Build and test Docker image locally
  - [x] 5.1 Build Docker image
    - Run `docker build -t flask-app .` in docker directory
    - Verify build completes without errors
    - Check image appears in `docker images` list
    - _Requirements: 5.7_

  - [ ]* 5.2 Test Docker container locally
    - Run `docker run -d -p 5000:5000 flask-app`
    - Test application with `curl http://localhost:5000`
    - Verify response is "Hello from Docker"
    - Stop and remove test container
    - _Requirements: 4.3_

- [ ] 6. Push Docker image to Docker Hub
  - [x] 6.1 Authenticate with Docker Hub
    - Run `docker login` and enter credentials
    - Verify authentication succeeds
    - _Requirements: 12.1, 12.2, 12.3, 12.4_

  - [x] 6.2 Tag and push Docker image
    - Tag image with format: `docker tag flask-app {username}/flask-app:latest`
    - Push image: `docker push {username}/flask-app:latest`
    - Verify image appears in Docker Hub web interface
    - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [-] 7. Checkpoint - Verify Docker deployment
  - Confirm Docker image is publicly accessible on Docker Hub
  - Test pulling image from Docker Hub: `docker pull {username}/flask-app:latest`
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 8. Provision AWS infrastructure with Terraform
  - [-] 8.1 Initialize Terraform working directory
    - Run `terraform init` in terraform directory
    - Verify provider plugins are downloaded
    - Check for successful initialization message
    - _Requirements: 1.5_

  - [ ] 8.2 Plan infrastructure changes
    - Run `terraform plan` to preview resource creation
    - Review planned changes for S3 bucket, EC2 instance, and security group
    - Verify no errors in plan output
    - _Requirements: 1.5_

  - [ ] 8.3 Apply Terraform configuration
    - Run `terraform apply` and confirm with "yes"
    - Monitor resource creation progress
    - Verify all resources created successfully
    - Capture output values (S3 endpoint, EC2 public IP, bucket name)
    - _Requirements: 1.5, 1.6, 1.7, 2.1, 2.2, 2.3, 7.1, 7.6_

- [ ] 9. Upload static content to S3 bucket
  - [ ] 9.1 Create index.html file
    - Create HTML file with "Hello from S3" content
    - Include basic HTML structure (<!DOCTYPE html>, <html>, <head>, <body>)
    - _Requirements: 3.1_

  - [ ] 9.2 Upload index.html to S3 bucket
    - Use AWS CLI: `aws s3 cp index.html s3://{bucket-name}/`
    - Verify upload with `aws s3 ls s3://{bucket-name}/`
    - _Requirements: 3.2_

- [ ] 10. Verify AWS deployments and collect evidence
  - [ ]* 10.1 Test S3 static website accessibility
    - Navigate to S3 website endpoint URL in browser
    - Verify HTTP 200 response with "Hello from S3" content
    - Test with curl: `curl http://{bucket-name}.s3-website-{region}.amazonaws.com`
    - Take screenshot of S3 website in browser
    - _Requirements: 3.3, 3.4, 10.2_

  - [ ]* 10.2 Test EC2 Nginx accessibility
    - Navigate to EC2 public IP in browser (http://{ec2-public-ip})
    - Verify HTTP 200 response with "Hello from EC2 Nginx" content
    - Test with curl: `curl http://{ec2-public-ip}`
    - Take screenshot of Nginx page in browser
    - _Requirements: 8.5, 9.3, 10.6_

  - [ ]* 10.3 Verify Nginx service status on EC2
    - SSH into EC2 instance: `ssh -i {key-pair}.pem ec2-user@{ec2-public-ip}`
    - Check Nginx status: `sudo systemctl status nginx`
    - Verify service is active and enabled
    - Check cloud-init logs: `sudo cat /var/log/cloud-init-output.log`
    - _Requirements: 8.1, 8.2, 8.3, 8.4_

  - [ ]* 10.4 Verify Terraform state and outputs
    - Run `terraform show` to display current state
    - Run `terraform output` to list all output values
    - Verify S3 website endpoint, EC2 public IP, and bucket name are displayed
    - _Requirements: 1.6, 1.7_

- [ ] 11. Create comprehensive documentation
  - [ ] 11.1 Create README.md with project documentation
    - Add project overview and objectives
    - Document prerequisites (Terraform, Docker, AWS CLI, AWS account)
    - Include step-by-step setup instructions for AWS credentials
    - Document Terraform workflow (init, plan, apply, destroy)
    - Document Docker workflow (build, tag, push)
    - Include S3 bucket website URL with screenshot
    - Include Docker Hub repository link with screenshot
    - Include EC2 instance public IP with screenshot
    - Add troubleshooting section for common errors
    - Document resource cleanup instructions
    - Add cost management warnings and AWS Free Tier information
    - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5, 10.6, 10.7, 10.8, 13.1, 13.2, 13.3, 13.4, 13.5_

  - [ ] 11.2 Organize evidence and screenshots
    - Create docs/ or screenshots/ directory
    - Save S3 website screenshot
    - Save Docker Hub repository screenshot
    - Save EC2 Nginx screenshot
    - Save Terraform output screenshot
    - Reference all screenshots in README.md
    - _Requirements: 10.2, 10.4, 10.6_

- [ ] 12. Checkpoint - Final verification
  - Review all documentation for completeness
  - Verify all URLs and screenshots are included
  - Test all documented commands for accuracy
  - Ensure all requirements are met
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 13. Resource cleanup and cost management
  - [ ] 13.1 Delete S3 bucket contents
    - Run `aws s3 rm s3://{bucket-name} --recursive` to delete all objects
    - Verify bucket is empty with `aws s3 ls s3://{bucket-name}/`
    - _Requirements: 13.2_

  - [ ] 13.2 Destroy Terraform-managed infrastructure
    - Run `terraform destroy` in terraform directory
    - Review resources to be destroyed
    - Confirm destruction with "yes"
    - Verify all resources are deleted in AWS console
    - Check terraform state shows no managed resources
    - _Requirements: 1.8, 13.1, 13.5, 13.6_

  - [ ]* 13.3 Verify complete resource cleanup
    - Check AWS console for any orphaned resources
    - Verify S3 bucket is deleted
    - Verify EC2 instance is terminated
    - Verify security group is deleted
    - Confirm no unexpected AWS charges
    - _Requirements: 13.3, 13.4_

## Notes

- **Tasks marked with `*` are optional** and can be skipped for faster MVP delivery. These are primarily verification and testing tasks.
- **Terraform State Management**: The terraform.tfstate file must be excluded from version control but is essential for infrastructure management. Never delete this file while resources are active.
- **AWS Free Tier**: The t2.micro instance type is eligible for AWS Free Tier (750 hours/month for 12 months). Monitor usage to avoid unexpected charges.
- **Unique Bucket Naming**: S3 bucket names must be globally unique across all AWS accounts. Use a naming convention like `{username}-devops-assignment-{timestamp}` to ensure uniqueness.
- **Key Pair Management**: If SSH access to EC2 is required, create an EC2 key pair before running terraform apply. The key_pair_name variable can be made optional if SSH access is not needed.
- **User Data Script**: The EC2 user_data script automatically installs and configures Nginx at instance launch. Check `/var/log/cloud-init-output.log` on the instance if Nginx is not accessible.
- **Docker Hub Authentication**: Ensure you have a Docker Hub account and are logged in before attempting to push images.
- **Region Selection**: All resources should be created in the same AWS region specified in the variables.tf file. Default is us-east-1.
- **Cost Management**: Always run `terraform destroy` after completing the assignment to avoid ongoing AWS charges. Remember to delete S3 bucket contents first.
- **Infrastructure as Code**: All infrastructure changes should be made through Terraform configuration files, not manually in the AWS console, to maintain consistency and reproducibility.
- **Testing Strategy**: Since this is an IaC project, testing focuses on validation (terraform validate), deployment verification, and functional testing rather than property-based testing.

## Task Dependency Graph

```json
{
  "waves": [
    {
      "id": 0,
      "tasks": ["1"]
    },
    {
      "id": 1,
      "tasks": ["2.1", "4.1", "4.2"]
    },
    {
      "id": 2,
      "tasks": ["2.2", "4.3"]
    },
    {
      "id": 3,
      "tasks": ["2.3", "5.1"]
    },
    {
      "id": 4,
      "tasks": ["3", "5.2"]
    },
    {
      "id": 5,
      "tasks": ["6.1"]
    },
    {
      "id": 6,
      "tasks": ["6.2"]
    },
    {
      "id": 7,
      "tasks": ["7", "8.1"]
    },
    {
      "id": 8,
      "tasks": ["8.2"]
    },
    {
      "id": 9,
      "tasks": ["8.3"]
    },
    {
      "id": 10,
      "tasks": ["9.1"]
    },
    {
      "id": 11,
      "tasks": ["9.2"]
    },
    {
      "id": 12,
      "tasks": ["10.1", "10.2", "10.3", "10.4"]
    },
    {
      "id": 13,
      "tasks": ["11.1", "11.2"]
    },
    {
      "id": 14,
      "tasks": ["12"]
    },
    {
      "id": 15,
      "tasks": ["13.1"]
    },
    {
      "id": 16,
      "tasks": ["13.2"]
    },
    {
      "id": 17,
      "tasks": ["13.3"]
    }
  ]
}
```

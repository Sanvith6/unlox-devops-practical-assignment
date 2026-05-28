# Requirements Document

## Introduction

This document specifies the requirements for a comprehensive DevOps practical assignment that demonstrates proficiency in cloud infrastructure (AWS), containerization (Docker), and web server deployment. The assignment consists of three main tasks: AWS S3 bucket configuration for static website hosting, Docker image creation and deployment to Docker Hub, and AWS EC2 instance setup with Nginx web server.

## Glossary

- **S3_Service**: Amazon Simple Storage Service for object storage and static website hosting
- **EC2_Service**: Amazon Elastic Compute Cloud for virtual server instances
- **Docker_Engine**: Container runtime for building and running containerized applications
- **Docker_Hub**: Cloud-based registry service for storing and distributing Docker images
- **Nginx_Server**: High-performance web server and reverse proxy
- **Flask_Application**: Python web framework for building web applications
- **Bucket_Policy**: JSON-based access policy document for S3 bucket permissions
- **Security_Group**: Virtual firewall controlling inbound and outbound traffic for EC2 instances
- **Static_Website_Hosting**: S3 feature enabling direct HTTP access to bucket objects
- **Versioning**: S3 feature that preserves multiple variants of objects
- **Terraform**: Infrastructure as Code (IaC) tool for provisioning and managing cloud resources declaratively
- **Terraform_State**: File that tracks the current state of managed infrastructure resources

## Requirements

### Requirement 1: Terraform Infrastructure Provisioning

**User Story:** As a DevOps engineer, I want to use Terraform to provision all AWS infrastructure declaratively, so that I can manage infrastructure as code with version control and reproducibility.

#### Acceptance Criteria

1. THE Terraform SHALL define AWS provider configuration with region specification
2. THE Terraform SHALL provision S3 bucket resource with versioning enabled
3. THE Terraform SHALL provision EC2 instance resource with t2.micro instance type
4. THE Terraform SHALL provision Security_Group resource with HTTP (port 80) and SSH (port 22) ingress rules
5. WHEN terraform apply is executed, THE Terraform SHALL create all defined resources in AWS
6. THE Terraform SHALL output the S3 bucket website endpoint URL
7. THE Terraform SHALL output the EC2 instance public IP address
8. WHEN terraform destroy is executed, THE Terraform SHALL remove all provisioned resources

### Requirement 2: AWS S3 Bucket Configuration via Terraform

**User Story:** As a DevOps engineer, I want to configure an S3 bucket with versioning and static website hosting using Terraform, so that I can host static web content with version control capabilities.

#### Acceptance Criteria

1. THE Terraform SHALL create an S3 bucket with a unique name
2. THE Terraform SHALL enable versioning on the S3 bucket
3. THE Terraform SHALL configure Static_Website_Hosting with index.html as the index document
4. THE Terraform SHALL attach a Bucket_Policy allowing public read access to all objects
5. THE Terraform SHALL disable block public access settings to allow public website hosting
6. WHEN an object is uploaded, THE S3_Service SHALL make it accessible via the bucket website endpoint

### Requirement 3: S3 Static Content Upload and Verification

**User Story:** As a DevOps engineer, I want to upload HTML content to the S3 bucket and verify public accessibility, so that I can confirm the static website hosting is functioning correctly.

#### Acceptance Criteria

1. THE S3_Service SHALL accept an index.html file containing "Hello from S3" content
2. WHEN index.html is uploaded, THE S3_Service SHALL store it as the default index document
3. WHEN the bucket website endpoint is accessed, THE S3_Service SHALL return the index.html content with HTTP 200 status
4. THE S3_Service SHALL provide a publicly accessible URL in the format http://{bucket-name}.s3-website-{region}.amazonaws.com

### Requirement 4: Docker Flask Application Development

**User Story:** As a DevOps engineer, I want to create a Flask application that returns a greeting message, so that I can containerize and deploy a functional web application.

#### Acceptance Criteria

1. THE Flask_Application SHALL define a root route ("/") that returns "Hello from Docker"
2. THE Flask_Application SHALL run on port 5000 by default
3. WHEN the root endpoint is accessed, THE Flask_Application SHALL return HTTP 200 status with the greeting message
4. THE Flask_Application SHALL include proper Flask initialization and app.run() configuration

### Requirement 5: Docker Image Build Configuration

**User Story:** As a DevOps engineer, I want to create a Dockerfile that packages the Flask application, so that I can build a portable container image.

#### Acceptance Criteria

1. THE Dockerfile SHALL use python:3.9-slim as the base image
2. THE Dockerfile SHALL set /app as the working directory
3. THE Dockerfile SHALL copy requirements.txt and install dependencies using pip
4. THE Dockerfile SHALL copy the Flask application code into the container
5. THE Dockerfile SHALL expose port 5000
6. THE Dockerfile SHALL define CMD to run the Flask application
7. WHEN the Dockerfile is built, THE Docker_Engine SHALL create a runnable image with all dependencies installed

### Requirement 6: Docker Image Registry Deployment

**User Story:** As a DevOps engineer, I want to push the Docker image to Docker Hub, so that it can be accessed and deployed from any environment.

#### Acceptance Criteria

1. THE Docker_Engine SHALL tag the built image with the format {dockerhub-username}/{image-name}:{tag}
2. WHEN docker push is executed, THE Docker_Hub SHALL accept and store the image
3. THE Docker_Hub SHALL make the image publicly accessible via the repository URL
4. WHEN the image is pushed successfully, THE Docker_Hub SHALL display the image with its tags in the web interface

### Requirement 7: AWS EC2 Instance Provisioning via Terraform

**User Story:** As a DevOps engineer, I want to provision an EC2 instance with proper network configuration using Terraform, so that I can deploy a web server accessible from the internet.

#### Acceptance Criteria

1. THE Terraform SHALL provision a t2.micro EC2 instance with Amazon Linux 2 or Ubuntu 22.04 AMI
2. THE Terraform SHALL create a Security_Group allowing inbound traffic on port 80 (HTTP) from 0.0.0.0/0
3. THE Terraform SHALL configure the Security_Group to allow inbound traffic on port 22 (SSH) from 0.0.0.0/0
4. THE Terraform SHALL associate the Security_Group with the EC2 instance
5. THE Terraform SHALL configure the EC2 instance to use a specified key pair for SSH access
6. WHEN the instance is launched, THE EC2_Service SHALL assign a public IP address
7. THE Terraform SHALL use user_data script to automatically install and configure Nginx on instance launch

### Requirement 8: Nginx Web Server Installation and Configuration

**User Story:** As a DevOps engineer, I want to install and configure Nginx on the EC2 instance, so that I can serve web content over HTTP.

#### Acceptance Criteria

1. WHEN Nginx is installed, THE EC2_Service SHALL have the nginx package available via the system package manager
2. THE Nginx_Server SHALL start successfully and run as a system service
3. THE Nginx_Server SHALL listen on port 80 for HTTP requests
4. WHEN the Nginx service is started, THE EC2_Service SHALL enable it to start automatically on boot
5. WHEN the public IP is accessed via HTTP, THE Nginx_Server SHALL return HTTP 200 status

### Requirement 9: Nginx Custom Content Deployment

**User Story:** As a DevOps engineer, I want to modify the default Nginx page to display custom content, so that I can verify the web server is serving my content correctly.

#### Acceptance Criteria

1. THE Nginx_Server SHALL serve content from /usr/share/nginx/html/index.html (Amazon Linux) or /var/www/html/index.html (Ubuntu)
2. WHEN the default index.html is modified, THE Nginx_Server SHALL display "Hello from EC2 Nginx" content
3. WHEN the EC2 public IP is accessed in a browser, THE Nginx_Server SHALL return the custom content
4. THE Nginx_Server SHALL serve the content without requiring authentication

### Requirement 10: Documentation and Evidence Collection

**User Story:** As a DevOps engineer, I want to document all implementation steps and collect evidence, so that I can demonstrate successful completion of all tasks.

#### Acceptance Criteria

1. THE documentation SHALL include the S3 bucket website URL
2. THE documentation SHALL include a screenshot showing the S3 static website content
3. THE documentation SHALL include the Docker Hub repository link
4. THE documentation SHALL include a screenshot showing the Docker image in Docker Hub
5. THE documentation SHALL include the EC2 instance public IP address
6. THE documentation SHALL include a screenshot showing the Nginx custom content via the public IP
7. THE documentation SHALL include step-by-step instructions for each task
8. THE documentation SHALL include any troubleshooting steps or issues encountered

### Requirement 11: AWS Credentials and Authentication

**User Story:** As a DevOps engineer, I want to configure AWS credentials securely, so that I can authenticate and interact with AWS services programmatically.

#### Acceptance Criteria

1. WHEN AWS credentials are required, THE implementation SHALL prompt the user to provide AWS Access Key ID and Secret Access Key
2. THE implementation SHALL support AWS CLI configuration via aws configure command
3. WHERE AWS CLI is used, THE implementation SHALL authenticate using credentials from ~/.aws/credentials
4. THE implementation SHALL validate credentials before attempting AWS operations
5. IF credentials are invalid, THEN THE implementation SHALL return a descriptive authentication error

### Requirement 12: Docker Hub Authentication

**User Story:** As a DevOps engineer, I want to authenticate with Docker Hub, so that I can push images to my Docker Hub repository.

#### Acceptance Criteria

1. WHEN docker push is executed, THE Docker_Engine SHALL require Docker Hub authentication
2. THE implementation SHALL support docker login command for authentication
3. WHEN docker login is executed, THE Docker_Engine SHALL prompt for Docker Hub username and password
4. IF authentication succeeds, THEN THE Docker_Engine SHALL store credentials securely
5. IF authentication fails, THEN THE Docker_Engine SHALL return an authentication error

### Requirement 13: Resource Cleanup and Cost Management

**User Story:** As a DevOps engineer, I want to understand resource cleanup procedures using Terraform, so that I can avoid unnecessary AWS charges.

#### Acceptance Criteria

1. THE documentation SHALL include instructions for running terraform destroy to remove all resources
2. THE documentation SHALL include instructions for deleting the S3 bucket contents before destruction
3. THE documentation SHALL warn about potential costs for running resources
4. THE documentation SHALL specify that t2.micro instances are eligible for AWS Free Tier
5. THE documentation SHALL recommend running terraform destroy after assignment completion
6. THE Terraform_State SHALL track all provisioned resources for proper cleanup

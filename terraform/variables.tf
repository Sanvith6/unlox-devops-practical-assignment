variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be a valid region format (e.g., us-east-1, eu-west-2)."
  }
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket (must be DNS-compliant: lowercase, numbers, hyphens only)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be 3-63 characters, start and end with lowercase letter or number, and contain only lowercase letters, numbers, and hyphens."
  }

  validation {
    condition     = !can(regex("\\.\\.|-\\.", var.bucket_name))
    error_message = "Bucket name cannot contain consecutive periods or period-hyphen combinations."
  }
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (Amazon Linux 2 or Ubuntu 22.04). Leave empty to auto-select latest Amazon Linux 2 AMI."
  type        = string
  default     = ""

  validation {
    condition     = var.ami_id == "" || can(regex("^ami-[a-f0-9]{8,17}$", var.ami_id))
    error_message = "AMI ID must be empty or in the format ami-xxxxxxxx (where x is a hexadecimal character)."
  }
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair for SSH access (optional). If not provided, SSH access will not be available."
  type        = string
  default     = null

  validation {
    condition     = var.key_pair_name == null || length(var.key_pair_name) > 0
    error_message = "Key pair name must be either null or a non-empty string."
  }
}

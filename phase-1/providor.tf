provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  s3_use_path_style           = true

  endpoints {
    ec2     = "http://localhost:4566"
    elb     = "http://localhost:4566"
    elbv2   = "http://localhost:4566"
    iam     = "http://localhost:4566"
    rds     = "http://localhost:4566"
    s3      = "http://localhost:4566"
    eks     = "http://localhost:4566"  # LocalStack's endpoint for EKS
    # Add other services if needed
  }
}
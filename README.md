# COBL-006 — AWS Logging & Auditability (Terraform)

This repository contains Terraform code to deploy AWS-native logging,
auditability, and retention controls aligned with AWS COBL-006 requirements.

## Services Deployed
- AWS CloudTrail
- Amazon S3 (log archive)
- S3 lifecycle rules
- Amazon CloudWatch Logs

## Infrastructure as Code
All resources are provisioned using Terraform following best practices.

## Notes
- AWS credentials are managed locally
- Terraform state files are excluded from version control
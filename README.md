This repository contains a Terraform project I have been experimenting with for deploying AWS infrastructure using **GitHub Actions** as the execution engine.

## Validation Endpoints

- `/`      – application landing page
- `/health` – ALB target group health check
- `/db`     – validates connectivity from app tier to RDS

Explanation
![Diagram of system flow](images/NetworkDiagram.png)

Explanantion
![Diagram of system flow](images/SecurityDiagram.png)


---

## Architecture Overview

This project provisions AWS infrastructure inside a dedicated **dev environment**, including:

* VPC and networking components
* Security groups
* Compute resources 
* User data scripts for instance bootstrapping

---

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── terraform.yml        # GitHub Actions workflow
├── AWS/
│   └── Terraform/
│       └── dev/
│           ├── backend.tf       # S3 remote state configuration
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           ├── user_data.sh     # EC2 bootstrap script
│           └── diagrams/
│               ├── network-architecture.png
│               └── security-groups.png
├── .gitignore
└── README.md
```

---

## Terraform State Management

This project uses **remote Terraform state** stored in **Amazon S3** with state locking enabled.

### Backend Configuration

The backend is defined in `backend.tf`:

## GitHub Actions Workflow

Terraform is executed entirely through **GitHub Actions** for applies.

---

## AWS Credentials

### GitHub Actions

GitHub Actions authenticates to AWS using repository secrets:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`

(For future hardening, this can be replaced with GitHub OIDC + IAM role assumption.)


## User Data Scripts

Instance bootstrapping is handled via a `user_data.sh` script stored alongside the Terraform files.

It is referenced using:

```hcl
user_data = templatefile("${path.module}/user_data.sh", {})
```

This approach ensures:

* Correct path resolution in GitHub Actions and locally
* No hard-coded absolute paths

---

## AWS Multitier Automation
- Automated deployment of a multi-tier AWS environment using Terraform and GitHub Actions, focused on Infrastructure as Code, CI/CD-driven provisioning, and AWS networking and security fundamentals.
- This project taught me alot about managing resources with Terraform, how Terraform handles different resource dependency problems, how GitHub Actions runners can be utilized in creative ways, as well as cemented alot of AWS best practices I learned from my SAA studies.
## Program flow
- The infrastructure is fully automated with Terraform, the ASG is provisioned with a user_data script, and the CI/CD is handled by GitHub Actions.
- When the workflow is ran the infrastructure is provisioned, the tf state is saved to an s3 bucket allowing me to destroy or modify resources from different hosts (I learned I needed this the hard way).
- When the ASG is fully provisioned, the user_data script is ran and stands up an endpoint for `/` (verify connectivity),  `/health` (for ALB health checks), and `/db` to verify connectivity to the RDS postreSQL db.

## The application used is just to prove the underlying infrastructure, networking and security, this is verified by the validation endpoints. 
## Validation Endpoints

- `/`      – application landing page
- `/health` – ALB target group health check
- `/db`     – validates connectivity from app tier to RDS

## Architecture

## Network Architecture
- VPC-based network with segmented resources
- Public and private access boundaries
- Designed to support multi-tier application patterns
![Diagram of system flow](images/NetworkDiagram.png)

## Security Architecture
- Explicit inbound and outbound traffic rules
- Separation of access responsibilities
- Least-privilege networking enforced through design
![Diagram of system flow](images/SecurityDiagram.png)

---

## Terraform State Management

This project uses **remote Terraform state** stored in **Amazon S3** with state locking enabled.

### Backend Configuration

The backend is defined in `backend.tf`:

## GitHub Actions Workflow

Terraform is executed entirely through **GitHub Actions** for applies.

---

### GitHub Actions

GitHub Actions authenticates to AWS using repository secrets:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_REGION`

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

- I learned alot about automation, IaC concepts and building proper systems with the project. I have been having lots of fun using the stack of Terraform + AWS + GHA and I believe there is alot you can do with these techologies.
- It was relatively easy to troubleshoot problems using Terraform and GHA docs which is something I really appreciate as I have done my fair share of trying to use bad/outdated docs to troublshoot issues.
- I think I will be focusing on my Linux skills next as i think that would tie all of these technologies together nicely and allow me to build more creative solutions. 

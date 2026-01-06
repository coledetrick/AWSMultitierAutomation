# AWSMultitierAutomation
Automated provisioning of a core multitier aws infrastructure.
TODO
- add variables file and modularity
- grab db secrets from vault
- add https, no redirect but 'hello from HTTPS', add domain name.
- add terraform CICD
  
- Architectural diagram
- Lessons learned, choices made.
- Blog post of running the program, link it here.

## Validation Endpoints

- `/`      – application landing page
- `/health` – ALB target group health check
- `/db`     – validates connectivity from app tier to RDS

These endpoints are used to validate network, security group, and routing correctness.

.
├── .github/
│   └── workflows/
│       └── terraform.yml
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── user_data.sh
└── README.md

CI/CD Pipeline with Terraform, Jenkins, and Docker
This project demonstrates the setup of a complete CI/CD pipeline for deploying a containerized application using:

 - Jenkins for automating the pipeline stages (init, plan, apply).

 - Terraform for provisioning infrastructure (e.g., AWS EC2 instance).

 - Docker for packaging and running the application on the provisioned infrastructure.


The key focus is on infrastructure as code (IaC) and automation with idempotent playbooks and repeatable deployment processes.

 
## Features:

- Automated infrastructure provisioning via Terraform

- Jenkinsfile with 3-step pipeline: init, plan, apply

- Example EC2 instance deployment

- Docker installation and container execution automated (next stages)

- Cloud resource teardown with terraform destroy to manage cost

## Includes:

 main.tf – Terraform configuration file

 Jenkinsfile – Jenkins pipeline script

Instructions.md - contain a description for the instruction 

rapport.pdf - contains screenshots and explaination step by step  for education purpose


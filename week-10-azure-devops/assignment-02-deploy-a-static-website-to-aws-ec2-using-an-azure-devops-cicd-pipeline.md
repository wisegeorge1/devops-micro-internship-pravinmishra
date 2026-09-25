# Assignment 2 — Deploy A Static Website to AWS EC2 Using an Azure DevOps CI/CD Pipeline

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will import and personalize the Static Website, provision and configure an AWS EC2 instance using Terraform and Ansible, and create an Azure DevOps CI/CD pipeline that automatically deploys the website to Nginx through an SSH Service Connection.

---

# Task 0 — Verify the Existing Tooling and Self-Hosted Agent

## Goal

Confirm that Terraform, Ansible, AWS CLI, SSH, and the self-hosted Azure Pipelines agent are ready.

No submission screenshot is required for this task.

---

# Task 1 — Import and Personalize the Azure Static Website Repository

## Goal

Import the Azure Static Website into Azure Repos and add your Full Name to the website.

## Evidence

### Screenshot 1 — Azure Static Website in Azure Repos

Add a screenshot of Azure Repos showing:

* Imported Azure Static Website repository
* Project files
* `index.html`

![ass-2-ss1](/week-10-azure-devops/screenshots/ASS-02-SS-1.png)

---

# Task 2 — Provision and Configure the Target EC2 Instance

## Goal

Provision the AWS EC2 instance using Terraform and configure Nginx, SSH access, and deployment permissions using Ansible.

No additional submission screenshot is required for this task.

---

# Task 3 — Create the SSH Service Connection

## Goal

Create an Azure DevOps SSH Service Connection that can connect to the target EC2 instance using your selected SSH authentication method.

## Evidence

### Screenshot 2 — SSH Service Connection

Add a screenshot of the saved SSH Service Connection **Overview** page showing:

* Service Connection name
* SSH connection type

![ass-2-ss2](/week-10-azure-devops/screenshots/ASS-02-SS-2.png)

> Do not expose a password, SSH private key, passphrase, or another credential.

---

# Task 4 — Create the Azure DevOps YAML Pipeline

## Goal

Create an Azure DevOps YAML pipeline that deploys the Azure Static Website to the target EC2 instance after a commit is pushed.

## Evidence

### Screenshot 3 — Azure Pipelines YAML

Add a screenshot of `azure-pipelines.yml` open in the Azure Repos editor showing:

* Push trigger
* Selected self-hosted agent pool
* Pipeline variables
* Repository checkout step
* Pipeline information step
* `CopyFilesOverSSH@0` task
* `SSH@0` verification task

![ass-2-ss3](/week-10-azure-devops/screenshots/ASS-02-SS-3.png)

> Ensure that no password, SSH private key, PAT, or AWS credential is visible.

---

# Task 5 — Create, Authorize, and Run the Pipeline

## Goal

Run the Azure DevOps pipeline and confirm that the website files are transferred and verified successfully.

## Evidence

### Screenshot 4 — Successful Pipeline Run

Add a screenshot of the successful pipeline run and log summary showing:

* Overall pipeline status as **Succeeded**
* Pipeline information step completed
* File-copy step completed
* Remote-verification step completed
* Your Full Name visible in the pipeline output

![ass-2-ss4](/week-10-azure-devops/screenshots/ASS-02-SS-4a.png)
![ass-2-ss4](/week-10-azure-devops/screenshots/ASS-02-SS-4b.png)

---

# Task 6 — Verify the Website and Automatic Trigger

## Goal

Confirm that the website is accessible through the EC2 public IP address and that a new pushed commit automatically triggers another deployment.

## Evidence

### Screenshot 5 — Deployed Azure Static Website

Add a browser screenshot showing:

* Deployed Azure Static Website
* EC2 public IP address in the browser address bar
* Your Full Name
* Updated website content after the automatic deployment

![ass-2-ss5](/week-10-azure-devops/screenshots/ASS-02-SS-5a.png)
![ass-2-ss5](/week-10-azure-devops/screenshots/ASS-02-SS-5b.png)

## Final Website URL

`http://<target-vm-public-ip>`

Replace the placeholder with your actual website URL:

http://168.62.59.149/

---

# Assignment Summary

Write a short summary of the completed CI/CD workflow.

I completed an automated CI/CD workflow for deploying a static website to an Azure Virtual Machine using Terraform, Ansible, and Azure DevOps.

Terraform provisioned the Azure infrastructure, including the Ubuntu VM, virtual network, public IP, and Network Security Group.

Ansible configured the server by installing and enabling Nginx and preparing /var/www/html with the required deployment permissions.

Azure DevOps was configured with an SSH service connection and a YAML pipeline running on a self-hosted agent.

Every code push to the repository automatically triggers the pipeline, which transfers the website files to the Azure VM over SSH.

The pipeline then validates the deployment by checking that index.html exists and that Nginx returns an HTTP 200 response.

The completed workflow establishes a clear separation of responsibilities: Terraform provisions, Ansible configures, and Azure DevOps deploys and verifies. This provides a repeatable and automated process for delivering website changes to Azure.

---

# LinkedIn Requirement

## LinkedIn Post Screenshot

Add a screenshot of your LinkedIn post containing:

* What you automated
* How Terraform, Ansible, and Azure DevOps worked together
* Three to five lines describing the CI/CD workflow
* A screenshot of the successful pipeline or deployed website

![linkedin-post](/week-10-azure-devops/screenshots/ASS-02-SS-7.png)

## LinkedIn Post URL

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7509153875472318465-sH4U/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

> Do not expose AWS credentials, SSH private keys, passwords, PATs, or other sensitive information.

---

# Submission Instructions

* Include the short assignment summary.
* Include Screenshots 1–5.
* Include the final website URL.
* Include the LinkedIn post screenshot and URL.
* Confirm that the EC2 instance is running during grading.
* Do not expose a password, SSH private key, passphrase, PAT, AWS credential, account ID, or another secret.

---

# Completion Checklist

* The correct Azure Static Website repository was imported into Azure Repos
* `index.html` is visible in Azure Repos
* Your Full Name was added to the website
* The target EC2 instance was provisioned using Terraform
* A suitable Ubuntu image and EC2 size were selected
* Nginx was configured using Ansible
* SSH login works using the selected authentication method
* The SSH user can write to `/var/www/html`
* TCP ports 22 and 80 are configured correctly
* The self-hosted Azure Pipelines agent is online
* The SSH Service Connection was created successfully
* The YAML trigger includes all branches
* The YAML uses the correct self-hosted agent pool
* The copy and remote-verification tasks completed successfully
* The pipeline status is **Succeeded**
* A new pushed commit triggered the pipeline automatically
* The Azure Static Website loads through the EC2 public IP address
* Your Full Name is visible on the deployed website
* Screenshots 1–5 are included and readable
* The final website URL is included
* The LinkedIn post screenshot and URL are included
* No sensitive information is exposed

---

*This submission is part of the DevOps Micro Internship (DMI) — Agentic AI Track.*

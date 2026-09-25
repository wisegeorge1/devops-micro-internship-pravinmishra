# Assignment 3 — Automate React App Deployment Using Azure DevOps CI/CD

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will create a multi-stage Azure DevOps pipeline that builds, tests, publishes, and deploys a React application to an Ubuntu VM hosted on AWS or Azure. The pipeline will automatically run when changes are committed to `main`, transfer the production build as an artifact, and deploy it through Nginx.

---

# Task 0 — Verify the Starting Environment

## Goal

Confirm that Azure DevOps, the pipeline agent, Terraform, Ansible, and the selected cloud environment are ready.

No submission screenshot is required for this task.

---

# Task 1 — Import and Personalize the React Application

## Goal

Import the React application into Azure Repos and add your Full Name and the current date.

## Evidence

### Screenshot 1 — Imported React Project in Azure Repos

Add a screenshot of Azure Repos showing:

* Imported React project
* Repository name
* `main` branch
* Project files

![ass3-ss1](/week-10-azure-devops/screenshots/ASS-03-SS-1.png)

---

# Task 2 — Provision and Configure the Target VM

## Goal

Provision an Ubuntu VM using Terraform and configure Nginx, React SPA routing, SSH access, and deployment permissions using Ansible.

No separate submission screenshot is required for this task.

---

# Task 3 — Create or Update the SSH Service Connection

## Goal

Create or update an Azure DevOps SSH Service Connection that allows the pipeline to connect securely to the target VM.

No separate submission screenshot is required for this task.

> Do not include the VM password, SSH private key, token, or another secret in the submission.

---

# Task 4 — Author the Multi-Stage Azure Pipeline

## Goal

Create an Azure Pipeline containing Build, Test, Publish, and Deploy stages with an automatic trigger for commits to `main`.

## Evidence

### Screenshot 2 — Multi-Stage Pipeline YAML

Add a screenshot of the Azure Pipeline YAML open in the editor showing:

* Trigger
* Build stage
* Test stage
* Publish stage
* Deploy stage

![ass3-ss2](/week-10-azure-devops/screenshots/ASS-03-SS-2.png)

> Do not expose passwords, private keys, tokens, or cloud credentials.

---

# Task 5 — Run the Pipeline and Resolve Configuration Issues

## Goal

Complete a successful end-to-end pipeline run containing all four stages.

## Evidence

### Screenshot 3 — Successful Multi-Stage Pipeline Run

Add a screenshot of one Azure DevOps pipeline run showing all four stages succeeded:

* Build
* Test
* Publish
* Deploy

![ass3-ss3](/week-10-azure-devops/screenshots/ASS-03-SS-3.png)

---

# Task 6 — Verify the Deployment on the VM

## Goal

Confirm that the pipeline deployed the production-ready React files to the correct Nginx web root.

## Evidence

### Screenshot 4 — Post-Deployment Contents of /var/www/html

Add a screenshot of the pipeline SSH verification log or VM terminal showing the post-deployment contents of:

`/var/www/html`

![ass3-ss4](/week-10-azure-devops/screenshots/ASS-03-SS-4.png)

---

# Task 7 — Verify the Website and Automatic Trigger

## Goal

Confirm that the React application is accessible and that a commit to `main` automatically triggers the CI/CD pipeline.

## Evidence

### Screenshot 5 — Deployed React Application

Add a browser screenshot showing:

* Deployed React application
* VM public IP address in the browser address bar
* Your Full Name
* Deployment date

![ass3-ss5](/week-10-azure-devops/screenshots/ASS-03-SS-5.png)
![ass3-ss6](/week-10-azure-devops/screenshots/ASS-03-SS-6.png)

## Final Application URL

`http://<vm-public-ip>`

Replace the placeholder and paste your final application URL below:

http://20.124.130.112/

---

# CI/CD Workflow Summary

Write a short explanation of the CI/CD workflow you created.

The CI/CD workflow automates the process of building, testing, and deploying the React application to an Azure-hosted Ubuntu VM. Whenever a change is committed to the main branch, Azure DevOps automatically triggers the multi-stage pipeline.

The pipeline consists of four stages: Build, Test, Publish, and Deploy. The Build stage installs the required Node.js version, installs the project dependencies, and creates the production React build. The Test stage runs the application's tests in CI mode to ensure the code is working correctly. The Publish stage downloads and verifies the build artifact before publishing it as the deployment artifact. Finally, the Deploy stage uses the Azure DevOps SSH Service Connection and CopyFilesOverSSH@0 to transfer the production files to /var/www/html on the Ubuntu VM.

Terraform is used to provision the Azure infrastructure, while Ansible installs and configures Nginx and prepares the web-root permissions. Nginx then serves the compiled React application and handles SPA routes using try_files. This workflow provides a repeatable deployment process where only successfully built and tested application artifacts are deployed to the web server.

---

# LinkedIn Requirement

## Evidence

### Screenshot 6 — LinkedIn Post

![linkedin-post](/week-10-azure-devops/screenshots/ASS-03-SS-7.png)

* Post text
* At least one image or link

Add your screenshot here.

## LinkedIn Post URL

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7509291953398820864-ZCn2/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

> Do not expose VM passwords, tokens, private keys, cloud credentials, or other sensitive information.

---

# Submission Instructions

* Complete all tasks in sequence.
* Include the short CI/CD workflow summary.
* Include Screenshots 1–6.
* Include the final application URL.
* Include the public LinkedIn post URL.
* Confirm that all screenshots are readable and show the required context.
* Do not expose passwords, PATs, private keys, cloud credentials, subscription IDs, account IDs, or other secrets.
* Follow the Assignment Submission Guidelines.

---

# Completion Checklist

* [ ] All tasks were completed in sequence
* [ ] The correct React repository was imported into Azure Repos
* [ ] Your Full Name and date were added to the application
* [ ] The pipeline YAML was authored and committed to the repository
* [ ] Commits to `main` trigger the pipeline automatically
* [ ] The pipeline contains Build, Test, Publish, and Deploy stages
* [ ] All four stages succeeded in the same pipeline run
* [ ] The production build moved between stages as a pipeline artifact
* [ ] The Deploy stage used the SSH Service Connection
* [ ] No password or secret is stored in the YAML
* [ ] `index.html` is directly inside `/var/www/html`
* [ ] Raw React source code was not deployed to the Nginx web root
* [ ] `node_modules/` was not deployed to the Nginx web root
* [ ] Nginx is active
* [ ] The application opens through the VM public IP address
* [ ] Your Full Name and date are visible in the browser screenshot
* [ ] Screenshots 1–6 are included and readable
* [ ] No password, token, private key, account ID, or other secret is visible
* [ ] The final application URL is included
* [ ] The LinkedIn post is published
* [ ] The LinkedIn post URL is included

---

*This submission is part of the DevOps Micro Internship (DMI) — Agentic AI Track.*

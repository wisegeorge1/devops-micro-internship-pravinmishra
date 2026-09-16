# Assignment 4 — Deploy Mini Finance Project Using Terraform and Ansible

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will provision an Azure VM with Terraform and use Ansible to automate the install, deploy, and verify workflow for the Mini Finance static website — a clean separation between infrastructure and configuration management.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `mini-finance` project with separate `terraform/` and `ansible/` subdirectories.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `mini-finance` project tree

![minifinance-project](/week-09-ansible/screenshots/ASS-4-SS-1.png)

---

# Task 2 — Terraform — Azure VM + NSG (Ports 22/80)

## Goal

Provision an Ubuntu 22.04 Standard_B1s VM with a public IP, SSH key authentication, and an NSG allowing SSH (22) and HTTP (80), and output the public IP.

### Evidence

#### Screenshot 2 — Terminal showing the end of a successful `terraform apply`

![terraformapply-successful](/week-09-ansible/screenshots/ASS-4-SS-2.png)

---

#### Screenshot 3 — Terminal showing `terraform output public_ip`

![public-ip-output](/week-09-ansible/screenshots/ASS-4-SS-3.png)

---

#### Screenshot 4 — Terraform code or Azure Portal showing NSG inbound rules for ports 22 and 80

![nsg-inbound-rules](/week-09-ansible/screenshots/ASS-4-SS-4.png)

---

# Task 3 — Configure Passwordless SSH

## Goal

Connect to the VM with SSH using the injected key and run `hostname` remotely without a password prompt.

### Evidence

#### Screenshot 5 — Terminal showing the successful passwordless SSH hostname check

![passwordless-SSH](/week-09-ansible/screenshots/ASS-4-SS-5.png)

---

# Task 4 — Ansible — Multi-Play: Install → Deploy → Verify

## Goal

Create `ansible/inventory.ini` and a three-play `site.yml` that installs Nginx and Git, clones and deploys the Mini Finance repository to `/var/www/html/` with a reload handler, and verifies HTTP 200 from `localhost`.

### Evidence

#### Screenshot 6 — Editor showing `inventory.ini` and the three plays in `site.yml`

![site-inventory](/week-09-ansible/screenshots/ASS-4-SS-6.png)

---

#### Screenshot 7 — Terminal showing `ansible-playbook -i inventory.ini site.yml` with HTTP 200, assertion OK, and no failures

![checks](/week-09-ansible/screenshots/ASS-4-SS-7a.png)
![checks](/week-09-ansible/screenshots/ASS-4-SS-7b.png)

---

# Task 5 — Test End-to-End Functionality

## Goal

Confirm the Mini Finance site is publicly accessible and correctly served by Nginx.

### Evidence

#### Screenshot 8 — Browser showing the Mini Finance site loaded from `http://<public_ip>` with the URL visible

![browser-showing](/week-09-ansible/screenshots/ASS-4-SS-8.png)

---

### Notes

Describe an issue you faced and how you fixed it, and what you learned.

I initially encountered an Ansible verification error because I treated the registered variable as though it contained a single URI result. Since the URI task used a loop, Ansible stored the individual responses inside `website_checks.results`. I fixed the issue by looping over `website_checks.results` and checking `item.status == 200`. I also learned that `status_code` specifies the expected HTTP response for the URI module, while `status` contains the response returned by the server.

I learned how Terraform and Ansible can work together while maintaining separate responsibilities. Terraform provisions the Azure infrastructure, while Ansible configures the VM and deploys the application. I also learned how Ansible loops, registered variables, handlers, `synchronize`, `uri`, and `assert` can be combined to create a repeatable deployment workflow.
---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the Terraform + Ansible deployment, mentioning the Azure VM, secure networking, passwordless SSH, Nginx deployment, and HTTP verification, with one challenge you faced and how you fixed it, and one real-world example of this workflow.

## Evidence

#### LinkedIn Post URL



<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-activity-7504829205751435264-zatF?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

#### Screenshot — Published LinkedIn post showing the text and at least one image or proof

![linkedin-post](/week-09-ansible/screenshots/ASS-4-SS-9.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- The `mini-finance` project tree and `inventory.ini` may have the final IP octet masked
- Do not expose private keys or other secrets

---

# Completion Checklist

- [ ] Task 1: `mini-finance` project structure created (Screenshot 1)
- [ ] Task 2: Azure VM and NSG provisioned with Terraform (Screenshots 2–4)
- [ ] Task 3: Passwordless SSH verified (Screenshot 5)
- [ ] Task 4: Ansible install/deploy/verify plays run successfully (Screenshots 6–7)
- [ ] Task 5: Site verified in the browser (Screenshot 8)
- [ ] Reflection notes written (Notes)
- [ ] LinkedIn post published and URL submitted
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*

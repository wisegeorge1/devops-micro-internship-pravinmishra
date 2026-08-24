# Assignment 5 — Deploy EpicBook Web App on Azure VM with Azure Database for MySQL

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook web application on Azure using an Ubuntu Virtual Machine to host the frontend and backend, and Azure Database for MySQL Flexible Server (private access) to store user and product data. You will build the network, provision the resources, deploy the application, and prove that the complete user flow works through the VM's public IP.

---

# Task 1 — Create Network Infrastructure

## Goal

Create a VNet (10.0.0.0/16) with a public subnet (10.0.1.0/24) for the VM and a private subnet (10.0.2.0/24) for MySQL, with NSGs allowing HTTP (80)/SSH (22) publicly and MySQL (3306) only from the VM subnet, plus a Public IP and Network Interface for the VM.

### Evidence

#### Screenshot 1 — Virtual Network overview showing the 10.0.0.0/16 address space and both subnets

![vnet](/week-07-azure-cloud/screenshots/assignment-5-SS-1.png)

---

#### Screenshot 2 — Public and private NSG inbound rules showing ports 80, 22, and restricted 3306 access

![public-private-nsg](/week-07-azure-cloud/screenshots/assignment-5-SS-2.png)
![public-private-nsg](/week-07-azure-cloud/screenshots/assignment-5-SS-2b.png)

---

#### Screenshot 3 — Public IP and Network Interface association for the Virtual Machine

![ip-nic-association](/week-07-azure-cloud/screenshots/assignment-5-SS-3.png)

---

# Task 2 — Provision Azure Virtual Machine

## Goal

Launch an Ubuntu 22.04 LTS VM (Standard B1s or equivalent) in the public subnet, and install Node.js, npm, Nginx, Git, and MySQL Client.

### Evidence

#### Screenshot 4 — Virtual Machine overview showing Ubuntu, size, public IP, and subnet

![vm-overview](/week-07-azure-cloud/screenshots/assignment-5-SS-4.png)

---

#### Screenshot 5 — Terminal showing successful software installation or installed-version checks

![software-versions](/week-07-azure-cloud/screenshots/assignment-5-SS-5.png)

---

# Task 3 — Deploy the EpicBook Application

## Goal

Clone the EpicBook repository, install dependencies, build the frontend, configure Nginx to serve it, and configure the Node.js/Express.js backend to connect to MySQL using environment variables.

### Evidence

#### Screenshot 6 — Terminal showing the EpicBook repository cloned and dependencies installed

![epicbook-repo](/week-07-azure-cloud/screenshots/assignment-5-SS-6.png)

---

#### Screenshot 7 — Nginx configuration or service status proving the frontend is configured to be served

![nginx-config](/week-07-azure-cloud/screenshots/assignment-5-SS-7.png)

---

#### Screenshot 8 — Backend process or listening-port evidence (without exposing environment-variable secrets)

![backend-listening-port](/week-07-azure-cloud/screenshots/assignment-5-SS-8.png)

---

# Task 4 — Setup Azure Database for MySQL

## Goal

Create a private Azure Database for MySQL Flexible Server (VNet Integration) in the private subnet, create the database user and schema, import the SQL dump, and restrict access to the VM subnet only.

### Evidence

#### Screenshot 9 — MySQL Flexible Server overview showing Private access (VNet Integration)

![mysql-server](/week-07-azure-cloud/screenshots/assignment-5-SS-9.png)

---

#### Screenshot 10 — Networking configuration showing the private subnet and restricted access

![restricted-network](/week-07-azure-cloud/screenshots/assignment-2-SS-10.png)

---

#### Screenshot 11 — MySQL Client output showing the EpicBook database or imported tables (no password visible)

![epicbook-database](/week-07-azure-cloud/screenshots/assignment-5-SS-11.png)

---

# Task 5 — Test End-to-End Functionality

## Goal

Confirm the EpicBook application loads through the VM's public IP and that viewing products, adding items to the cart, and placing orders all work.

### Evidence

#### Screenshot 12 — Browser showing the EpicBook application with the Virtual Machine public IP visible

![epicbook-app](/week-07-azure-cloud/screenshots/assignment-5-SS-12.png)

---

#### Screenshot 13 — Proof of a successful database-backed action (viewing products, adding to cart, or placing an order)

![proof-successful-action](/week-07-azure-cloud/screenshots/assignment-5-SS-13.png)

---

#### Public IP URL

Paste the public IP URL of your Virtual Machine here:

<http://20.235.31.232/>

---

# Submission Instructions

- Add all required screenshots in your submission
- Include the Virtual Machine public IP URL
- Do not expose database passwords, connection strings, or subscription IDs

---

# Completion Checklist

- [ ] Task 1: Network foundation created with public/private subnets and NSGs (Screenshots 1–3)
- [ ] Task 2: VM provisioned and required software installed (Screenshots 4–5)
- [ ] Task 3: EpicBook frontend and backend deployed (Screenshots 6–8)
- [ ] Task 4: Private Azure Database for MySQL created and data imported (Screenshots 9–11)
- [ ] Task 5: End-to-end functionality validated (Screenshots 12–13, Public IP URL)
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

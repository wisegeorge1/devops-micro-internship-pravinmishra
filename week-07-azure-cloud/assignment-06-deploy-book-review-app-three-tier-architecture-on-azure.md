# Assignment 6 — Capstone: Deploy Book Review App (Three-Tier Architecture) on Azure

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the course. You will deploy the Book Review App in a production-ready, best-practice-compliant three-tier architecture on Azure: separated presentation, application, and database tiers, least-privilege network access, a controlled public entry point, protected secrets, and availability/monitoring evidence.

---

# Task 1 — Design the Azure Three-Tier Architecture

## Goal

Create an architecture diagram and implementation plan identifying the presentation, application, and database components, the chosen Azure services, the public entry point, and the internal traffic paths.

### Evidence

#### Screenshot 1 — Architecture diagram showing the public entry point, three tiers, network boundaries, and traffic flow

![architecture-diagram](/week-07-azure-cloud/screenshots/assignment-6-SS-1.jpg)

---

#### Screenshot 2 — Written architecture assumptions and selected Azure services

![architecture](/week-07-azure-cloud/screenshots/assignment-6-SS-2.png)

---

# Task 2 — Create the Azure Network Foundation

## Goal

Create a dedicated Resource Group and VNet with separate subnets for the web, application, and database tiers, keeping the application and database tiers without direct public access.

### Evidence

#### Screenshot 3 — Resource Group overview showing the assignment resources

![rg-overview](/week-07-azure-cloud/screenshots/assignment-6-SS-3.png)

---

#### Screenshot 4 — VNet overview showing the address space and all required subnets

![vnet-overview](/week-07-azure-cloud/screenshots/assignment-6-SS-4.png)

---

#### Screenshot 5 — Route-table or Private DNS evidence where applicable

![private-dns](/week-07-azure-cloud/screenshots/assignment-6-SS-5.png)

---

# Task 3 — Configure Security and Secret Management

## Goal

Apply least-privilege NSG rules so traffic flows Internet → public entry point → web tier → application tier → database tier, and store credentials in Azure Key Vault or another approved secure mechanism.

### Evidence

#### Screenshot 6 — NSG rules proving least-privilege access between the tiers

![nsg-rules](/week-07-azure-cloud/screenshots/assignment-6-SS-6.png)

---

#### Screenshot 7 — Key Vault or approved secret-management configuration (without displaying secret values)

![key-vault-secrets](/week-07-azure-cloud/screenshots/assignment-6-SS-7.png)

---

# Task 4 — Deploy the Presentation (Web) Tier

## Goal

Deploy the Book Review App presentation layer on the approved web-tier compute service, configured to route requests to the internal application-tier endpoint, and not directly exposed except through the public entry service.

### Evidence

#### Screenshot 8 — Web-tier compute overview showing subnet and availability configuration

![web-tier-compute](/week-07-azure-cloud/screenshots/assignment-6-SS-8.png)

---

#### Screenshot 9 — Terminal or service output proving the presentation layer is running

![presentation-layer](/week-07-azure-cloud/screenshots/assignment-6-SS-9.png)

---

# Task 5 — Deploy the Business (Application) Tier

## Goal

Deploy the Book Review App backend privately in the application subnet, configured to use the private database endpoint and secured environment values, reachable only through its internal endpoint.

### Evidence

#### Screenshot 10 — Application-tier compute overview showing private subnet placement

![app-tier-overview](/week-07-azure-cloud/screenshots/assignment-6-SS-9.png)

---

#### Screenshot 11 — Backend process, service, or listening-port evidence

![backend-process](/week-07-azure-cloud/screenshots/assignment-6-SS-11.png)

---

#### Screenshot 12 — Internal health-check or API response (without exposing secrets)

![internal-health-check](/week-07-azure-cloud/screenshots/assignment-6-SS-12.png)

---

# Task 6 — Deploy the Managed Database Tier

## Goal

Create a private Azure managed database (public access disabled), with availability/backup/retention settings, the Book Review App schema imported, and access restricted to the application tier only.

### Evidence

#### Screenshot 13 — Database overview showing private connectivity and public access disabled

![dbase-overview](/week-07-azure-cloud/screenshots/assignment-6-SS-13.png)

---

#### Screenshot 14 — Availability, backup, and retention configuration

![availability](/week-07-azure-cloud/screenshots/assignment-6-SS-14.png)

---

#### Screenshot 15 — Successful schema or connectivity verification (without exposing credentials)

![schema-connectivity](/week-07-azure-cloud/screenshots/assignment-6-SS-15.png)

---

# Task 7 — Configure Traffic Management, Availability, and Monitoring

## Goal

Configure the approved public entry service with health probes and backend pools, internal routing for the application tier where required, and enable Azure Monitor/diagnostics/logs/alerts for the key resources.

### Evidence

#### Screenshot 16 — Public entry service showing listener, frontend endpoint, and healthy web targets

![frontend-endpoint](/week-07-azure-cloud/screenshots/assignment-6-SS-16.png)

---

#### Screenshot 17 — Internal application-tier load-balancing or routing configuration where applicable

![internal-lb](/week-07-azure-cloud/screenshots/assignment-6-SS-17.png)

---

#### Screenshot 18 — Azure Monitor, diagnostic settings, logs, metrics, or alert evidence

![metrics](/week-07-azure-cloud/screenshots/assignment-6-SS-18.png)

---

# Task 8 — Validate the Production-Style Deployment

## Goal

Confirm the Book Review App works end to end through the public endpoint, with at least one database read and one write, confirm private tiers are not internet-reachable, and complete a safe availability test.

### Evidence

#### Screenshot 19 — Browser showing the Book Review App through the public endpoint

![bookreview-app-endpoint](/week-07-azure-cloud/screenshots/assignment-6-SS-19.png)

---

#### Screenshot 20 — Proof of successful database-backed read and write operations

![read-write-proof](/week-07-azure-cloud/screenshots/assignment-6-SS-20.jpg)

---

#### Screenshot 21 — Evidence that private tiers are not publicly accessible

![private-tiers](/week-07-azure-cloud/screenshots/assignment-6-SS-21.png)

---

#### Screenshot 22 — Availability-test and healthy-target evidence

![availability-test](/week-07-azure-cloud/screenshots/assignment-6-SS-22.png)

---

#### Public Endpoint

Paste your public endpoint URL here:

<http://48.194.78.237>

---

### Notes

Summarize what worked, issues encountered and how they were fixed, and the availability/security/secrets/monitoring/backup choices made.

# Summary of Deployment
The deployment successfully implemented a production ready, highly available three tier architecture for the Book Review App on Microsoft Azure. By strictly separating the presentation, application, and data layers into distinct subnets with least-privilege Network Security Group (NSG) rules, I achieved a secure environment where the backend and database tiers are entirely isolated from direct public internet access. Operational readiness was established through centralized monitoring and logging, while security was prioritized by utilizing Azure Key Vault for all application secrets.

## Availability, Security, Secrets, Monitoring, and Backup Choices

### Availability
Availability Zones & VMSS: Web and Application tiers were deployed across Virtual Machine Scale Sets (VMSS) spanning multiple Availability Zones. Azure Application Gateway  provides zone-redundant public entry and global load balancing.

### Security
Network Segmentation & TLS: Strict network isolation using separate subnets for each tier (web, app, db). Public access to the database and application subnets is explicitly disabled via NSGs. TLS termination is enforced at the Application Gateway.

### Secrets Management
Azure Key Vault: Database passwords, API keys, and JWT secrets are stored securely in Azure Key Vault rather than in source code or environment files.

### Monitoring & Logging
Azure Monitor & Log Analytics: A centralized Log Analytics Workspace collects diagnostic logs and metrics from the Application Gateway, VMSS instances, and MySQL Flexible Server.

### Backup & Recovery
Managed Database Automated Backups: Azure Database for MySQL Flexible Server is configured with automated backups retained for 30 days, along with point-in-time restore capabilities.



## Issues Encountered and Fixes

1. Issue: Database Connection Failure from Application Tier

Description: Upon initial deployment, the Node.js application tier could not connect to the Azure Database for MySQL instance, timing out despite correct credentials.

Investigation: I Checked NSG rules on the db-subnet and confirmed they allowed traffic on port 3306. However, the database server firewall settings were set to "Deny public network access" (as required), but the specific private endpoint connection had not fully propagated or was misconfigured.

Fix: I Reverified the "Private access (VNet Integration)" configuration on the MySQL Flexible Server. Ensured the correct VNet (bookreview-vnet) and db-subnet were linked. The issue resolved after ensuring the private DNS zone integration was correctly established by Azure.

2. Issue: Public Endpoint Unreachable (Application Gateway 502 Bad Gateway)

Description: The Application Gateway public IP resolved, but navigating to it resulted in a 502 Bad Gateway error.

Investigation: I Inspected the Application Gateway Backend health. The status for the web tier targets showed as "Unhealthy." This indicated the gateway could not successfully communicate with the backend web servers.

Fix:

Verified that the custom health probe was configured to look at the correct path and port (80).

SSH'd into a web tier instance and confirmed Nginx was running and serving the file locally.

Discovered the web-nsg inbound rules were missing a rule allowing traffic from the Application Gateway subnet (e.g., 10.10.1.0/24) to the web instances on port 80. Added this rule, and the backend health status immediately changed to "Healthy."

### Validation Evidence Checklist
I successfully validated the complete request path and security posture:

 - Public Endpoint Access: The Book Review App UI loaded successfully via the Application Gateway public IP.

 - Database Read Operation: Successfully viewed existing book reviews populated via the imported schema.

 - Database Write Operation: Successfully registered a new user and submitted a new book review, confirming data persistence.

 - Private Tier Isolation: Confirmed that direct SSH access from the internet to the Application Tier VMSS and the Database Server failed due to NSG restrictions.

 - Availability: Verified that Application Gateway health probes marked all running web instances as "Healthy."

 - Monitoring: Confirmed that logs from all three tiers were actively streaming into the Log Analytics Workspace.




---

# Submission Instructions

- Add all required screenshots and links in your submission
- Do not expose passwords, keys, connection strings, or subscription IDs

---

# Completion Checklist

- [ ] Task 1: Architecture diagram and assumptions documented (Screenshots 1–2)
- [ ] Task 2: Network foundation created with isolated tiers (Screenshots 3–5)
- [ ] Task 3: Least-privilege security and secret management configured (Screenshots 6–7)
- [ ] Task 4: Presentation tier deployed (Screenshots 8–9)
- [ ] Task 5: Application tier deployed privately (Screenshots 10–12)
- [ ] Task 6: Managed database tier deployed privately (Screenshots 13–15)
- [ ] Task 7: Public entry, internal routing, and monitoring configured (Screenshots 16–18)
- [ ] Task 8: End-to-end validation and availability test completed (Screenshots 19–22, Public Endpoint, Notes)
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

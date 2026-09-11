# Assignment 6 — Capstone Assignment — Deploy Book Review App (Three-Tier Architecture) on AWS

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

This is the most important assignment of the course. You will deploy the Book Review App in a fully production-style three-tier architecture on AWS: a Next.js Web Tier behind Nginx and a public ALB, a private Node.js/Express App Tier behind an internal ALB, and a private Multi-AZ MySQL RDS database with a read replica. You are expected to design, deploy, isolate, debug, and document the result independently.

---

# Task 1 — Architecture Diagram

## Goal

Create an architecture diagram showing the custom VPC (10.0.0.0/16), the six subnets across two Availability Zones (two public Web Tier, two private App Tier, two private Database Tier), the public ALB, Web Tier EC2/Nginx, internal ALB, private App Tier EC2, private Multi-AZ RDS with its read replica, and the permitted traffic flow.

### Evidence

#### Diagram image or link

![architecture-diagram](/week-06-aws-cloud/screenshots/high-availability-web-architecture-aws.jpg)

---

# Task 2 — AWS Region & Services Used

## Goal

Record the AWS Region used and list every AWS service used across networking, compute, load balancing, security, and the database.

### Notes

**Region:**

US-East-1

---

**Services:**

**AWS Services Used**

**Networking**
+ Amazon VPC — custom VPC using 10.0.0.0/16
+ Amazon VPC Subnets — six subnets across two Availability Zones:
+ 2 public Web Tier subnets
+ 2 private App Tier subnets
+ 2 private Database Tier subnets
+ Route Tables — public, private App, and private Database routing
+ Internet Gateway — Internet connectivity for the public Web Tier
+ NAT Gateway — outbound Internet connectivity for private App Tier instances

**Compute**
+ Amazon EC2 — Ubuntu instances for:
+ Web Tier: Next.js + Nginx
+ App Tier: Node.js/Express

**Load Balancing**
+ Application Load Balancer (ALB), Internet-facing — public entry point for the Web Tier
+ Application Load Balancer (ALB), Internal — private load balancer for the App Tier

**Security**
+ Amazon VPC Security Groups — tier-to-tier traffic control:
+ Public ALB → Web Tier: HTTP 80
+ Web Tier → Internal ALB: TCP 3001
+ Internal ALB → App Tier: TCP 3001
+ App Tier → RDS: MySQL 3306

+ AWS Identity and Access Management (IAM) — permissions for AWS resources/management where required
+ AWS Systems Manager Session Manager — optional/preferred method for accessing private App Tier instances without exposing SSH

**Database**
+ Amazon RDS for MySQL — primary application database
+ Amazon RDS DB Subnet Group — places RDS across the two private DB subnets
+ RDS Multi-AZ — high availability/failover
+ RDS Read Replica — read-scaling/replication

**Application/Server Software**
Although these aren't AWS services, they should also be listed because they are part of the deployed architecture:
+ Ubuntu — EC2 operating system
+ Nginx — Web Tier reverse proxy
+ Next.js — frontend
+ Node.js / Express — backend
+ MySQL — database engine

---

# Task 3 — Public Entry Point

## Goal

Confirm the Book Review App loads through the public ALB DNS name.

### Evidence

#### Public ALB DNS

Paste your public ALB DNS name here:

Book-Review-Web-ALB-759039383.us-east-1.elb.amazonaws.com

---

# Task 4 — Evidence Screenshots

## Goal

Capture visual proof of every tier and load balancer.

### Evidence

#### Web EC2

![web-ec2](/week-06-aws-cloud/screenshots/web-ec2.png)

---

#### App EC2

![app-ec2](/week-06-aws-cloud/screenshots/app-ec2.png)

---

#### Public ALB

![public-alb](/week-06-aws-cloud/screenshots/public-alb.png)

---

#### Internal ALB

![internal-ALB](/week-06-aws-cloud/screenshots/internal-alb.png)

---

#### RDS + Replica

![rds-replica](/week-06-aws-cloud/screenshots/rds-replica.png)

---

#### App UI proof

Add your screenshot here.

---

# Task 5 — Summary

## Goal

Summarize what worked in the final deployment, the issues encountered and how each was fixed, and the tools or sources used to research and debug.

### Notes

**What worked:**

Write your answer here.

---

**Issues + fixes:**

Write your answer here.

---

**Tools/sources used:**

Write your answer here.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post sharing the capstone deployment, including the public ALB DNS (or a redacted screenshot), three to five lines on what you built and why it is production-style, and one proof screenshot.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`Add your URL here`

---

#### Screenshot of LinkedIn post

Add your screenshot here.

---

# Submission Instructions

- Add all required screenshots and links in your submission
- Do not expose passwords, RDS credentials, connection strings, private keys, or account IDs

---

# Completion Checklist

- [ ] Task 1: Architecture diagram completed
- [ ] Task 2: AWS Region and services documented
- [ ] Task 3: Public ALB DNS confirmed working
- [ ] Task 4: All six evidence screenshots captured (Web Tier, App Tier, both ALBs, RDS + replica, app UI)
- [ ] Task 5: Deployment summary completed (what worked, issues/fixes, tools/sources)
- [ ] LinkedIn post published and URL submitted
- [ ] App Tier and Database Tier confirmed not publicly accessible
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
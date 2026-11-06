# Capstone Assignment — Deploy the Book Review App Using Terraform and Claude Code Agentic AI

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Student Details

**Full Name:** George Adimowei Epebifie 
**Cloud Platform:** AWS 
**GitHub Repository URL:** https://github.com/wisegeorge1/book-review-app.git  
**Public Application URL / Load-Balancer DNS:** http://book-review-public-alb-1127651348.us-east-1.elb.amazonaws.com/

---

## Purpose

Deploy the Book Review App using Terraform on AWS or Azure in a secure, highly available, production-style three-tier architecture. Use Claude Code, specialized subagents, Terraform MCP, and validation hooks to support the engineering workflow while keeping all infrastructure-changing operations under human control.

---

# Task 0 — Prepare the Project and Agentic AI Environment

## Goal

Prepare the Book Review App project and configure the provided Claude Code Agentic AI starter kit with project context, specialized subagents, Terraform MCP, validation hooks, and safety guardrails.

## Evidence

### Screenshot 1 — Project `CLAUDE.md`

Add a screenshot of the project `CLAUDE.md` showing the three-tier architecture, security boundaries, Terraform requirements, and human-approval rules.

![claude.md](/week-08-terraform/screenshots/Assign5-SS-1.png)
![claude.md](/week-08-terraform/screenshots/Assign5-SS-1a.png)

---

### Screenshot 2 — Terraform Engineer Subagent

Add a screenshot showing the Terraform Engineer subagent configuration.

![engineer-subagent](/week-08-terraform/screenshots/Assign5-SS-2.png)

---

### Screenshot 3 — Architecture and Security Reviewer Subagent

Add a screenshot showing the Architecture and Security Reviewer subagent configuration.

![security-reviewer](/week-08-terraform/screenshots/Assign5-SS-3.png)

---

### Screenshot 4 — Terraform MCP Connection

Add a screenshot showing Terraform MCP connected and available.

![ss4](/week-08-terraform/screenshots/ass5-ss4.png)

---

### Screenshot 5 — Validation Hooks

Add a screenshot showing the configured Claude Code validation hooks.

![ss5](/week-08-terraform/screenshots/ass5-ss5.png)

---

# Task 1 — Design the Three-Tier Architecture

## Goal

Design the required secure, highly available three-tier architecture and create an architecture diagram before building the infrastructure.

The diagram must show:

- VPC or VNet
- Availability Zones or equivalent availability locations
- Six subnets
- Internet connectivity
- NAT or outbound design
- Public load balancer
- Web Tier
- Internal load balancer
- Application Tier
- Managed MySQL
- Read replica
- Main traffic flow

## Architecture Diagram

![Architecture-Diagram](/week-08-terraform/screenshots/three-tier-high-available-book-review.png)

---

# Task 2 — Build the Terraform Networking and Security Layers

## Goal

Create the modular Terraform project and implement the network and security layers across the required public and private subnets.

## Evidence

### Screenshot 6 — Modular Terraform Project Structure

Add a screenshot showing the modular Terraform project structure.

![ss6](/week-08-terraform/screenshots/ass5-ss6.png)

---

### Screenshot 7 — Six-Subnet Architecture

Add a screenshot showing the six-subnet architecture across two availability locations.

![ss7](/week-08-terraform/screenshots/ass5-ss7.png)
                
---

### Screenshot 8 — Public and Private Tier Separation

Add a screenshot showing the public and private tier separation, including routing and security boundaries.

![ss8](/week-08-terraform/screenshots/ass5-ss8.png)

---

# Task 3 — Build the Load-Balancing and Compute Layers

## Goal

Deploy the public and internal load balancers and the Web and Application compute resources required by the Book Review App.

## Evidence

### Screenshot 9 — Web and Application Compute

Add a screenshot showing the Web and Application compute resources in their required subnets.

![ss9](/week-08-terraform/screenshots/ass5-ss9.png)

---

### Screenshot 10 — Public Load Balancer

Add a screenshot showing the internet-facing public load balancer.

![ss10](/week-08-terraform/screenshots/ass5-ss10.png)

---

### Screenshot 11 — Internal Load Balancer

Add a screenshot showing the private internal load balancer.

![ss11](/week-08-terraform/screenshots/ass5-ss11.png)

---

### Screenshot 12 — Healthy Targets

Add a screenshot showing healthy target groups or backend pools.

![ss12](/week-08-terraform/screenshots/ass5-ss12.png)

---

# Task 4 — Build the Managed MySQL Database Layer

## Goal

Deploy a private, highly available managed MySQL database with a read replica and restrict database connectivity to the Application Tier.

## Evidence

### Screenshot 13 — Managed MySQL Database

Add a screenshot showing the managed MySQL database deployment.

![ss13](/week-08-terraform/screenshots/ass5-ss13.png)

---

### Screenshot 14 — High Availability

Add a screenshot showing the Multi-AZ or high-availability configuration.

![ss14](/week-08-terraform/screenshots/ass5-ss14.png)

---

### Screenshot 15 — Read Replica

Add a screenshot showing the read replica configuration.

![ss15](/week-08-terraform/screenshots/ass5-ss15.png)

---

### Screenshot 16 — Private Database Access

Add a screenshot showing that the database is private and accepts MySQL traffic only from the Application Tier.

![ss16](/week-08-terraform/screenshots/ass5-ss16.png)
![ss16](/week-08-terraform/screenshots/ass5-ss16a.png)

---

# Task 5 — Validate, Review, and Apply the Terraform Configuration

## Goal

Validate the Terraform configuration, review the execution plan using both Agentic AI and human judgment, and apply the infrastructure changes only after all required checks pass.

## Evidence

### Screenshot 17 — Terraform Validation

Add a screenshot showing successful `terraform validate` output.

![ss17](/week-08-terraform/screenshots/ass5-ss17.png)

---

### Screenshot 18 — Terraform Plan

Add a screenshot showing the Terraform plan output.

![ss18](/week-08-terraform/screenshots/ass5-ss18.png)

---

### Screenshot 19 — Terraform Apply

Add a screenshot showing successful `terraform apply` completion.

![ss19](/week-08-terraform/screenshots/ass5-ss19.png)

---

# Task 6 — Deploy and Configure the Book Review Application

## Goal

Deploy and configure the Book Review App across the Web, Application, and Database tiers and verify the complete application functionality.

## Evidence

### Screenshot 20 — Homepage

Add a screenshot showing the Book Review App homepage through the public endpoint.

![ss20](/week-08-terraform/screenshots/ass5-ss20.png)

---

### Screenshot 21 — Login or Authentication

Add a screenshot showing successful login or authentication.

![ss20](/week-08-terraform/screenshots/Ass5-SS-21.png)

---

### Screenshot 22 — Book Data

Add a screenshot showing the book listing or book details.

![ss22](/week-08-terraform/screenshots/Ass5-SS-22.png)
![ss22](/week-08-terraform/screenshots/Ass5-SS-22a.png)

---

### Screenshot 23 — Review Functionality

Add a screenshot showing the review functionality working successfully.

![ss23](/week-08-terraform/screenshots/Ass5-SS-23.png)

---

### Screenshot 24 — Backend or API Evidence

Add a screenshot showing that the backend or API is working successfully.

![ss24](/week-08-terraform/screenshots/Ass5-ss-24.png)

---

### Screenshot 25 — Database Reads and Writes

Add a screenshot showing successful database reads and writes.

![ss25](/week-08-terraform/screenshots/Ass5-SS-25.png)

## Public Application URL

**Public Application URL / DNS:** <http://book-review-public-alb-1127651348.us-east-1.elb.amazonaws.com/>

---

# Task 7 — Demonstrate the Agentic AI Workflow

## Goal

Demonstrate how Claude Code assisted with Terraform generation, architecture and security review, and evidence-based troubleshooting while infrastructure-changing decisions remained under human control.

You do not need to submit your complete Claude Code conversation history. Include only focused evidence.

## Evidence

### Screenshot 26 — AI-Assisted Terraform Generation

Add a screenshot showing one useful example of AI-assisted Terraform generation or improvement.

![ss26](/week-08-terraform/screenshots/Ass5-SS-26.png)
![ss26](/week-08-terraform/screenshots/Ass5-SS-26a.png)
![ss26](/week-08-terraform/screenshots/Ass5-SS-26b.png)

---

### Screenshot 27 — Architecture or Security Review

Add a screenshot showing one structured architecture or security review result.

![ss27](/week-08-terraform/screenshots/Ass5-SS-27.png)
![ss27](/week-08-terraform/screenshots/Ass5-SS-27a.png)
![ss27](/week-08-terraform/screenshots/Ass5-SS-27b.png)
![ss27](/week-08-terraform/screenshots/Ass5-SS-27c.png)
![ss27](/week-08-terraform/screenshots/Ass5-SS-27d.png)

---

### Screenshot 28 — AI-Assisted Troubleshooting

Add a screenshot showing one AI-assisted troubleshooting interaction based on collected evidence.

![ss28](/week-08-terraform/screenshots/Ass5-SS-28.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28a.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28b.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28c.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28d.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28e.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28f.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28g.png)
![ss28](/week-08-terraform/screenshots/Ass5-SS-28h.png)

---

# Task 8 — Complete the Final Architecture Review

## Goal

Review the completed infrastructure against the original capstone requirements and resolve significant architecture, security, reliability, and cost issues.

Confirm that the final review covers:

- Tier separation
- Availability
- Public exposure
- Routing
- Security rules
- Load balancing
- Database privacy
- Secrets
- Terraform quality
- Module structure
- Reliability
- Obvious cost risks

Use Screenshot 27 as the focused evidence for the structured architecture or security review.

---

# Task 9 — Answer the Reflection Questions

## Goal

Reflect on the architecture, Terraform implementation, and Agentic AI workflow. Answer each question briefly in your own words.

## Architecture

### 1. Why did you separate the Web, Application, and Database tiers?

I separated the system into three tiers so that each layer has a clear responsibility and security boundary. The Web Tier handles internet-facing traffic and the frontend, the Application Tier handles the backend/API logic, and the Database Tier stores application data. This separation makes the system easier to secure, troubleshoot, scale, and maintain.

### 2. Why is the Application Tier private?

The Application Tier is private because users should not connect directly to the backend servers. Internet traffic reaches the Web Tier first, and the Web Tier communicates with the Application Tier through the internal load balancer. This reduces the attack surface and prevents direct public access to the Node.js API servers.

### 3. Why is MySQL private?

MySQL contains sensitive application data, so it should never be directly accessible from the internet. The RDS database is placed in private subnets and only accepts MySQL traffic from the Application Tier. This protects the database while still allowing the backend to access it.

### 4. Why are multiple Availability Zones used?

I used multiple Availability Zones to avoid having the entire application depend on a single data center or Availability Zone. If one AZ becomes unavailable, resources in another AZ can continue serving users. This improves availability and resilience.

### 5. What is the difference between Multi-AZ/high availability and a read replica?

Multi-AZ is primarily designed for high availability and failover. A standby database is maintained in another Availability Zone so the system can recover from an infrastructure failure. A read replica is primarily designed to scale read operations by allowing read traffic to be distributed to another database instance. Therefore, Multi-AZ focuses on availability, while read replicas focus mainly on read scalability.

## Terraform

### 6. How did you divide your Terraform into modules?

I divided Terraform into logical modules based on infrastructure responsibilities. The main modules cover the network, security groups, load balancers, compute resources, and database. The root Terraform configuration coordinates these modules and provides their required variables.

### 7. How do the modules communicate through variables and outputs?

The root module passes configuration values into child modules through variables. Each module exposes important resources through outputs, such as subnet IDs, security group IDs, load balancer information, and database information. Other modules can then consume those outputs instead of hard-coding resource IDs.

### 8. What did you specifically check in `terraform plan`?

I checked for unexpected resource creation, deletion, or replacement, especially for EC2 instances, load balancers, and the RDS database. I also checked network CIDRs, public versus private resources, security-group rules, ports 3001 and 3306, public IP assignments, Availability Zones, and any 0.0.0.0/0 rules. I also reviewed potential cost-impacting resources and anything that could affect the existing database.

## Agentic AI

### 9. What was the purpose of `CLAUDE.md`?

CLAUDE.md provided Claude Code with the project's rules, architecture requirements, security expectations, Terraform workflow, and validation requirements. It acted as persistent project guidance so that the AI consistently followed the intended three-tier architecture instead of making isolated decisions.

### 10. What work did the Terraform Engineer subagent perform?

The Terraform Engineer subagent helped design and generate the Terraform infrastructure according to the required architecture. It focused on the Terraform modules, AWS resources, variables, outputs, dependencies, and validation of the infrastructure configuration.

### 11. What did the Architecture and Security Reviewer identify?

The Architecture and Security Reviewer examined the proposed infrastructure against the required architecture and security controls. It checked areas such as public versus private resources, security-group access, database exposure, load-balancer configuration, ports, Availability Zones, and potentially risky Terraform changes. Its review helped identify issues that needed correction before applying infrastructure changes.

### 12. Why did you use Terraform MCP instead of relying only on Claude's existing Terraform knowledge?

I used Terraform MCP so that Claude could work with more current and authoritative Terraform information rather than relying only on knowledge learned during training. This was particularly useful for checking provider and Terraform behavior and reducing the risk of using outdated syntax or assumptions.

### 13. What was the purpose of your validation hooks?

The validation hooks provided an automated safety check before infrastructure changes progressed. The workflow included formatting and Terraform validation so that basic configuration errors could be detected early. This helped make the process more consistent and reduced avoidable errors before planning or applying infrastructure.

### 14. Describe one real issue Claude helped you troubleshoot.

One real issue was that the application initially returned a 502 Bad Gateway through the public load balancer because Nginx was not correctly configured to listen on port 80 and route traffic to the frontend. We also had backend connectivity and configuration issues during deployment. By checking target health, service status, logs, Nginx configuration, and API responses, we identified and corrected the problems.

Another important issue was registration and login failing because the backend did not have the correct ALLOWED_ORIGINS configuration. The application was falling back to localhost origins, while the browser was accessing the application through the public load balancer hostname. Adding the correct origin to both Application Tier instances resolved the problem.

### 15. Describe one recommendation you reviewed, modified, or rejected instead of accepting blindly.

One example was the handling of database initialization and sample data. Instead of enabling DB_SYNC or SEED_DATA in production, I kept both disabled because the production configuration explicitly prevents those settings. I created the required sample books through the application API and verified that they were persisted in RDS. This demonstrated that I treated AI recommendations as suggestions that needed to be reviewed against the architecture and production requirements rather than accepting them automatically.

---

# Task 10 — Publish the Mandatory LinkedIn Post

## Goal

Publish a LinkedIn post describing the capstone, the technical work completed, the Agentic AI workflow, and the lessons learned.

Write the post in your own words, include at least one project image or other proof, and ensure that it can be viewed by the submission reviewer.

## LinkedIn Post URL

**LinkedIn Post URL:** <https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7524432945890230272-aBha/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Complete Tasks 0–10 in sequence.
- Include all Screenshots 1–28 exactly as specified.
- Ensure that your full name is visible in the required screenshots.
- Include the selected cloud platform.
- Include the completed architecture diagram.
- Include the modular Terraform project structure.
- Include the working public application URL or public load-balancer DNS.
- Include all required Agentic AI workflow evidence.
- Answer all 15 reflection questions briefly in your own words.
- Include the published LinkedIn post URL.
- Do not expose cloud credentials, database passwords, SSH private keys, JWT secrets, access tokens, account IDs, Terraform state containing sensitive values, or other confidential information.
- Review all screenshots and project files carefully before submitting through GitHub.

---

# Completion Checklist

- [ ] Selected AWS or Azure
- [ ] Added and reviewed the Agentic AI starter files
- [ ] Configured `CLAUDE.md`
- [ ] Configured the Terraform Engineer subagent
- [ ] Configured the Architecture and Security Reviewer subagent
- [ ] Connected Terraform MCP
- [ ] Configured validation hooks and safety guardrails
- [ ] Created the architecture diagram
- [ ] Created the six-subnet design
- [ ] Configured public Web Tier routing
- [ ] Kept the Application Tier private
- [ ] Kept the Database Tier private
- [ ] Configured tier-specific Security Groups or NSGs
- [ ] Restricted backend port `3001`
- [ ] Restricted MySQL port `3306` to the Application Tier
- [ ] Created the public load balancer
- [ ] Created the internal load balancer
- [ ] Configured listeners and health checks
- [ ] Deployed the Web Tier compute resources
- [ ] Deployed the private Application Tier compute resources
- [ ] Provisioned private managed MySQL
- [ ] Configured Multi-AZ or high availability
- [ ] Configured a read replica
- [ ] Created the modular Terraform project
- [ ] Used variables, outputs, and module dependencies
- [ ] Used current Terraform documentation through MCP
- [ ] Used hooks for deterministic validation
- [ ] Completed `terraform fmt`
- [ ] Completed `terraform validate`
- [ ] Reviewed `terraform plan`
- [ ] Completed the Terraform Engineer review
- [ ] Completed the Architecture and Security review
- [ ] Applied the infrastructure only after human approval
- [ ] Deployed and configured the backend
- [ ] Deployed and configured the frontend
- [ ] Configured Nginx where required
- [ ] Configured the internal backend endpoint
- [ ] Configured the public frontend endpoint
- [ ] Verified the homepage
- [ ] Verified login or authentication
- [ ] Verified book data
- [ ] Verified review functionality
- [ ] Verified the backend API
- [ ] Verified database reads and writes
- [ ] Verified healthy load-balancer targets
- [ ] Included AI-assisted Terraform generation evidence
- [ ] Included one architecture or security review
- [ ] Included one AI-assisted troubleshooting example
- [ ] Completed the final architecture review
- [ ] Answered all 15 reflection questions
- [ ] Published the mandatory LinkedIn post
- [ ] Added the LinkedIn post URL
- [ ] Captured all 28 required screenshots
- [ ] Confirmed that my full name is visible in the required screenshots
- [ ] Checked that no secrets or sensitive information are exposed

---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory), focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations through hands-on experience.

---

## Resources

- Book Review App Repository: [https://github.com/pravinmishraaws/book-review-app](https://github.com/pravinmishraaws/book-review-app)
- DMI Official Website: [https://dmi.pravinmishra.com](https://dmi.pravinmishra.com)
- University: [https://university.pravinmishra.com](https://university.pravinmishra.com)
- Discord Community: [https://discord.pravinmishra.com](https://discord.pravinmishra.com)
- Blog: [https://dmi.pravinmishra.com/blog](https://dmi.pravinmishra.com/blog)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra on LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory on LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of the DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*

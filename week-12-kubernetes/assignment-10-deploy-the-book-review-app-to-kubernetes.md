# Assignment 10 — Capstone: Deploy the Book Review App to Kubernetes

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Deploy the Book Review App as a production style three tier application using Kubernetes manifests or Helm charts, with an accessible frontend, an internal backend, and a managed or persistent MySQL database.

---

## Submission Details

**Full Name:** George Adimowei Epebifie

**Kubernetes Platform:** Azure Kubernetes Service (AKS)

**Namespace:** book-review

**Frontend URL or IP:** <http://135.18.211.88/>

**Access Method:** Public LoadBalancer: the Kubernetes LoadBalancer Service frontend on port 80, backed by an Azure Standard Load Balancer

**GitHub Manifests or Helm Chart URL:**  https://github.com/wisegeorge1/book-review-app

**Architecture Diagram:** ![architecture](/week-12-kubernetes/screenshots/Ass10-ss3.png)

---

# Task 1 — Prepare the Kubernetes Cluster and Project

## Goal

Prepare the cluster, application source, container images, and tooling needed for the deployment.

### Evidence

#### Screenshot 1 — Active Kubernetes context and Ready nodes

![ss1](/week-12-kubernetes/screenshots/Ass10-ss1.png)

---

#### Screenshot 2 — If using Helm: Output of `helm version`

Required only if you choose Helm. Skip this screenshot if using YAML manifests.

Not applicable — using YAML manifests.

---

# Task 2 — Design the Three-Tier Kubernetes Architecture

## Goal

Document the workloads, networking, configuration, storage, and permitted communication paths before deployment.

### Evidence

#### Screenshot 3 — Completed Kubernetes architecture diagram

![ss3](/week-12-kubernetes/screenshots/Ass10-ss3.jpg)

---

# Task 3 — Create ConfigMaps and Secrets

## Goal

Provide application configuration and credentials without embedding sensitive values in images or committing them to Git.

### Evidence

#### Screenshot 4 — ConfigMap configuration or describe output showing non-sensitive values

![ss4](/week-12-kubernetes/screenshots/Ass10-ss4.png)

---

#### Screenshot 5 — Secret references or describe output showing names and keys without sensitive values

![ss5](/week-12-kubernetes/screenshots/Ass10-ss5.png)

---

# Task 4 — Deploy and Configure the MySQL Data Tier

## Goal

Provide persistent MySQL storage and allow the backend to connect without exposing the database publicly.

### Evidence

#### Screenshot 6 — Managed MySQL status or MySQL StatefulSet and PVC status

![ss6](/week-12-kubernetes/screenshots/Ass10-ss6.png)

---

#### Screenshot 7 — Successful database connectivity or schema verification with credentials hidden

![ss7](/week-12-kubernetes/screenshots/Ass10-ss7.png)

---

# Task 5 — Deploy the Backend Application Tier

## Goal

Run one or two Node.js/Express backend replicas on port 3001 and expose them through an internal ClusterIP Service.

### Evidence

#### Screenshot 8 — Backend Deployment, ready Pods, and internal Service

![ss8](/week-12-kubernetes/screenshots/Ass10-ss8.png)

---

#### Screenshot 9 — Backend startup logs and database connectivity evidence

If the application does not log successful database connections, provide a successful database-backed request alongside the startup logs.

![ss9](/week-12-kubernetes/screenshots/Ass10-ss9.png)

---

# Task 6 — Deploy the Frontend and Configure Nginx

## Goal

Run the Next.js frontend behind Nginx on port 80 and proxy API requests to the internal backend Service.

### Evidence

#### Screenshot 10 — Frontend Deployment and Ready Pods

![ss10](/week-12-kubernetes/screenshots/Ass10-ss10.png)

---

#### Screenshot 11 — Nginx reverse-proxy configuration showing the internal backend Service name and port 3001

![ss11](/week-12-kubernetes/screenshots/Ass10-ss11.png)

---

# Task 7 — Configure External and Internal Networking

## Goal

Expose the frontend and enforce the intended communication path between application tiers.

### Evidence

#### Screenshot 12 — Frontend LoadBalancer or Ingress configuration and assigned endpoint, or documented local access method

![ss12](/week-12-kubernetes/screenshots/Ass10-ss12.png)

---

#### Screenshot 13 — Internal backend Service and NetworkPolicy or equivalent restriction, with access-test evidence

![ss13](/week-12-kubernetes/screenshots/Ass10-ss13.png)

---

# Task 8 — Validate the Application End to End

## Goal

Prove that the frontend, backend, and MySQL database work together and collect operational evidence.

### Evidence

#### Screenshot 14 — `kubectl get all` output for the book-review namespace

![ss14](/week-12-kubernetes/screenshots/Ass10-ss14.png)

---

#### Screenshot 15 — Functional Book Review App in the browser with the URL visible, including evidence of a successful user flow

![ss15](/week-12-kubernetes/screenshots/Ass10-ss15.png)

---

#### Screenshot 16 — Frontend or Nginx container logs

![ss16](/week-12-kubernetes/screenshots/Ass10-ss16.png)

---

#### Screenshot 17 — Backend logs and evidence of a successful database-backed operation

![ss17](/week-12-kubernetes/screenshots/Ass10-ss17.png)

---

#### Screenshot 18 — Optional: Kubernetes dashboard

Not attempted.

Multiple images may be included under a screenshot number when needed to demonstrate the complete user flow.

---

# Task 9 — Optional: Implement Production Improvements

## Goal

Add selected improvements without breaking the required three-tier architecture.

### Evidence

#### Screenshot 19 — Optional: Evidence of selected Helm, HPA, probe, or TLS improvements

Not attempted.

---

# Task 10 — Publish Your Book Review App Deployment on LinkedIn

## Goal

Explain your three-tier architecture, demonstrate the working application, and share what you learned.

### Evidence

#### Screenshot 20 — Published LinkedIn post about your Book Review App deployment on Kubernetes

![ss20](/week-12-kubernetes/screenshots/Ass10-ss20.png)

### LinkedIn Post URL

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputingnbsp-ugcPost-7518307170225123328-7j_u/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Final Summary

## What Worked

Describe the application components and user flows you successfully deployed and tested.

I worked on deploying a full-stack Book Review Application using Kubernetes and a three-tier architecture. The project demonstrates how frontend, backend, and database components communicate within a Kubernetes cluster, with a focus on service discovery, secure networking, persistent storage, and end-to-end application testing.

1. Application Components
Frontend — Next.js + Nginx

User interface · External access through a LoadBalancer Service

HTTP requests through /api/

Backend — Node.js + Express

REST API · Port 3001 · Internal ClusterIP Service

Database queries

Database — MySQL

Persistent storage for book and review data

The deployment also uses Kubernetes ConfigMaps for application configuration, Secrets for sensitive values, and NetworkPolicies to restrict communication between application tiers.

2. User Flows and Application Behavior
Accessing the application: Users connect to the frontend through the LoadBalancer Service, which exposes the Next.js application behind Nginx.

Making API requests: The browser sends requests to /api/. Nginx proxies those requests to the internal backend Service, so the browser does not need direct access to Kubernetes-only DNS names.

Processing application requests: The Node.js/Express backend handles API requests and communicates with MySQL to retrieve or modify application data.

Persisting data: MySQL uses persistent storage so that database data can survive the lifecycle of an individual database Pod, subject to the storage configuration.

Securing communication: Kubernetes Secrets, ConfigMaps, and NetworkPolicies help manage configuration and control communication between the application components.

3. Deployment and Testing Evidence
The work focused on validating Kubernetes resources and application connectivity, including:

Checking Pod status, readiness, and restart counts.

Verifying Services and their endpoints.

Inspecting frontend/Nginx and backend logs to troubleshoot request failures.

Checking that API requests can reach the internal backend.

Validating database connectivity and persistence through actual application operations.

Important distinction: The architecture and deployment approach are established by the project details provided. However, the available conversation does not contain successful Book Review App test outputs or database operation results, so I cannot independently confirm that every user flow completed successfully.

4. Key Engineering Takeaway
The project highlights an important DevOps lesson: a successful Kubernetes deployment is more than running Pods. A working application also requires correct service discovery, reliable inter-tier communication, secure configuration, persistent data, and end-to-end verification.

This experience demonstrates practical skills in Kubernetes, Docker based application deployment, Nginx reverse proxy configuration, Node.js, MySQL, networking, troubleshooting, and cloud infrastructure engineering.

## Issues and Fixes

Describe the main issues encountered, their causes, and how you resolved them.

During the deployment of the full-stack Book Review Application on Kubernetes, the main engineering challenges involved application networking, service discovery, reverse proxy configuration, database connectivity, persistent storage, and secure communication between application tiers.

1. Frontend-to-Backend Communication
Issue: The frontend needed to communicate with the backend API running inside the Kubernetes cluster.

Cause: Kubernetes internal Service DNS names are resolvable within the cluster but are not directly accessible to users' browsers.

Resolution: I configured Nginx to proxy requests beginning with /api/ to the internal Node.js/Express backend Service on port 3001. This allowed the browser to communicate with the API through the frontend endpoint without exposing the backend Service publicly.

2. Kubernetes Service Discovery and Networking
Issue: Ensuring requests reached the correct application component.

Cause: Each tier ran independently and relied on Kubernetes Services for network communication. Incorrect Service names, selectors, ports, or target ports could prevent communication between Pods.

Resolution: I used an internal ClusterIP Service for the backend and a LoadBalancer Service for the frontend. The configuration was designed to route requests through the appropriate Services rather than relying on Pod IP addresses.

3. Backend-to-Database Connectivity
Issue: The backend needed reliable access to MySQL to process book and review operations.

Cause: The backend depended on correct database connection settings, credentials, and network access to the database Service.

Resolution: I used Kubernetes configuration resources to manage application settings and Secrets for sensitive database credentials. The backend was configured to connect to MySQL through its Kubernetes Service rather than a hard-coded Pod IP.

4. Database Persistence
Issue: Book and review records needed to remain available across database Pod restarts or replacements.

Cause: Data stored only in a container's writable filesystem can be lost when the container is replaced.

Resolution: I configured MySQL with persistent storage so database files could be retained independently of the database Pod's lifecycle. Actual persistence should be confirmed by creating data, restarting or replacing the database Pod, and verifying that the records remain available.

5. Configuration and Network Security
Issue: The application needed appropriate separation between its frontend, backend, and database tiers.

Cause: Poorly managed configuration, exposed credentials, or unrestricted network access can increase the application's security risks.

Resolution: I used ConfigMaps for non-sensitive configuration, Kubernetes Secrets for sensitive values, and NetworkPolicies to restrict communication between application tiers according to the intended traffic flows.

6. End-to-End Application Validation
Issue: A deployment could appear healthy at the Kubernetes resource level while application requests still failed.

Cause: Running Pods alone does not prove that Nginx can reach the backend, that the backend can query MySQL, or that database-backed operations work correctly.

Resolution: I identified the need to validate the complete request path by inspecting Pod status, Services, endpoints, and application logs. End-to-end verification should include loading the frontend, submitting an API request, creating or retrieving a book review, and confirming the resulting database record.

Key Takeaway
The most important lesson from this deployment was that deploying a full-stack application on Kubernetes requires more than creating containers and running Pods. Reliable service discovery, correct Nginx reverse proxy configuration, secure credentials, persistent database storage, and end-to-end testing are all essential to delivering a functioning application.

## Tools and Sources Used

List the documentation and tools that helped you complete the assignment.

1. Documentation and Technical Resources
Kubernetes Official Documentation — Guidance on Pods, Deployments, Services, ConfigMaps, Secrets, NetworkPolicies, persistent storage, and application troubleshooting.
https://kubernetes.io/docs/ 

Kubernetes Concepts: Services and Networking — Understanding internal service discovery, ClusterIP and LoadBalancer Services, and communication between application tiers.
https://kubernetes.io/docs/concepts/services-networking/ 

Kubernetes Persistent Volumes — Guidance on persistent storage for MySQL database data.
https://kubernetes.io/docs/concepts/storage/persistent-volumes/ 

Next.js Documentation — Reference for frontend application configuration and deployment.
https://nextjs.org/docs 

NGINX Documentation — Guidance on reverse proxy configuration and routing /api/ requests to the backend Service.
https://nginx.org/en/docs/ 

Express.js Documentation — Reference for developing and configuring backend REST APIs.
https://expressjs.com/ 

MySQL Documentation — Guidance on database configuration, SQL operations, and data persistence.
https://dev.mysql.com/doc/ 

Microsoft Azure Kubernetes Service (AKS) Documentation — Guidance on Kubernetes cluster management, networking, and workloads in Azure.
https://learn.microsoft.com/en-us/azure/aks/ 

2. Tools and Technologies
Tool or technology

Purpose

Kubernetes

Orchestrating the frontend, backend, and database workloads.

Azure Kubernetes Service (AKS)

Hosting and managing the Kubernetes cluster.

Docker

Packaging application components into container images.

kubectl

Deploying resources and inspecting Pods, Services, endpoints, events, and logs.

NGINX

Reverse proxying frontend API requests to the internal backend Service.

Next.js

Building the frontend user interface.

Node.js and Express.js

Implementing backend API endpoints and application logic.

MySQL

Storing book and review records.

ConfigMaps and Secrets

Managing application configuration and sensitive credentials.

Persistent Volumes and Persistent Volume Claims

Providing persistent database storage.

NetworkPolicies

Restricting communication between application tiers.

PowerShell

Running Kubernetes commands and troubleshooting the deployment from Windows.

3. Troubleshooting Commands
The following commands were particularly relevant to inspecting Kubernetes resources and diagnosing connectivity issues:


powershell
kubectl get pods -o wide
kubectl get services
kubectl get endpoints
kubectl get events --sort-by='.lastTimestamp'
kubectl logs <pod-name>
kubectl describe pod <pod-name>
kubectl describe service <service-name>
These tools and resources supported the deployment workflow, configuration, networking, and troubleshooting of the Book Review Application.

Note: This list identifies the relevant documentation and technologies for the project. It does not imply that every resource was consulted directly or that every application test was successfully completed.

## Optional Improvements

Describe any optional improvements implemented, or write “Not attempted.”

Not attempted

## Cleanup or Reuse Plan

State which resources were removed or why the environment is being retained.

The Kubernetes environment is being retained temporarily for further testing, troubleshooting, and demonstration of the Book Review Application deployed on Azure Kubernetes Service (AKS).

The environment contains the frontend (Next.js behind Nginx), backend (Node.js/Express), and MySQL database components, along with Kubernetes Services, configuration resources, NetworkPolicies, and persistent storage.

Before cleanup, I will verify that the application configuration and deployment manifests are preserved and that any required database data is backed up.

Once testing and documentation are complete, I plan to:

Remove the application Deployments, Services, and other resources that are no longer required.
Remove unused ConfigMaps, Secrets, and NetworkPolicies associated with the application, after confirming they are not shared by other workloads.
Review PersistentVolumeClaims and associated storage resources carefully before deletion to avoid unintended data loss.
Delete the AKS cluster and associated Azure resources if they are no longer needed, to prevent unnecessary cloud costs.
Retain reusable Kubernetes manifests, Dockerfiles, Nginx configuration, and deployment documentation for future projects and portfolio demonstrations.
Current status: The environment is being retained pending final verification and cleanup. Complete resource removal has not yet been confirmed.

---

# Submission Instructions

- Include your Kubernetes manifests or Helm chart in the linked repository.
- Submit Secret examples containing placeholders only.
- Include Screenshot 1, Screenshots 3–17, and Screenshot 20.
- Include Screenshot 2 only if using Helm.
- Screenshots 18–19 are optional.
- Keep screenshot numbering consistent with the guidelines.
- Use clear, readable screenshots showing relevant configuration, commands, and outputs.
- Make your full name visible in required screenshots.
- Complete the submission details and Final Summary.
- Include your published LinkedIn post URL.
- Capture required evidence before cleanup.
- Do not expose passwords, tokens, JWT secrets, actual Secret values, kubeconfig contents, cloud credentials, or confidential account information.

---

# Completion Checklist

- [ ] Selected and configured a supported Kubernetes platform
- [ ] Confirmed the context and Ready nodes (Screenshot 1)
- [ ] Created and selected the book-review namespace
- [ ] Inspected the application repository
- [ ] Prepared images accessible to the cluster
- [ ] Confirmed Helm if using charts (Screenshot 2, conditional)
- [ ] Created the architecture diagram (Screenshot 3)
- [ ] Created ConfigMaps and Secrets (Screenshots 4–5)
- [ ] Excluded actual Secret values from Git and screenshots
- [ ] Provisioned private managed MySQL or persistent Kubernetes MySQL (Screenshot 6)
- [ ] Initialized the required database and schema
- [ ] Verified database connectivity or schema (Screenshot 7)
- [ ] Deployed one or two backend replicas listening on port 3001
- [ ] Created the backend ClusterIP Service (Screenshot 8)
- [ ] Verified backend-to-database connectivity (Screenshot 9)
- [ ] Deployed one or two frontend replicas behind Nginx (Screenshot 10)
- [ ] Configured API proxying through the internal backend Service (Screenshot 11)
- [ ] Configured and documented frontend access (Screenshot 12)
- [ ] Enforced backend access restrictions (Screenshot 13)
- [ ] Confirmed that the backend and database are not publicly exposed
- [ ] Captured resource status for book-review (Screenshot 14)
- [ ] Tested application functionality and database writes (Screenshots 15 and 17)
- [ ] Verified saved data after application restart
- [ ] Captured frontend and backend logs (Screenshots 16–17)
- [ ] Included optional dashboard or improvement evidence if attempted (Screenshots 18–19)
- [ ] Published the LinkedIn post (Screenshot 20)
- [ ] Included the LinkedIn post URL
- [ ] Documented issues, fixes, and useful sources
- [ ] Recorded cleanup status or reuse plans
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

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*

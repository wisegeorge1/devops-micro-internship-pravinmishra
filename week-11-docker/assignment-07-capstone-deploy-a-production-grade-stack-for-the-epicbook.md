# Assignment 7 — Capstone: Deploy a Production-Grade Stack for The EpicBook

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook application as a production-oriented Docker Compose stack on a cloud VM. You will use optimized container images, isolated networks, health checks, persistent MySQL storage, a selected reverse proxy, logging, backup and restore testing, and reliability procedures.

---

# Task 0 — App Discovery and Architecture

## Goal

Review the EpicBook repository and design the intended application architecture.

### Evidence

#### Screenshot 1 — EpicBook Project Structure

Add a terminal screenshot showing the EpicBook project structure after cloning the repository.

![ss1](/week-11-docker/screenshots/Ass-7-SS1.png)

---

#### Screenshot 2 — Architecture Diagram

Add a screenshot of your architecture diagram showing:

- Public user
- Reverse proxy
- Frontend
- Backend
- Database
- Docker networks
- Public and private ports
- Persistent database storage

Add your full name inside the diagram or as a clear caption below it.

![ss2](/week-11-docker/screenshots/Ass-7-SS2.png)

---

#### Screenshot 3 — Environment Variables and Ports Document

Add a screenshot showing the contents of:

```text
docs/02-env-and-ports.md
```

It must document environment-variable names, internal ports, persistent-data details, and the health-check method. Do not expose real credentials or values.

![ss3](/week-11-docker/screenshots/Ass-7-SS3.png)

---

# Task 1 — Create Production Docker Images

## Goal

Create optimized production images for the EpicBook backend and frontend.

### Evidence

#### Screenshot 4 — Backend Dockerfile

Add a screenshot showing `backend/Dockerfile`, including:

- Dependency stage
- Minimal runtime stage
- Production startup command
- Internal backend port
- Non-root user configuration

![ss4](/week-11-docker/screenshots/Ass-7-SS4.png)

---

#### Screenshot 5 — Frontend Dockerfile

Add a screenshot showing `frontend/Dockerfile`, including:

- Nginx runtime image
- Static frontend files copied to the Nginx web root

![ss5](/week-11-docker/screenshots/Ass-7-SS5.png)

---

#### Screenshot 6 — Docker Ignore Files

Add a screenshot showing both:

```text
backend/.dockerignore
frontend/.dockerignore
```

![ss6](/week-11-docker/screenshots/Ass-7-SS6.png)

---

#### Screenshot 7 — Docker Image Builds and Size Comparison

Add a terminal screenshot showing successful builds of:

- Baseline backend image
- Optimized backend image
- Frontend image

The screenshot must also show the baseline and optimized backend image-size comparison.

![ss7](/week-11-docker/screenshots/Ass-7-SS7.png)

---

#### Screenshot 8 — Backend Running as Non-Root User

Add a terminal screenshot showing the optimized backend container running as a non-root user.

![ss8](/week-11-docker/screenshots/Ass-7-SS8.png)

---

### Notes

Write a short note covering:

- Baseline and optimized backend image sizes
- The image-size reduction achieved
- One Docker layer-caching optimization used
- The security benefit of running the backend as a non-root user

 1. The baseline backend Docker image was 1,680.22 MB, while the optimized backend image was 230.03 MB.
 2. The image size reduction achieved is 86.31%, saving approximately 1.45 GB.
 3. One Docker layer caching optimization used was copying package.json and the lockfile before copying application source code. 
    This allows Docker to reuse the dependency installation layer when application code changes, reducing rebuild time.
 4. Running the backend as a non-root user improves security by limiting the privileges available to the application inside the 
    container, reducing the potential impact of a security breach.

---

# Task 2 — Create the Docker Compose Stack and Networks

## Goal

Create one Docker Compose stack containing the reverse proxy, frontend, backend, and MySQL database.

### Evidence

#### Screenshot 9 — Docker Compose Services

Add a screenshot showing `docker-compose.yml` with all four services:

```text
reverse-proxy
frontend
backend
database
```

![ss9](/week-11-docker/screenshots/Ass-7-SS9.png)

---

#### Screenshot 10 — Networks and Named Volume

Add a screenshot showing:

- `front-tier` network
- `back-tier` network
- `db_data` named volume

![ss10](/week-11-docker/screenshots/Ass-7-SS10.png)

---

#### Screenshot 11 — Docker Compose Validation

Add a terminal screenshot showing successful Docker Compose validation without exposing environment-variable values or secrets.

![ss11](/week-11-docker/screenshots/Ass-7-SS11.png)

---

# Task 3 — Configure Health Checks and Startup Dependencies

## Goal

Configure health checks and ensure services start only after their dependencies are healthy.

### Evidence

#### Screenshot 12 — Backend Health Endpoint

Add a screenshot showing the backend application configuration for the `/health` endpoint.

![ss12](/week-11-docker/screenshots/Ass-7-SS12.png)

---

#### Screenshot 13 — MySQL and Backend Health Checks

Add a screenshot showing `docker-compose.yml` with health checks for MySQL and the backend.

![ss13](/week-11-docker/screenshots/Ass-7-SS13.png)

---

#### Screenshot 14 — Frontend and Reverse-Proxy Health Checks

Add a screenshot showing:

- Frontend health check
- Reverse-proxy health check
- `depends_on` conditions using `service_healthy`

![ss14](/week-11-docker/screenshots/Ass-7-SS14.png)

---

#### Screenshot 15 — Running Healthy Services

Add a terminal screenshot showing Docker Compose service status. The database, backend, frontend, and reverse proxy must be running successfully.

![ss15](/week-11-docker/screenshots/Ass-7-SS15.png)

---

#### Screenshot 16 — Public Health Endpoint

Add a terminal screenshot showing a successful response from the public application health endpoint through the reverse proxy.

![ss16](/week-11-docker/screenshots/Ass-7-SS16.png)

---

#### Screenshot 17 — Health-Check and Startup-Order Document

Add a screenshot showing the contents of:

```text
docs/03-healthchecks-and-depends-on.md
```

Explain the health-check method for each service and the startup dependency order.

![ss17](/week-11-docker/screenshots/Ass-7-SS17.png)

---

# Task 4 — Configure the Reverse Proxy and Same-Origin Routing

## Goal

Use either Nginx or Traefik as the only public entry point for the EpicBook application.

### Evidence

#### Screenshot 18 — Selected Reverse-Proxy Configuration

Add a screenshot showing the configuration for your selected reverse proxy.

It must show routes for:

- Static frontend assets
- Application pages
- API requests
- Health endpoint

![ss18](/week-11-docker/screenshots/Ass-7-SS18.png)

---

#### Screenshot 19 — Only Reverse Proxy Publishes Port 80

Add a screenshot of `docker-compose.yml` showing that only the `reverse-proxy` service publishes port 80.

![ss19](/week-11-docker/screenshots/Ass-7-SS19.png)

---

#### Screenshot 20 — Reverse-Proxy Route Testing

Add a terminal screenshot showing successful requests through the selected reverse proxy to:

- Application page
- One API endpoint
- One static asset
- Health endpoint

![ss20](/week-11-docker/screenshots/Ass-7-SS20.png)

---

#### Screenshot 21 — EpicBook Application Through Public IP

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![ss21](/week-11-docker/screenshots/Ass-7-SS21.png)

---

#### Screenshot 22 — Proxy Routing and CORS Document

Add a screenshot showing the contents of:

```text
docs/04-proxy-routing-and-cors.md
```

Explain the proxy routes and state whether CORS was required and why.

![ss22](/week-11-docker/screenshots/Ass-7-SS22.png)

---

# Task 5 — Prove Data Persistence, Backup, and Restore

## Goal

Verify MySQL persistence and perform a controlled backup and restore drill.

### Evidence

#### Screenshot 23 — MySQL Volume Configuration

Add a terminal screenshot showing the `db_data` named volume and its MySQL mount configuration.

![ss23](/week-11-docker/screenshots/Ass-7-SS23.png)

---

#### Screenshot 24 — Test Data Before Backup

Add a terminal screenshot showing the selected test data before the backup and restore drill.

![ss24](/week-11-docker/screenshots/Ass-7-SS24.png)

---

#### Screenshot 25 — Successful Backup Creation

Add a terminal screenshot showing successful backup creation and the backup file stored in the host backup directory.

![ss25](/week-11-docker/screenshots/Ass-7-SS25.png)

---

#### Screenshot 26 — Controlled Data-Loss Test

Add a terminal screenshot showing that the selected test record was removed during the controlled data-loss test.

![ss26](/week-11-docker/screenshots/Ass-7-SS26.png)

---

#### Screenshot 27 — Restore Verification

Add a terminal screenshot showing successful restore and verification that the deleted test record is available again.

![ss27](/week-11-docker/screenshots/Ass-7-SS27.png)

---

#### Screenshot 28 — Persistence After Down/Up Cycle

Add a terminal screenshot showing that database data remains available after a non-destructive Docker Compose down/up cycle.

Do not use `docker compose down -v`.

![ss28](/week-11-docker/screenshots/Ass-7-SS28.png)

---

#### Screenshot 29 — Persistence and Backup Document

Add a screenshot showing the contents of:

```text
docs/05-persistence-and-backup.md
```

Include the backup plan and restore procedure.

![ss29](/week-11-docker/screenshots/Ass-7-SS29a.png)
![ss29](/week-11-docker/screenshots/Ass-7-SS29b.png)

---

# Task 6 — Configure Logging and Observability

## Goal

Configure useful reverse-proxy and backend logs without exposing sensitive information.

### Evidence

#### Screenshot 30 — Logging Configuration

Add a screenshot showing:

- Configuration for the selected reverse proxy
- Proxy log format
- Docker Compose host log-directory bind mount

![ss30](/week-11-docker/screenshots/Ass-7-SS30.png)

---

#### Screenshot 31 — Persistent Proxy Logs and Backend Logs

Add a terminal screenshot showing:

- Selected reverse-proxy logs available from the host directory after a proxy restart
- Backend logs displayed through Docker Compose

![ss31](/week-11-docker/screenshots/Ass-7-SS31.png)

---

### Notes

Write a short note covering:

- The selected reverse proxy
- Host path used for reverse-proxy logs
- How backend logs are viewed
- Whether JSON or standard text logs were used
- Why passwords, tokens, headers, and database connection strings must not appear in logs

- Selected reverse proxy: Nginx, running in a Docker container, serves as the only public entry point on TCP port 80 and routes requests to the frontend and backend services.

- Host path for reverse-proxy logs: logs/nginx/, intended to store persistent Nginx access and error logs on the host so they remain available after a proxy container restart, provided the directory is correctly bind-mounted and configured in Nginx.

- Backend log access: Backend logs are viewed using Docker Compose, for example, docker compose logs --tail=50 backend. Live logs can be monitored using docker compose logs -f backend.

- Log format: Standard text logs are used for straightforward viewing and troubleshooting. JSON-formatted logs were not specified in the current configuration.

- Protection of sensitive information: Passwords, authentication tokens, authorization headers, cookies, and database connection strings must never appear in logs. Logging these values could expose credentials, enable unauthorized access, compromise user sessions, and disclose sensitive infrastructure details. Logs should record only the information necessary for monitoring, troubleshooting, and security auditing, with sensitive values excluded or redacted.

---

# Task 7 — Deploy and Verify the Stack on a Cloud VM

## Goal

Deploy the completed Docker Compose stack on an AWS or Azure VM and verify public access.

### Evidence

#### Screenshot 32 — VM Public IP and Inbound Rules

Add a cloud-console screenshot showing:

- VM public IP address
- SSH port 22 restricted to your IP address
- HTTP port 80 allowed from Anywhere

![ss32](/week-11-docker/screenshots/Ass-7-SS32.png)

---

#### Screenshot 33 — Cloud VM Stack Verification

Add a VM terminal screenshot showing:

- Docker Compose service status
- Successful public health or API response
- No published database, frontend, or backend ports

![ss33](/week-11-docker/screenshots/Ass-7-SS33.png)

---

#### Screenshot 34 — EpicBook Application on Cloud VM

Add a browser screenshot showing the EpicBook application loaded through the VM public IP address.

Add your full name as a clear caption below the screenshot.

![ss34](/week-11-docker/screenshots/Ass-7-SS34.png)

---

### Notes

Write a short note covering:

- Cloud provider used
- VM operating system
- Public port exposed
- Security rules configured
- Confirmation that the application and backend API worked through the reverse proxy

Cloud Provider: Microsoft Azure, using an Azure Virtual Machine (VM).

VM Operating System: Ubuntu Linux.

Public Port Exposed: TCP port 80 (HTTP), serving as the single public entry point through the Nginx reverse proxy.

Security Rules Configured: Azure Network Security Group (NSG) rules allow inbound HTTP traffic on TCP port 80. Backend (8080), frontend (80), and database (3306) ports are not published directly to the host. Internal communication between Docker services occurs over the Docker network.

Application and Backend API Verification: The application and backend API are designed to be accessed through the Nginx reverse proxy using the same public origin. Successful operation should be confirmed by checking the public health endpoint and API responses.

---

# Task 8 — Automate Deployment with CI/CD (Optional)

## Goal

Optionally automate image build, image push, and deployment through GitHub Actions or Azure Pipelines.

### Optional Evidence

#### Optional Screenshot — Successful CI/CD Pipeline Run

Add a screenshot showing a successful pipeline run with build, image push, deployment, and verification stages.

![ci/cd-pipeline](/week-11-docker/screenshots/ci-cd-pipeline.png)

---

### Optional Notes

Write a short note covering:

- CI/CD platform used
- Image-tagging method
- Registry used
- Deployment trigger
- Manual approval or secret-handling approach

EpicBook CI/CD Pipeline Summary
 1. CI/CD Platform: Azure DevOps Pipelines automates building, pushing, deploying, and verifying the EpicBook application.

 2. Image-Tagging Method: Docker images are tagged with the Azure DevOps Build.BuildId for version tracking and latest for the 
    most recent build.
 
 3. Container Registry: Docker Hub stores the backend and frontend images.
 
 4. Deployment Trigger: The pipeline automatically runs when changes are pushed to the capstone/theepicbook-docker branch, 
    provided the changes affect the configured backend, frontend, proxy, Docker Compose, or pipeline files.
 
 5. Manual Approval and Secret Handling: Docker Hub credentials and the Azure VM SSH password are stored as secret variables in 
    the Epicbook-docker-secrets Azure DevOps variable group. The pipeline uses these secrets through environment variables. No manual approval stage is currently configured.

---

# Task 9 — Perform Reliability Tests and Create an Operations Runbook

## Goal

Test controlled service failures and document safe operating procedures.

### Evidence

#### Screenshot 35 — Backend Failure and Recovery

Add a terminal screenshot showing:

- Backend failure test
- Expected unavailable response through the reverse proxy
- Backend restart
- Successful health-check recovery

![ss35](/week-11-docker/screenshots/Ass-7-SS35.png)

---

#### Screenshot 36 — Database Failure and Recovery

Add a terminal screenshot showing:

- Database outage test
- Failed database-dependent request
- Database restart
- Successful application recovery

![ss36](/week-11-docker/screenshots/Ass-7-SS36.png)

---

### Notes

Write a short operations runbook covering:

- Safe restart procedure for reverse proxy, frontend, backend, and database
- Backup and restore procedure
- Secret-rotation approach
- Database recovery procedure
- What to check when the application returns an error
- Results of backend and database reliability tests


# EpicBook Operations Runbook

**Platform:** Microsoft Azure\
**Deployment:** Docker Compose\
**Reverse Proxy:** Nginx\
**Container Registry:** Docker Hub\
**Project Directory:** `/home/azureuser/theepicbook-2`

## 1\. Safe Restart Procedure

Connect to the Azure VM using SSH, then navigate to the project directory:

```
cd /home/azureuser/theepicbook-2
docker compose ps
```

Restart individual services in the following order when required:

```
# Restart the database only when necessary
docker compose restart database

# Restart the backend API
docker compose restart backend

# Restart the frontend
docker compose restart frontend

# Restart the Nginx reverse proxy
docker compose restart proxy
```

Replace `database` or `proxy` with the actual service names defined in `docker-compose.yml`. Check container health and application availability after each restart.

```
docker compose ps
curl -i http://172.177.134.11/health
```

Avoid restarting the database unnecessarily because it may interrupt active requests and transactions.

## 2\. Backup and Restore Procedure

Back up the database regularly and store backups outside the VM. The exact commands depend on the database engine.

for example:

```
docker compose exec -T database \
  pg_dump -U "$DB_USER" "$DB_NAME" \
  > "epicbook-backup-$(date +%F).sql"
```

Protect the backup file and transfer it to secure external storage. Confirm that the backup is non-empty and periodically test restoring it into a separate database.

Example restore:

```
cat epicbook-backup-YYYY-MM-DD.sql | \
  docker compose exec -T database \
  psql -U "$DB_USER" "$DB_NAME"
```

**Warning:** A restore can overwrite or conflict with existing data. Restore into a separate database first when possible, and verify the target before performing a production restore.

## 3\. Secret-Rotation Approach

Store Docker Hub credentials and VM SSH credentials in the Azure DevOps Library variable group `Epicbook-docker-secrets`, marking sensitive values as secret.

- Generate replacement credentials before revoking the old ones.
- Update the Azure DevOps secret variables.
- Update the VM's Docker credentials if the Docker Hub token changes.
- Test authentication and deployment using the new credentials.
- Revoke the old credentials and review access permissions.

Never commit passwords, tokens, or database credentials to source control or print them in pipeline logs. Prefer SSH keys and short lived or narrowly scoped credentials where supported.

## 4\. Database Recovery Procedure

1. Check the database container status and logs:```
   docker compose ps
   docker compose logs --tail=100 database
   ```
2. Check disk space and available memory:```
   df -h
   free -m
   ```
3. Check the database health and connection settings.
4. Restart the database only after identifying the likely cause:```
   docker compose restart database
   ```
5. If data corruption or loss is suspected, stop potentially destructive operations and preserve the database volume before 
   attempting recovery.
6. Restore the most recent verified backup into an appropriate database instance, validate the data, and reconnect the backend.
7. Verify database connectivity, application functionality, and health endpoints.

Do not delete database volumes or run destructive cleanup commands during recovery.

## 5\. Application Error Troubleshooting

When the application returns an error:

- **HTTP 502/503:** Check Nginx logs, backend container status, backend startup logs, and service networking.
- **HTTP 500:** Inspect backend logs and investigate application exceptions, database queries, and configuration.
- **Database connection errors:** Verify database availability, credentials, network connectivity, and connection settings.
- **Application unavailable:** Confirm the VM is running, port 80 is reachable, and the Nginx configuration is valid.
- **Deployment failure:** Review Azure DevOps logs, Docker Hub authentication, image tags, and Compose configuration.

Useful diagnostic commands:

```
docker compose ps -a
docker compose logs --tail=100 backend
docker compose logs --tail=100 frontend
docker compose logs --tail=100 proxy
docker compose logs --tail=100 database
docker compose config --quiet
curl -i http://172.177.134.11/health
```

## 6\. Reliability Test Results

**Backend reliability test:** The test procedure terminates the backend's main process, checks the reverse proxy response, inspects container restart behaviour, and verifies recovery through the `/health` endpoint. Successful recovery is demonstrated when the backend restarts and the health endpoint returns HTTP 200.

**Database reliability test:** Database reliability should be evaluated by simulating an approved database interruption, verifying that the backend detects connection failures, checking database restart or recovery, and confirming that stored data remains consistent.

Record the actual test date, observed responses, restart counts, data-integrity checks, and final PASS/FAIL status for each test. Results must be taken from completed test logs; they should not be reported as successful without evidence.

## 7\. Post-Recovery Verification

After any restart or recovery operation:

```
docker compose ps
curl -f http://172.177.134.11/health
curl -I http://172.177.134.11/
```

Confirm that all required services are running, the application is reachable, the backend health check succeeds, and database-backed functionality works. Document the incident, corrective action, and verification results.

Important: This runbook assumes a Docker Compose service named `database` and uses MySQL as an illustrative backup example. Confirm your actual database engine, Compose service names, and backup configuration before using the commands in production.

---

# Final Public Application URL

**EpicBook URL:** `http://172.177.134.11`

Replace the placeholder with your working public URL.

---

# GitHub Repository URL

**Your Fork or Repository URL:** `https://github.com/wisegeorge1/theepicbook-2.git`

---

# LinkedIn Requirement

## Goal

Create a professional LinkedIn post of 6–10 lines about your EpicBook capstone deployment.

Your post must include:

- The architectural decision that most improved reliability
- Your biggest image-size reduction, with numbers
- Key production-hardening lessons
- A deployment verification image

### Evidence

**LinkedIn Post URL:** `<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7517220681663815680-7VEf/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>`

#### LinkedIn Post Screenshot

![linkedin](/week-11-docker/screenshots/Ass-7-SS37-linkedin.png)

---

# Submission Checklist

- [ ] EpicBook repository reviewed and architecture diagram created
- [ ] Environment variables, ports, persistence, and health-check details documented
- [ ] Backend and frontend production Dockerfiles created
- [ ] Backend runs as a non-root user
- [ ] Docker image-size comparison completed
- [ ] Docker Compose stack includes reverse proxy, frontend, backend, and database
- [ ] `front-tier` and `back-tier` networks configured
- [ ] `db_data` named volume configured
- [ ] MySQL, backend, frontend, and reverse-proxy health checks configured
- [ ] Startup dependencies use `service_healthy`
- [ ] Nginx or Traefik selected as the only public reverse proxy
- [ ] Only reverse-proxy port 80 is publicly published
- [ ] Same-origin routing configured and CORS used only when required
- [ ] Backup, restore, and persistence testing completed
- [ ] Reverse-proxy and backend logs verified
- [ ] Cloud VM deployment verified through the public IP
- [ ] Backend and database reliability tests completed
- [ ] Screenshots 1–36 included
- [ ] Required notes completed
- [ ] LinkedIn post URL and screenshot included
- [ ] Full name visible in required screenshots or captions
- [ ] No passwords, tokens, private keys, account IDs, or other sensitive information exposed

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

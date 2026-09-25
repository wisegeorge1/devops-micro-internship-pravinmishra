# Assignment 5 — Production-Grade EpicBook: Terraform + Ansible Roles (Azure or AWS)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will deploy the EpicBook web application on a cloud VM provisioned with Terraform (Azure or AWS — pick one) and configured through reusable Ansible roles (`common`, `nginx`, `epicbook`) orchestrated by one playbook, using group variables, templates, and handlers, with a verified idempotent second run.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `epicbook-prod` project with `terraform/azure` or `terraform/aws`, `ansible/inventory.ini`, `ansible/site.yml`, `ansible/group_vars/web.yml`, and the `common`, `nginx`, and `epicbook` role directories.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `epicbook-prod` project tree

![project-tree](/week-09-ansible/screenshots/ASS-5-SS-1.png)

---

# Task 2 — Terraform (Pick One: Azure or AWS)

## Goal

Provision one secure Ubuntu 22.04 VM with SSH key authentication, inbound SSH (22) and HTTP (80), and `public_ip`/`admin_user` outputs, on your chosen cloud.

### Evidence

#### Screenshot 2 — Terminal showing successful `terraform apply` and `terraform output` with `public_ip` and `admin_user`

![terraform-apply-successful](/week-09-ansible/screenshots/ASS-5-SS-2.png)

---

#### Screenshot 3 — Terraform code or cloud console showing inbound rules for ports 22 and 80

![cloud-console](/week-09-ansible/screenshots/ASS-5-SS-3.png)

---

# Task 3 — Ansible Inventory

## Goal

Create the `[web]` inventory using the Terraform `public_ip` and `admin_user` outputs, and verify passwordless SSH and `ansible ping`.

### Evidence

#### Screenshot 4 — Terminal showing the successful passwordless SSH hostname check

![passwordless-check](/week-09-ansible/screenshots/ASS-5-SS-4.png)

---

#### Screenshot 5 — Editor or terminal showing `inventory.ini` and a successful Ansible ping

![successful-ping](/week-09-ansible/screenshots/ASS-5-SS-5.png)

---

# Task 4 — Create site.yml (Role Orchestration)

## Goal

Create `site.yml` invoking the `common`, `nginx`, and `epicbook` roles in that exact order.

### Evidence

#### Screenshot 6 — Editor showing `ansible/site.yml` with the three roles in the required order

![site.yml](/week-09-ansible/screenshots/ASS-5-SS-6.png)

---

# Task 5 — Role: common

## Goal

Create `roles/common/tasks/main.yml` to update apt, upgrade packages, install baseline packages (`git`, `curl`, `unzip`, `software-properties-common`), with optional SSH hardening applied only after key-based access is confirmed.

### Evidence

#### Screenshot 7 — Editor showing `roles/common/tasks/main.yml`

![roles/common/tasks/main.yml](/week-09-ansible/screenshots/ASS-5-SS-7.png)

---

# Task 6 — Role: nginx

## Goal

Create the `nginx` role to install Nginx, deploy the `epicbook.conf.j2` template to `/etc/nginx/sites-available/epicbook`, enable the site, remove the default site, and reload via handler.

### Evidence

#### Screenshot 8 — Editor showing the Nginx role tasks, handler, and `epicbook.conf.j2` template

![ass-5-ss8](/week-09-ansible/screenshots/ASS-5-SS-8.png)

---

#### Screenshot 9 — Terminal showing `/etc/nginx/sites-available/epicbook` and a successful Nginx configuration test

![ass-5-ss9](/week-09-ansible/screenshots/ASS-5-SS-9.png)

---

# Task 7 — Role: epicbook

## Goal

Create the `epicbook` role to clone the repository to `{{ app_dest }}`, set ownership/permissions using group variables, and notify the Nginx reload handler on change.

### Evidence

#### Screenshot 10 — Editor showing `roles/epicbook/tasks/main.yml`

![ass-5-ss10](/week-09-ansible/screenshots/ASS-5-SS-10.png)

---

# Task 8 — Group Variables

## Goal

Define `app_repo`, `app_dest`, `app_user`, and `app_group` in `ansible/group_vars/web.yml`.

### Evidence

#### Screenshot 11 — Editor showing `ansible/group_vars/web.yml`

![ass-5-ss11](/week-09-ansible/screenshots/ASS-5-SS-11.png)

---

# Task 9 — Run the Playbook

## Goal

Run `ansible-playbook -i inventory.ini site.yml` and confirm `common` → `nginx` → `epicbook` all complete with `failed=0`.

### Evidence

#### Screenshot 12 — Terminal showing the role-based Ansible run and final recap with `failed=0`

![ass-5-ss12](/week-09-ansible/screenshots/ASS-5-SS-12.png)

---

# Task 10 — Verify

## Goal

Confirm the EpicBook site loads with HTTP 200, inspect the Nginx configuration, and rerun the playbook to confirm the second run is mostly OK/UNCHANGED with `failed=0`.

### Evidence

#### Screenshot 13 — Browser showing the EpicBook site with the public IP visible

![ass-5-ss13](/week-09-ansible/screenshots/ASS-5-SS-13.png)

---

#### Screenshot 14 — Terminal showing HTTP 200 and the Nginx site-file snippet

![ass-5-ss14](/week-09-ansible/screenshots/ASS-5-SS-14.png)

---

#### Screenshot 15 — Terminal showing the idempotent second Ansible run with mostly OK/UNCHANGED and `failed=0`

![ass-5-ss15](/week-09-ansible/screenshots/ASS-5-SS-15.png)

---

### Notes

Describe an issue you faced and how you fixed it, what you learned, any security issues you identified, and your production remediation plan.

EpicBook Production Deployment — DevOps Incident Report

 ## 1\. Incident Summary

 During the EpicBook production deployment, the application deployment encountered multiple failures across the configuration-management, secrets-management, database, and reverse-proxy layers.

 The primary issues were:

 1. Ansible privilege escalation failed because the target host's `chmod` implementation did not support the ACL syntax generated by Ansible.
2. Ansible Vault variables could not be decrypted because no Vault secret was supplied.
3. Database initialization initially targeted an incorrect database provider/endpoint.
4. Once the correct AWS RDS endpoint was configured, the schema import failed because the database had already been initialized and the `Author` table existed.
5. The Node.js/Express application was healthy on port `8080`, but Nginx was serving its default static page instead of proxying requests to the application.
6. Public HTTP requests therefore returned the Nginx welcome page or Nginx-generated `404` responses even though the backend application itself was operational.

 The investigation ultimately demonstrated that the individual infrastructure components were functional, but the deployment configuration was inconsistent between environments and the deployment process was not sufficiently idempotent.

---

 # 2\. Environment

 ### Application

- Application: EpicBook
- Runtime: Node.js / Express
- Application directory: `/opt/epicbook`
- Application port: `8080`
- Process manager: PM2
- Reverse proxy: Nginx
- Operating system: Ubuntu 24.04 LTS

 ### Database

- Engine: MySQL 8.0
- Database: `bookstore`
- Database user: `epicbookadmin`
- Production database: AWS RDS
- Port: `3306`

 ### Configuration Management

- Ansible
- Ansible Vault
- Role-based deployment structure
- Environment-specific `group_vars`

---

 # 3\. Impact

 The deployment could not initially complete successfully, and the production application was not accessible through the expected HTTP endpoint.

 The backend Node.js process was running and responding successfully on localhost:

```
HTTP/1.1 200 OK
X-Powered-By: Express
```

 However, external requests were being handled by Nginx's default server configuration rather than the EpicBook reverse-proxy configuration.

 As a result:

```
GET /
```

returned the default Nginx welcome page, while:

```
GET /cart
GET /health
```

returned HTTP 404 responses.

 The database was reachable and operational, but the Ansible database initialization workflow was not idempotent and attempted to recreate an existing schema.

---

 # 4\. Timeline and Investigation

 ## 4.1 Ansible privilege escalation failure

 The first deployment failure was:

```
Failed to set permissions on the temporary files Ansible needs to create
when becoming an unprivileged user
```

 with:

```
chmod: invalid mode:
'A+user:epicbook:rx:allow'
```

 Ansible was attempting to create temporary module files while becoming the unprivileged `epicbook` account. The target system's `chmod` implementation did not accept the ACL syntax generated by Ansible.

 ### Resolution

 The deployment approach was adjusted so that Ansible did not depend on the incompatible unprivileged-user temporary-file permission mechanism.

 This allowed the deployment to proceed to subsequent tasks.

---

 # 5\. Ansible Vault Failure

 The next failure occurred while rendering:

```
environment:
  MYSQL_PWD: "{{ db_password }}"
```

 Ansible reported:

```
Attempt to use undecryptable variable:
Decryption failed (no vault secrets were found that could decrypt)
```

 The variable originated from:

```
group_vars/web/vault.yml
```

 where the database password was stored as an encrypted Ansible Vault variable.

 ### Root Cause

 The playbook was executed without providing the Vault secret.

 ### Resolution

 The deployment was executed with the appropriate Vault password:

```
ansible-playbook ... --ask-vault-pass
```

 This allowed Ansible to decrypt `vault_db_password` and resolve `db_password`.

 ### Lesson

 Secret encryption at rest is only effective if the runtime deployment process has a controlled mechanism for securely supplying the decryption secret.

---

 # 6\. Database Connectivity Investigation

 The database import initially failed with a generic non-zero exit code.

 To isolate the problem, database connectivity was tested directly from the application server.

 A local MySQL check returned:

```
Can't connect to local MySQL server through socket
'/var/run/mysqld/mysqld.sock'
```

 This was not the production database failure; it simply demonstrated that no local MySQL daemon was running.

 A direct connection to the RDS instance succeeded:

```
mysql \
  -h epicbook-w6pww5-mysql.ckp6c68m8aq6.us-east-1.rds.amazonaws.com \
  -u epicbookadmin \
  -p
```

 The connection returned:

```
Server version: 8.0.46
```

 The database list confirmed:

```
bookstore
information_schema
mysql
performance_schema
sys
```

 Therefore:

 - DNS/network connectivity was functional.
- TCP/3306 connectivity was functional.
- MySQL was operational.
- Database authentication worked.
- The `bookstore` database existed.

---

 # 7\. Database Configuration Drift

 The next investigation inspected the variables actually resolved by Ansible.

 Ansible reported:

```
db_host: epicbook-mysql-hcljuw.mysql.database.azure.com
db_port: 3306
db_user: epicbookadmin
db_name: bookstore
app_dest: /opt/epicbook
```

 However, the database manually verified as operational was:

```
epicbook-w6pww5-mysql.ckp6c68m8aq6.us-east-1.rds.amazonaws.com
```

 This revealed an environment configuration mismatch:

```
Ansible configuration
        |
        +--> Azure MySQL

Manual production validation
        |
        +--> AWS RDS MySQL
```

 ### Root Cause

 Environment-specific database configuration had drifted. The `db_host` variable referenced an Azure MySQL endpoint while the intended production database was hosted on AWS RDS.

 ### Resolution

 The `db_host` variable was corrected to the AWS RDS endpoint.

 The exact Ansible-generated database command was then:

```
mysql \
  --protocol=tcp \
  --host=epicbook-w6pww5-mysql.ckp6c68m8aq6.us-east-1.rds.amazonaws.com \
  --port=3306 \
  --user=epicbookadmin \
  --password="$MYSQL_PWD" \
  bookstore \
  < /opt/epicbook/db/BuyTheBook_Schema.sql
```

---

 # 8\. Database Schema Initialization Failure

 After correcting the database endpoint, the schema import failed with:

```
ERROR 1050 (42S01) at line 16:
Table 'Author' already exists
```

 The database connection itself was therefore successful.

 The manual schema import had already been performed successfully, meaning the database now contained the schema.

 The Ansible task contained:

```
when: not database_initialized.stat.exists
```

 This indicates that Ansible uses a filesystem marker to determine whether database initialization has already occurred.

 ### Root Cause

 The database state and the Ansible initialization state were inconsistent.

 The database had already been initialized, but the marker used by Ansible indicated that initialization had not occurred.

 This caused Ansible to attempt to import the schema again.

 ### Technical Finding

 The deployment mechanism was relying on a filesystem state marker to represent external database state.

 That creates a state-management problem:

```
Filesystem state:
database_initialized = false

Actual database state:
schema already exists
```

 The two states diverged.

 ### Recommended Resolution

 Database initialization should be replaced or supplemented with a proper migration/versioning mechanism.

 For example:

```
migration_001
migration_002
migration_003
...
```

 or a schema-version table:

```
CREATE TABLE schema_migrations (
    version VARCHAR(50) PRIMARY KEY,
    applied_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

 This allows the deployment system to determine database state from the database itself rather than relying exclusively on a local marker file.

---

 # 9\. Application Health Investigation

 After database troubleshooting, the HTTP layer was investigated.

 The application was confirmed to be listening on port `8080`:

```
sudo ss -ltnp
```

 showed:

```
*:8080
users:(("node /opt/epicb",...))
```

 A direct request succeeded:

```
curl -I http://127.0.0.1:8080
```

 Response:

```
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html
```

 This proved:

 - Node.js was running.
- Express was running.
- The application was listening on the expected port.
- The application could serve HTTP requests locally.

 PM2 was also available, although the PM2 process list did not show a managed application at the time of inspection.

---

 # 10\. Nginx Investigation

 Nginx configuration syntax was valid:

```
nginx -t
```

 returned:

```
syntax is ok
test is successful
```

 Nginx was running:

```
Active: active (running)
```

 The intended EpicBook configuration contained:

```
server {
    listen 80;
    listen [::]:80;

    server_name 13.221.29.192;

    location / {
        proxy_pass http://127.0.0.1:8080;
        ...
    }
}
```

 However, the public endpoint returned:

```
HTTP/1.1 200 OK
Server: nginx/1.24.0
```

 with the standard:

```
Welcome to nginx!
```

 page.

 This was a critical diagnostic signal.

 If the EpicBook proxy configuration were active, the request should have been forwarded to Express, whose response included:

```
X-Powered-By: Express
```

 Instead, Nginx was serving its default static page.

 ### Root Cause

 The EpicBook Nginx server configuration existed under:

```
/etc/nginx/sites-available/epicbook
```

 but was not the active server configuration handling the request, most likely because the default Nginx site remained enabled or the EpicBook site was not correctly linked into `sites-enabled`.

 ### Correct Nginx architecture

 The intended request path is:

```
Internet
   |
   v
Nginx :80
   |
   v
127.0.0.1:8080
   |
   v
Node.js / Express
   |
   v
AWS RDS MySQL
```

 The observed request path was effectively:

```
Internet
   |
   v
Nginx :80
   |
   v
Default Nginx site
```

 while the application itself remained healthy on port 8080.

---

 # 11\. Security Findings

 ## 11.1 Secrets exposure

 The database password was correctly stored using Ansible Vault, but the deployment required the Vault secret at runtime.

 Production remediation should ensure:

 - Vault passwords are not committed to Git.
- Vault passwords are not stored in shell history.
- Sensitive Ansible tasks use `no_log: true`.
- Database passwords are not exposed through command-line arguments.
- CI/CD systems use a dedicated secret-management mechanism.

 The MySQL command produced:

```
mysql: [Warning] Using a password on the command line interface can be insecure.
```

 The preferred production design is to avoid exposing credentials through command-line arguments.

 ## 11.2 Public attack surface

 Nginx access logs showed unsolicited internet scanning requests, including requests targeting:

```
/cgi-bin/
```

 and attempts to execute commands through vulnerable router endpoints.

 These requests did not indicate a successful compromise, but they demonstrate that the public EC2 instance is continuously exposed to automated internet scanning.

 ## 11.3 Backend port exposure

 The Node application was listening on:

```
*:8080
```

 rather than only:

```
127.0.0.1:8080
```

 If the AWS Security Group permits inbound traffic to port 8080, the application could potentially be accessed directly while bypassing Nginx.

 Production controls should restrict inbound access to 8080 and ideally bind the application to localhost.

 ## 11.4 HTTP instead of HTTPS

 The current public endpoint uses HTTP:

```
http://PUBLIC_IP
```

 Production traffic should use TLS with HTTPS and redirect HTTP to HTTPS.

 ## 11.5 Default Nginx configuration

 Leaving the default Nginx site enabled created an operational and security concern because it obscured the intended application routing.

 Infrastructure-as-code should explicitly control enabled Nginx sites.

---

 # 12\. Corrective Actions

 ### Immediate

 - Correct `db_host` to the intended AWS RDS endpoint.
- Verify RDS connectivity from the application host.
- Ensure the EpicBook Nginx site is enabled.
- Disable the default Nginx site where appropriate.
- Reload Nginx.
- Verify `127.0.0.1:8080`.
- Verify the public HTTP endpoint.
- Confirm that requests are reaching Express rather than the Nginx default page.

 ### Database

 - Confirm whether the existing `bookstore` database contains valid production data.
- Do not drop or recreate the database without an explicit backup and recovery plan.
- Prevent repeated schema imports.
- Introduce database migrations/schema versioning.
- Make initialization idempotent.

 ### Ansible

 - Add pre-flight validation for environment-specific database endpoints.
- Add a database connectivity check before schema initialization.
- Avoid environment configuration drift.
- Ensure all required Nginx symlinks are managed by Ansible.
- Ensure handlers reload Nginx after configuration changes.
- Keep secrets protected with `no_log`.
- Avoid relying solely on local filesystem markers for external system state.

---

 # 13\. Production Remediation Plan

 ## Phase 1 — Configuration

 Centralize environment-specific configuration:

```
group_vars/
├── web/
│   ├── vars.yml
│   └── vault.yml
├── staging/
└── production/
```

 Production should explicitly define:

```
db_host: epicbook-w6pww5-mysql.ckp6c68m8aq6.us-east-1.rds.amazonaws.com
db_port: 3306
db_name: bookstore
db_user: epicbookadmin
```

 Environment validation should fail the deployment if required variables are missing or inconsistent.

 ## Phase 2 — Database

 Implement schema migrations instead of repeatedly importing:

```
BuyTheBook_Schema.sql
```

 A migration system should maintain the database's actual schema version.

 Backups should be taken before destructive database operations.

 ## Phase 3 — Application

 Run the Node.js application under a controlled process manager such as PM2 or systemd.

 Ensure:

```
Application → localhost:8080
```

 and prevent direct external access to port 8080.

 ## Phase 4 — Reverse Proxy

 Manage Nginx entirely through Ansible.

 The deployment should:

 1. Install Nginx.
2. Deploy the EpicBook server block.
3. Enable the EpicBook site.
4. Disable the default site.
5. Validate configuration using `nginx -t`.
6. Reload Nginx.
7. Perform an HTTP smoke test.

 ## Phase 5 — TLS

 Deploy HTTPS using a valid certificate.

 Expected architecture:

```
Client
  |
  | HTTPS :443
  v
Nginx
  |
  | HTTP localhost:8080
  v
Express
  |
  | TCP 3306
  v
AWS RDS
```

 ## Phase 6 — Observability

 Add monitoring for:

 - Nginx availability.
- Node.js process health.
- HTTP 4xx/5xx rates.
- Database connectivity.
- CPU/memory/disk utilization.
- Application logs.
- Database errors.
- Deployment failures.

 Health checks should test the complete application path rather than only checking whether a process is running.

---

 # 14\. Validation Strategy

 A successful deployment should not be considered complete merely because Ansible reports `changed` or `ok`.

 The deployment pipeline should validate:

```
1. Ansible connectivity
        ↓
2. Vault decryption
        ↓
3. Database TCP connectivity
        ↓
4. Database authentication
        ↓
5. Database migration state
        ↓
6. Node.js process
        ↓
7. localhost:8080
        ↓
8. Nginx configuration
        ↓
9. Public HTTPS endpoint
        ↓
10. Application smoke tests
```

 Example final smoke tests:

```
curl -fsS http://127.0.0.1:8080/
```

```
curl -fsS http://127.0.0.1/
```

 and, after TLS is implemented:

```
curl -fsS https://epicbook.example.com/
```

 The deployment pipeline should fail if any of these critical checks fail.

---

 # 15\. Root Cause Summary

 The incident was not caused by a single application defect. It resulted from **configuration drift and insufficient deployment-state validation across multiple infrastructure layers**.

 The major root causes were:

 | Area | Root Cause |
| --- | --- |
| Ansible | Incompatible privilege-escalation/temp-file permission behavior |
| Secrets | Vault secret was not supplied during execution |
| Database | Environment configuration pointed to the wrong database provider |
| Database initialization | Existing database state did not match Ansible's initialization marker |
| Application | Node/Express was healthy but not exposed through the intended proxy |
| Nginx | Intended server block was not handling public requests |
| Security | Public host exposed to internet scanning; backend exposure and plaintext HTTP require hardening |

The key operational lesson is that **configuration, application state, and infrastructure state must be validated independently and then validated together through an end-to-end smoke test**.

 The final production architecture should be fully reproducible through Ansible, idempotent across repeated deployments, explicit about environment specific configuration, secure in its handling of secrets, and validated from the database layer all the way through the public HTTPS endpoint.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post describing the Terraform + Ansible roles deployment (cloud chosen, role structure, Nginx deployment, idempotency result), and add a 4–6 line video reflection covering one challenge/fix, security issues observed, and your production remediation plan.


 ### 5-line video reflection



## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

 <https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7509119824178946048-nni3/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>


---

#### Screenshot — Published LinkedIn post

![linkedin-post](/week-09-ansible/screenshots/ASS-5-SS-16.png)

---

#### Video reflection screenshot

![video-reflection](/week-09-ansible/screenshots/ASS-5-SS-17.png)

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not expose private keys, credentials, tokens, or unrestricted management access

---

# Completion Checklist

- [ ] Task 1: `epicbook-prod` project and role structure created (Screenshot 1)
- [ ] Task 2: Cloud VM provisioned with Terraform (Screenshots 2–3)
- [ ] Task 3: Passwordless SSH and Ansible ping verified (Screenshots 4–5)
- [ ] Task 4: `site.yml` orchestrates roles in common → nginx → epicbook order (Screenshot 6)
- [ ] Task 5: `common` role created (Screenshot 7)
- [ ] Task 6: `nginx` role, template, and handler created (Screenshots 8–9)
- [ ] Task 7: `epicbook` role created (Screenshot 10)
- [ ] Task 8: Group variables defined (Screenshot 11)
- [ ] Task 9: Playbook run successfully with `failed=0` (Screenshot 12)
- [ ] Task 10: Site verified and idempotent rerun confirmed (Screenshots 13–15)
- [ ] Reflection and security remediation notes written (Notes)
- [ ] LinkedIn post and video reflection submitted
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

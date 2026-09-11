# Assignment 3 — Multi-Play Web Deploy on Azure

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will create one Ansible playbook (`site.yml`) with three plays — install Nginx, deploy a static website with the `copy` module, and verify the deployment from the controller — against the `[web]` group from your existing inventory.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `static-web` project directory with `inventory.ini`, `site.yml`, a `files/` subdirectory, and `README.md`.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `static-web` folder layout

![static-web-layout](/week-09-ansible/screenshots/ASS-3-SS-1.png)

---

# Task 2 — Get the Content

## Goal

Stage `index.html` from `https://github.com/pravinmishraaws/Azure-Static-Website` locally under `static-web/files/`.

### Evidence

#### Screenshot 2 — Editor or terminal showing `files/index.html` staged inside the `static-web` project

![index](/week-09-ansible/screenshots/ASS-3-SS-2.png)

---

# Task 3 — Create the Multi-Play Playbook: site.yml

## Goal

Write `site.yml` with three plays: Play 1 (install/start Nginx on `web`), Play 2 (`copy` `files/index.html` to `/var/www/html/index.html` with owner `www-data`/mode `0644`, notifying an Nginx reload handler), and Play 3 (verify every web host with the `uri` module from `localhost`, asserting HTTP 200).

### Evidence

#### Screenshot 3 — Editor showing the three plays in `site.yml`

![site-yml](/week-09-ansible/screenshots/ASS-3-SS-3.png)

---

#### Screenshot 4 — Editor showing the copy task, file ownership/mode, handler, uri task, and HTTP 200 assertion

![SS-4](/week-09-ansible/screenshots/ASS-3-SS-4.png)

---

# Task 4 — Run the Playbook

## Goal

Run `ansible-playbook -i inventory.ini site.yml` and confirm all plays complete with no failures.

### Evidence

#### Screenshot 5 — Terminal showing the `ansible-playbook` run and final recap with OK/changed results and no failures

![playbook-run](/week-09-ansible/screenshots/ASS-3-SS-5.png)

---

#### Screenshot 6 — Terminal showing the successful localhost URI verification results

![uri-results](/week-09-ansible/screenshots/ASS-3-SS-6.png)

---

# Task 5 — Manual Verification

## Goal

Confirm the deployed static website is reachable directly from a web-server public IP via `curl` and a browser.

### Evidence

#### Screenshot 7 — Browser showing the static website loaded from a web-server public IP

![http://52.172.90.144](/week-09-ansible/screenshots/ASS-3-SS-7a.png)
![http://20.219.115.114](/week-09-ansible/screenshots/ASS-3-SS-7b.png)

---

### Notes

Describe an issue you faced and how you fixed it, what you learned, why installation and deployment were split into separate plays, and one benefit of using `copy` instead of cloning from Git directly.

## Issue Faced and Solution

One issue I faced was during the website verification stage of the Ansible playbook. The ansible.builtin.uri task was being executed in check mode, so it was skipped because the URI module could not perform the HTTP request in check mode. As a result, the registered result did not contain a status value, and the assertion task failed when it tried to check item.status.

I fixed the issue by adding check_mode: false to the verification play and then running the playbook normally without the --check option. After the fix, Ansible successfully sent HTTP requests to both web servers, received HTTP 200 responses, and the assertion task confirmed that both websites were working correctly.

### What I Learned

I learned how to use a multi-play Ansible playbook to separate different responsibilities within a deployment. I also learned how to use modules such as apt, service, copy, uri, and assert, as well as handlers and registered variables. Most importantly, I learned how Ansible idempotency allows a playbook to be run repeatedly without making unnecessary changes when the desired state has already been achieved.

### Why Installation and Deployment Were Split into Separate Plays

Installation and deployment were separated into different plays to make the automation easier to understand, maintain, and troubleshoot. The first play is responsible for preparing the servers by installing and configuring Nginx, while the second play is responsible for deploying the website content. This separation also makes the automation more reusable because the Nginx installation does not need to be repeated every time the website content changes.

The third play handles verification separately from the managed servers by running HTTP checks from the Ansible controller. This creates a clear separation between server configuration, application deployment, and deployment verification.

### Benefit of Using the copy Module Instead of Cloning from Git

One benefit of using the ansible.builtin.copy module is that the approved website file remains under the control of the Ansible controller and is deployed consistently to every managed server. Ansible can compare the local file with the destination file and only copy it when the content has changed. This supports idempotent deployments and avoids requiring Git or repository access on every web server.

---

# Submission Instructions

- Add all required screenshots in your submission
- IP addresses in `inventory.ini` may be redacted
- Do not expose SSH private keys

---

# Completion Checklist

- [ ] Task 1: `static-web` project structure created (Screenshot 1)
- [ ] Task 2: `index.html` staged under `files/` (Screenshot 2)
- [ ] Task 3: Three-play `site.yml` written (Screenshots 3–4)
- [ ] Task 4: Playbook run successfully with no failures (Screenshots 5–6)
- [ ] Task 5: Site verified manually via browser (Screenshot 7)
- [ ] Reflection notes written (Notes)
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

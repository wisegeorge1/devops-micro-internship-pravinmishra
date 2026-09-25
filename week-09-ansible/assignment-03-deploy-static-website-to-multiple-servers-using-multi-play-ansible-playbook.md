# Assignment 03 — Deploy a Static Website to Multiple Servers Using a Multi-Play Ansible Playbook

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Student Details

**Full Name:** George Adimowei Epebifie  
**Cloud Platform Used:** Microsoft Azure  
**Server 1 URL:** `http://52.172.90.144`  
**Server 2 URL:** `http://20.219.115.114`

---

## Purpose

In this assignment, you will create a multi-play Ansible playbook to install Nginx, deploy a static website to two Ubuntu servers, and verify that the website is accessible from both servers.

You may use either AWS EC2 instances or Azure Virtual Machines as your managed servers.

---

# Task 1 — Create the Project Structure

## Goal

Create the required folders and files for the Ansible project.

## Evidence

### Screenshot 1 — Terminal or VS Code showing the complete `static-web` project structure

![ass-3-ss1](/week-09-ansible/screenshots/ASS-3-SS-1.png)

---

# Task 2 — Configure the Ansible Inventory

## Goal

Add both Ubuntu servers to the Ansible inventory.

## Evidence

### Screenshot 2 — Output of `ansible-inventory -i inventory.ini --graph` showing `web1` and `web2`

![ass-3-ss2](/week-09-ansible/screenshots/ASS-3-SS-2.png)

---

## Configuration File

Copy and paste the complete contents of your `inventory.ini` file below:

```ini
[web]
web1 ansible_host=52.172.90.144
web2 ansible_host=20.219.115.114

[web:vars]
ansible_user=azureuser
ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

---

# Task 3 — Verify Ansible Connectivity

## Goal

Confirm that the Ansible controller can connect to both servers.

## Evidence

### Screenshot 3 — Ansible ping output showing `SUCCESS` and `pong` for both servers

![ass-3-ss3](/week-09-ansible/screenshots/ASS-3-SS-3.png)

---

# Task 4 — Download and Personalize the Static Website

## Goal

Download `index.html` to the Ansible controller and personalize the website with your full name.

## Evidence

### Screenshot 4 — Edited `files/index.html` showing the footer line with your full name

![ass-3-ss4](/week-09-ansible/screenshots/ASS-3-SS-4.png)

---

# Task 5 — Create the Multi-Play Ansible Playbook

## Goal

Create a single Ansible playbook containing separate plays for installation, deployment, and verification.

## Configuration File

Copy and paste the complete contents of your `site.yml` file below:

```yaml
- name: Install and configure Nginx
  hosts: web
  become: true

  tasks:
    - name: Update APT package cache
      ansible.builtin.apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Install Nginx
      ansible.builtin.apt:
        name: nginx
        state: present

    - name: Ensure Nginx is started and enabled
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true


- name: Deploy static website
  hosts: web
  become: true

  tasks:
    - name: Copy website index.html
      ansible.builtin.copy:
        src: files/index.html
        dest: /var/www/html/index.html
        owner: www-data
        group: www-data
        mode: "0644"
      notify: Reload Nginx

  handlers:
    - name: Reload Nginx
      ansible.builtin.service:
        name: nginx
        state: reloaded


- name: Verify websites from Ansible controller
  hosts: localhost
  connection: local
  gather_facts: false
  check_mode: false

  tasks:
    - name: Check website HTTP status
      ansible.builtin.uri:
        url: "http://{{ hostvars[item].ansible_host }}"
        method: GET
        status_code: 200
        return_content: false
      loop: "{{ groups['web'] }}"
      register: website_checks

    - name: Assert both websites return HTTP 200
      ansible.builtin.assert:
        that:
          - item.status == 200
        success_msg: "{{ item.item }} returned HTTP {{ item.status }}"
        fail_msg: "{{ item.item }} did not return HTTP 200"
      loop: "{{ website_checks.results }}"
```

---

# Task 6 — Validate the Playbook Syntax

## Goal

Check the playbook for YAML or Ansible syntax errors before running it.

## Evidence

### Screenshot 5 — Successful syntax-check output showing `playbook: site.yml`

![ass-3-ss5](/week-09-ansible/screenshots/ASS-3-SS-5.png)

---

# Task 7 — Run the Multi-Play Playbook

## Goal

Install Nginx, deploy the website, and verify both servers in one playbook run.

## Evidence

### Screenshot 6 — Play 3 verification showing HTTP `200` for both servers

![ass-3-ss6](/week-09-ansible/screenshots/ASS-3-SS-6.png)

---

### Screenshot 7 — Final play recap showing `unreachable=0` and `failed=0` for `web1`, `web2`, and `localhost`

![ass-3-ss7](/week-09-ansible/screenshots/ASS-3-SS-7.png)

---

# Task 8 — Verify Idempotency

## Goal

Run the playbook again and confirm that it does not make unnecessary changes.

## Evidence

### Screenshot 8 — Second playbook run showing the play recap with `changed=0`, `unreachable=0`, and `failed=0` for both web servers

![ass-3-ss8](/week-09-ansible/screenshots/ASS-3-SS-8.png)

---

# Task 9 — Test Both Websites Manually

## Goal

Confirm that the static website is accessible from both public IP addresses.

## Evidence

### Screenshot 9 — `curl -I` output showing HTTP `200 OK` from both servers

![ass-3-ss9](/week-09-ansible/screenshots/ASS-3-SS-9.png)

---

### Screenshot 10 — Browser showing the website from Server 1 with the public IP and your full name visible

![ass-3-ss10](/week-09-ansible/screenshots/ASS-3-SS-10.png)

---

### Screenshot 11 — Browser showing the website from Server 2 with the public IP and your full name visible

![ass-3-ss11](/week-09-ansible/screenshots/ASS-3-SS-11.png)

---

## Website URLs

Add both deployed website URLs below:

```text
Server 1: http://52.172.90.144>
Server 2: http://20.219.115.114>

```

---

# Task 10 — Complete the Project README

## Goal

Document how the project works and record what you learned.

## README Content

Copy and paste the complete contents of your `README.md` file below:

```markdown
# Multi-Play Ansible Static Website Deployment

 ## Project Overview

 This project demonstrates how Terraform and Ansible can be used together to deploy a static website to multiple Azure Ubuntu Linux servers.

 Terraform was used to provision two Azure Virtual Machines named `web1` and `web2`, together with the required networking resources, public IP addresses, Network Security Group rules, and SSH key authentication.

 Ansible was then used to install and configure Nginx, deploy the same static website to both servers, reload Nginx when the website changed, and verify that both websites returned HTTP status code 200.

 ## Environment

- Cloud platform: Microsoft Azure
- Operating system: Ubuntu 22.04 LTS
- Number of managed servers: 2
- Server names: web1 and web2
- Web server: Nginx
- Configuration management: Ansible
- Infrastructure as code: Terraform

 ## Infrastructure

 Terraform created:

- An Azure resource group
- An Azure virtual network
- An Azure subnet
- An Azure Network Security Group
- Two static public IP addresses
- Two network interfaces
- Two Ubuntu Linux virtual machines

 SSH access was restricted to the public IP address of the Ansible controller. HTTP port 80 was opened so that the static websites could be accessed from the internet.

 ## Ansible Inventory

 The two servers were placed in the `web` inventory group.

 The inventory used Ansible aliases such as `web1` and `web2`, while the `ansible_host` variable contained the corresponding Azure public IP address.

 The SSH private key remained on the Ansible controller and was referenced by its local file path. The private key was not copied into the project.

 ## How to Run the Playbook

 Activate the Ansible virtual environment:

```
source ~/ansible-onboarding/.venv/bin/activate
```

Change to the project directory:

```
cd ~/ansible-onboarding/static-web
```

Validate the playbook:

```
ansible-playbook -i inventory.ini site.yml --syntax-check
```

Run the playbook:

```
ansible-playbook -i inventory.ini site.yml
```

 ## Multi-Play Structure

 The playbook contains three plays.

### Play 1 — Install and Configure Nginx

 The first play targets the `web` group and uses privilege escalation.

 It updates the APT package cache, installs Nginx, and ensures that Nginx is running and enabled.

### Play 2 — Deploy the Website

The second play copies `files/index.html` from the Ansible controller to `/var/www/html/index.html` on both servers.

The file is owned by `www-data`, has group `www-data`, and uses `0644` permissions.

A handler reloads Nginx only when the website file changes.

### Play 3 — Verify the Websites

The third play runs on the Ansible controller using a local connection.

The `ansible.builtin.uri` module sends HTTP requests to both web servers. The returned results are registered and checked using `ansible.builtin.assert`.

Each server is expected to return HTTP status code 200.

## Issue Faced and Solution

One challenge I faced was making sure that the Azure public IP addresses in the Ansible inventory matched the current addresses assigned to the two VMs.

I verified the addresses using Terraform:

```
terraform output public_ips
```

I then updated `inventory.ini` so that each Ansible alias pointed to the correct public IP using `ansible_host`.

I tested the connection using:

```
ansible web -i inventory.ini -m ping
```

Both servers returned `pong`, confirming that the inventory, SSH configuration, and network access were working correctly.

## What I Learned

I learned how multiple Ansible plays can be combined into one playbook while keeping different responsibilities separate.

I also learned how the `copy` module can transfer approved website content from the Ansible controller to multiple managed servers consistently.

The assignment also helped me understand idempotency. When I ran the playbook a second time without changing the website, Ansible did not need to reinstall Nginx or copy the file again, and the reload handler did not execute.

## Why Installation and Deployment Are Separate

Nginx installation and website deployment are separated because they represent different responsibilities.

The installation play establishes the required web-server software and service state. The deployment play manages the application content served by Nginx.

Keeping them separate makes the automation easier to understand, maintain, troubleshoot, and reuse. Website content can change frequently without changing the Nginx installation logic.

## Benefit of the Ansible Copy Module

The Ansible `copy` module provides a controlled way to transfer approved files from the Ansible controller to managed servers.

Ansible can determine whether the destination file already matches the source file. If there is no difference, the file does not need to be copied again.

This supports idempotency and helps ensure that both web servers receive the same website content.

## Idempotency Verification

I ran the playbook once to install Nginx and deploy the website.
I then ran the same playbook again without modifying the website.
During the second run, the existing configuration was recognized and unnecessary changes were avoided. The website verification continued to return HTTP 200 for both servers.

This demonstrated that the playbook was designed to be idempotent.

## Website Verification

The websites were manually tested using:

```
curl -I http://<WEB1_PUBLIC_IP>
curl -I http://<WEB2_PUBLIC_IP>
```

Both servers returned:

```
HTTP/1.1 200 OK
```

The websites were also opened in a browser to confirm that the same static website was displayed on both servers.

## Security Considerations

SSH access was restricted to the public IP address of the Ansible controller instead of allowing SSH from `0.0.0.0/0`.
Password authentication was disabled on the Azure VMs and SSH public-key authentication was used.
Private SSH keys and cloud credentials were not stored in the project or committed to Git.

## Conclusion

This project demonstrated how Terraform can provision consistent Azure infrastructure and how Ansible can configure multiple servers using a single multi-play playbook.

The final solution deployed the same static website to two Ubuntu servers, managed Nginx consistently, automatically reloaded Nginx when the website changed, and verified that both servers successfully returned HTTP 200.

You can personalize the **Issue Faced and Solution** section with the exact problem you encountered if yours was different.

```

---

# LinkedIn Post Required

## Evidence

### LinkedIn Post URL

Paste your LinkedIn post URL here:

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7509144150739611648-UBUu/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

### Screenshot — Published LinkedIn post

![linkedin-post](/week-09-ansible/screenshots/ASS-3-SS-12.png)

---

# Assignment Questions

Answer the following in your own words:

**1. What issue did you face while completing this assignment, and how did you fix it?**

One issue I faced was ensuring that the Azure public IP addresses in the Ansible inventory matched the current public IP addresses assigned to the two virtual machines.
I verified the addresses using Terraform with `terraform output public_ips`. I then updated inventory.ini so that web1 and web2 pointed to the correct addresses using the ansible_host variable. After updating the inventory, I tested connectivity with `ansible web -i inventory.ini -m ping` Both servers returned pong, confirming that the inventory, SSH configuration, and network connectivity were working correctly.

---

**2. What did you learn from this assignment?**

 1. I learned how to use a multi play Ansible playbook to automate the complete deployment of a static website across multiple Ubuntu servers.
 2. I learned how to separate infrastructure configuration into different stages: installing Nginx, deploying the website files, and verifying the deployed websites.
 3. I also gained a better understanding of Ansible modules such as apt, service, copy, uri, and assert, as well as the importance of idempotency in automation.

The assignment also showed me how Terraform and Ansible complement each other. Terraform can provision the Azure infrastructure, while Ansible can configure and manage the servers after they have been created.

---

**3. Why is it useful to split installation, deployment, and verification into separate plays?**

Separating the tasks into different plays makes the playbook easier to understand, maintain, troubleshoot, and reuse.
 
 - The first play is responsible for establishing the web-server environment by installing and configuring Nginx.
 - The second play is responsible for deploying the website content.
 - The third play verifies that the deployed websites are actually accessible and return the expected HTTP status.

This separation also makes troubleshooting easier because each play has a clear responsibility. If something fails, it is easier to identify whether the problem is related to software installation, website deployment, or application availability.

---

**4. What is one benefit of using the Ansible `copy` module instead of cloning the website directly from Git on every managed server?**

One major benefit is consistency and control over the exact content being deployed.
The `copy` module transfers the approved index.html from the Ansible controller to the managed servers. This means both servers receive the same known version of the website. The `copy` module also supports idempotency. If the destination file already matches the source file, Ansible does not need to copy it again.

Cloning the website repository directly on every server would introduce additional Git dependencies and would make the managed servers responsible for retrieving the source content themselves. Using `copy` keeps the deployment process controlled by Ansible.

---

**5. What does idempotency mean in this assignment?**

Idempotency means that running the same Ansible playbook multiple times produces the desired final state without repeatedly making unnecessary changes.
For example, the first playbook run installs Nginx if it is not already installed and starts the service. When the playbook is run again, Ansible recognizes that Nginx is already installed and running, so it does not unnecessarily reinstall it.
Similarly, the copy task does not repeatedly copy the website file when the destination already matches the source.
The second playbook run therefore results in fewer or no changes while still confirming that the servers remain in the desired state.

---

**6. What does the Ansible `uri` module verify in Play 3?**

The uri module verifies that the websites deployed on the two Azure servers are accessible over HTTP.
In this assignment, it sends a GET request to each server's public IP address and expects an HTTP status code of 200.
The results are then registered and checked using the Ansible assert module.
Therefore, Play 3 verifies the website from the Ansible controller rather than simply checking whether Nginx is installed. It confirms that the web service is actually reachable and responding successfully over HTTP.

---

# Required Files

Confirm that the following files are included in your assignment folder:

- [ ] `inventory.ini`
- [ ] `site.yml`
- [ ] `files/index.html`
- [ ] `README.md`

---

# Submission Instructions

- Add all required screenshots in the correct order.
- Full Name must be visible in required screenshots.
- Include both deployed website URLs.
- Paste `inventory.ini`, `site.yml`, and `README.md` as editable text.
- Answer all assignment questions clearly in your own words.
- Add your LinkedIn post URL.
- Do not expose SSH private keys, passwords, cloud account IDs, or other sensitive information.

---

# Completion Checklist

- [ ] Task 1: `static-web` folder structure is complete
- [ ] Task 2: Both servers are listed under the `[web]` group in `inventory.ini`
- [ ] Task 2: Inventory graph shows `web1` and `web2`
- [ ] Task 3: Ansible ping returns `SUCCESS` and `pong` for both servers
- [ ] Task 4: `files/index.html` contains your full name
- [ ] Task 5: `site.yml` contains three separate plays
- [ ] Task 5: Play 1 installs, starts, and enables Nginx
- [ ] Task 5: Play 2 deploys `index.html` using the `copy` module
- [ ] Task 5: Nginx reload handler is included
- [ ] Task 5: Play 3 verifies both web servers from the controller
- [ ] Task 6: Playbook syntax check passes
- [ ] Task 7: First playbook run completes with `unreachable=0` and `failed=0`
- [ ] Task 7: URI verification returns HTTP `200` for both servers
- [ ] Task 8: Second playbook run demonstrates idempotency
- [ ] Task 8: Second run shows `changed=0` for both web servers
- [ ] Task 9: Both `curl -I` commands return HTTP `200 OK`
- [ ] Task 9: Website loads from Server 1
- [ ] Task 9: Website loads from Server 2
- [ ] Task 9: Full name is visible on both deployed websites
- [ ] Task 10: `README.md` contains all required explanations
- [ ] Screenshots 1–11 are included
- [ ] `inventory.ini`, `site.yml`, and `README.md` are pasted as editable text
- [ ] Both website URLs are included
- [ ] Assignment questions are answered
- [ ] LinkedIn post published
- [ ] LinkedIn post URL added
- [ ] No sensitive information is exposed

---

## About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra and The CloudAdvisory, focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## Resources

- DMI Official Website: [https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme)
- University: [https://university.pravinmishra.com?utm_source=github&utm_medium=readme](https://university.pravinmishra.com?utm_source=github&utm_medium=readme)
- Discord Community: [https://discord.pravinmishra.com?utm_source=github&utm_medium=readme](https://discord.pravinmishra.com?utm_source=github&utm_medium=readme)
- Blog: [https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme](https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme)
- YouTube Playlist: [https://www.youtube.com/playlist?list=PLFeSNDtI4Cho](https://www.youtube.com/playlist?list=PLFeSNDtI4Cho)
- Pravin Mishra LinkedIn: [https://www.linkedin.com/in/pravin-mishra-aws-trainer/](https://www.linkedin.com/in/pravin-mishra-aws-trainer/)
- CloudAdvisory LinkedIn: [https://www.linkedin.com/company/thecloudadvisory/](https://www.linkedin.com/company/thecloudadvisory/)

---

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*
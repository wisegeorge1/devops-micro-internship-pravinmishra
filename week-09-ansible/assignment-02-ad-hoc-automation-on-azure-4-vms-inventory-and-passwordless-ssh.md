# Assignment 2 — Ad-Hoc Automation on Azure: 4 VMs, Inventory & Passwordless SSH

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will provision four Azure Linux VMs with Terraform, configure passwordless SSH, build a custom Ansible inventory with web/app/db groups, and run ad-hoc commands across individual hosts and groups.

---

# Task 1 — Provision 4 Azure VMs (Terraform)

## Goal

Provision four Ubuntu 22.04 VMs (`web1`, `web2`, `app1`, `db1`, Standard_B1s) with SSH key authentication and public IPs, in a VNet with an NSG allowing SSH (22) and HTTP (80), and output all four public IPs.

### Evidence

#### Screenshot 1 — Terminal showing successful `terraform apply` output and `terraform output public_ips`

![successful](/week-09-ansible/screenshots/ASS-2-SS-1.png)

---

#### Screenshot 2 — Azure Portal showing all four running Ubuntu VMs

![running-vms](/week-09-ansible/screenshots/ASS-2-SS-2.png)

---

#### Screenshot 3 — Network Security Group inbound rules showing SSH 22 and HTTP 80

![nsg-inbound-rules](/week-09-ansible/screenshots/ASS-2-SS-3.png)

---

# Task 2 — Configure Passwordless SSH

## Goal

Connect to each of the four VMs as `azureuser` and run `hostname` remotely without a password prompt.

### Evidence

#### Screenshot 4 — Terminal showing successful `hostname` output from all four passwordless SSH tests

![hostname](/week-09-ansible/screenshots/ASS-2-SS-4.png)

---

# Task 3 — Create a Custom Ansible Inventory

## Goal

Create `inventory.ini` mapping VM indices 0–1 to `[web]`, index 2 to `[app]`, and index 3 to `[db]`, with `ansible_user` and `ansible_ssh_private_key_file` set under `[all:vars]`.

### Evidence

#### Screenshot 5 — Editor or terminal showing `inventory.ini` with the web, app, db, and all:vars sections

![inventory-file](/week-09-ansible/screenshots/ASS-2-SS-5.png)

---

# Task 4 — Run Your First Ansible Ad-Hoc Commands

## Goal

Run `ping`, `whoami`, and `uptime` against all hosts; install and start Nginx on the `web` group with `--become`; install `htop` on all hosts; and run `df -h` on `db` and `free -m` on all hosts.

### Evidence

#### Screenshot 6 — Terminal showing `ansible ping` SUCCESS for all four hosts

![ping](/week-09-ansible/screenshots/ASS-2-SS-6.png)

---

#### Screenshot 7 — Terminal showing `uptime` output for all four hosts

![uptime](/week-09-ansible/screenshots/ASS-2-SS-7.png)

---

#### Screenshot 8 — Terminal showing Nginx installation and service start on the web group

![nginx-started](/week-09-ansible/screenshots/ASS-2-SS-8.png)

---

#### Screenshot 9 — Terminal showing `htop` installation on all hosts and group-targeted command output

![htop](/week-09-ansible/screenshots/ASS-2-SS-9.png)

---

### Notes

Describe an issue you faced and how you fixed it, what you learned, when you'd use an ad-hoc command instead of a playbook, and one challenge you faced during SSH or inventory setup.

One issue I faced occurred while testing SSH access to my Azure VM. I initially ran the following command:

```
ssh -i ~/.ssh/id_ed25519 azureuser@20.219.73.91 "vm-web1"
```

 SSH successfully connected to the VM and added the host fingerprint to my `known_hosts` file, which confirmed that the SSH key authentication and network connectivity were working correctly. However, the command returned:

```
bash: line 1: vm-web1: command not found
```

 The problem was that I was treating the Azure VM resource name, `vm-web1`, as if it were a Linux command. The SSH connection itself was not the problem.

 I fixed the issue by using the Linux `hostname` command instead:

```
ssh -i ~/.ssh/id_ed25519 azureuser@20.219.73.91 "hostname"
```

 This correctly returned:

```
web1
```

 This helped me distinguish between the Azure VM resource name, the Linux hostname, and the Ansible inventory alias.

 ## What I learned

 I learned that Terraform, Azure, SSH, and Ansible each have different responsibilities and naming concepts.

 Terraform creates the Azure VM with a resource name such as:

```
vm-web1
```

 The Linux machine itself has a hostname such as:

```
web1
```

 Ansible can then use `web1` as an inventory alias while connecting to the VM's actual public IP through:

```
web1 ansible_host=20.219.73.91
```

 I also learned that successful SSH authentication does not necessarily mean that the command being executed remotely is correct. SSH can work perfectly while the remote shell still reports an invalid command.

 Another important lesson was that Ansible's `ping` module is not an ICMP ping. It tests whether Ansible can connect to the server and execute its module successfully.

 ## When would you use an ad-hoc command instead of a playbook?

 I would use an Ansible ad-hoc command for a quick, one time administrative or diagnostic task that does not require a complete automation workflow.

 For example, checking the uptime of all servers:

```
ansible all -m command -a "uptime"
```

 Checking disk space on the database server:

```
ansible db -m command -a "df -h"
```

 Or checking whether Nginx is running:

```
ansible web -m command -a "systemctl is-active nginx"
```

 Ad-hoc commands are useful because they are quick and do not require creating a playbook.

 I would use a playbook when the configuration needs to be repeatable, documented, version-controlled, and executed regularly. For example, if I needed to configure Nginx consistently across multiple environments, I would create an Ansible playbook rather than repeatedly running ad-hoc commands.

 ## Challenge faced during SSH or inventory setup

 My main SSH challenge was understanding the difference between the VM name and the command that should be executed after connecting.

 The Azure VM was named:

```
vm-web1
```

 but I initially attempted to execute `vm-web1` as a command. After receiving the `command not found` error, I realized that the correct way to verify the machine's Linux hostname was:

```
ssh -i ~/.ssh/id_ed25519 azureuser@20.219.73.91 "hostname"
```

 The result was:

```
web1
```

 I then used the public IP and correct SSH username in my Ansible inventory:

```
[web]
web1 ansible_host=20.219.73.91

[app]
app1 ansible_host=<APP1_PUBLIC_IP>

[db]
db1 ansible_host=<DB1_PUBLIC_IP>

[all:vars]
ansible_user=azureuser
ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

 This challenge helped me understand how Ansible inventory aliases work. The alias `web1` is the logical name Ansible uses, while `ansible_host` specifies the actual IP address to which Ansible connects.

 Overall, the experience reinforced the importance of troubleshooting each layer separately: first verify network connectivity, then SSH authentication, then the remote command, and finally Ansible inventory and automation.

---

# Submission Instructions

- Add all required screenshots in your submission
- Public IP addresses may be redacted
- Do not expose, upload, or commit the SSH private key

---

# Completion Checklist

- [ ] Task 1: Four Azure VMs provisioned with Terraform (Screenshots 1–3)
- [ ] Task 2: Passwordless SSH verified on all four VMs (Screenshot 4)
- [ ] Task 3: `inventory.ini` created with web/app/db groups (Screenshot 5)
- [ ] Task 4: Ad-hoc ping, uptime, Nginx, and htop commands run successfully (Screenshots 6–9)
- [ ] Reflection notes written (Notes)
- [ ] No private key material exposed

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

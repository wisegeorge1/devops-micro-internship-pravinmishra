# Assignment 02 — Provision Linux VMs with Terraform and Run Ansible Ad-Hoc Commands

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will use Terraform to provision three or four Ubuntu Linux Virtual Machines on either Microsoft Azure or Amazon Web Services.

You will configure SSH key-based authentication, organize the servers using a custom Ansible inventory, and run Ansible ad-hoc commands across individual hosts and inventory groups.

---

# Task 1 — Create the Multi-Host Lab Structure

## Goal

Create a separate project directory for the multi-host lab and prepare the Terraform, Ansible, and documentation files.

This project will use the Git repository and Ansible controller prepared in Assignment 01.

### Evidence

#### Screenshot 1 — Terminal showing the complete `ansible-adhoc-lab` project structure

![ass-2-ss1](/week-09-ansible/screenshots/ASS-2-SS-1.png)

---

#### Screenshot 2 — Terminal showing `git status --short` with the new project files and updated `.gitignore`

![ass-2-ss2](/week-09-ansible/screenshots/ASS-2-SS-2.png)

---

### Notes

For this task, I created a dedicated ansible-adhoc-lab project structure within my existing DevOps Git repository.
The project separates the infrastructure provisioning files from the Ansible configuration and documentation. The Terraform directory contains the provider, main infrastructure configuration, variables, and outputs, while the Ansible directory contains the custom inventory used to manage the provisioned servers.
I also updated the .gitignore file to prevent Terraform-generated files and sensitive infrastructure artifacts from being committed to Git. This includes Terraform state files, local Terraform directories, and other files that should remain outside version control.

The project structure provides a clean separation between infrastructure provisioning, configuration management, and documentation.
The screenshots show the completed project structure, Git status, and updated .gitignore.

---

# Task 2 — Create the Terraform Configuration

## Goal

Create the Terraform configuration required to provision three or four Ubuntu Linux VMs on your selected cloud platform.

Complete only one option:

- Option A — Microsoft Azure
- Option B — Amazon Web Services

Do not configure both providers for this assignment.

### Evidence

#### Screenshot 3 — Terraform configuration showing the three or four server roles and the `for_each` or `count` implementation

![ass-2-ss3](/week-09-ansible/screenshots/ASS-2-SS-3.png)

---

#### Screenshot 4 — Terraform configuration showing SSH restricted to the controller IP and HTTP allowed only for web hosts

![ass-2-ss4](/week-09-ansible/screenshots/ASS-2-SS-4.png)

---

#### Screenshot 5 — Terraform output configuration showing how public IP addresses are associated with the server roles

![ass-2-ss5](/week-09-ansible/screenshots/ASS-2-SS-5.png)

---

### Notes

For this assignment, I selected Microsoft Azure and used the three Virtual Machine option.

I created Terraform configuration to provision the required Ubuntu Linux virtual machines and supporting Azure networking resources. The infrastructure was designed around different server roles so that Ansible could later target specific groups such as web, app, and db.

Terraform was used to define the infrastructure declaratively rather than creating the resources manually through the Azure Portal.

The configuration included:

 - Azure Resource Group
 - Virtual Network
 - Subnet
 - Network Security Groups
 - Public IP addresses
 - Network interfaces
 - Ubuntu Linux virtual machines
 - SSH key-based authentication
 - Role-based infrastructure outputs
 - Reusable variables
 - Terraform for_each/resource iteration for the multi-host deployment

Security was also considered during the configuration. SSH access was restricted to the controller's public IP rather than exposing port 22 to the entire internet. HTTP access was permitted for the web server role because the web server needs to receive HTTP traffic.

Terraform outputs were configured to make it easy to retrieve the public IP address associated with each server role and use those addresses when building the Ansible inventory.

---

# Task 3 — Provision the Infrastructure with Terraform

## Goal

Initialize and validate the Terraform configuration, review the execution plan, provision the selected three or four VMs, and retrieve their public IP addresses.

### Evidence

#### Screenshot 6 — Final `terraform apply` output showing `Apply complete`

![ass-2-ss6](/week-09-ansible/screenshots/ASS-2-SS-6.png)

---

#### Screenshot 7 — `terraform output public_ips` showing the role-to-IP mapping for all three or four VMs

![ass-2-ss7](/week-09-ansible/screenshots/ASS-2-SS-7.png)

---

#### Screenshot 8 — Azure Portal or AWS Management Console showing all three or four VMs in the `Running` state, with their role-based names visible

![ass-2-ss8](/week-09-ansible/screenshots/ASS-2-SS-8.png)

---

### Notes

I initialized and validated the Terraform configuration before deploying the infrastructure.
The deployment process followed the normal Terraform workflow:

  i. terraform init
 ii. terraform validate
iii. terraform plan
 iv. terraform apply
  v. terraform output public_ips

Terraform successfully provisioned the three Ubuntu Linux virtual machines and their associated Azure networking resources.

After deployment, I used the Terraform outputs to retrieve the public IP addresses associated with the server roles. These addresses were then used to configure the Ansible inventory.

I also verified the deployed resources through the Azure Portal and confirmed that the virtual machines were running.

**Deployment issues encountered**
During deployment, I encountered two Azure specific issues.

1. Azure Basic Public IP SKU restriction
Initially, Azure rejected the Public IP resource because the subscription had no available quota for IPv4 Basic SKU public IP addresses in the selected region.

The error indicated that the subscription had a Basic SKU limit of zero.
I resolved this by changing the Public IP configuration from Basic to Standard:

sku = "Standard"

This allowed the Public IP resource to be provisioned using the supported Standard SKU.

2. Azure VM family quota
The initial VM size belonged to the standardBasv2Family family. Azure reported that the subscription had a quota of zero cores for that VM family, while the deployment required two cores.

The error showed:

Current Limit: 0
Current Usage: 0
Additional Required: 2

Rather than depending on a quota increase, I changed the VM size to a VM family available to the subscription.
This allowed Terraform to provision the virtual machines successfully.
These issues demonstrated the importance of checking cloud resource quotas and regional availability when designing infrastructure with Terraform.

---

# Task 4 — Verify SSH Key-Based Access

## Goal

Verify that each managed VM can be accessed from the Ansible controller using SSH key-based authentication.

### Evidence

#### Screenshot 9 — Terminal showing successful SSH hostname output from all VMs

![ass-2-ss9](/week-09-ansible/screenshots/ASS-2-SS-9.png)

---

### Notes

After the virtual machines were provisioned, I verified SSH connectivity from the Ansible controller to each managed Ubuntu VM.
The VMs were configured with SSH public key authentication through Terraform. The corresponding private key remained on the controller and was never committed to the Git repository.

I tested SSH connectivity and verified that the hostname of each VM could be retrieved successfully.
The SSH verification confirmed that:

 - The VMs were reachable over the network.
 - The correct public IP addresses were being used.
 - The SSH username was correct.
 - Key-based authentication was functioning.
 - The Ansible controller could communicate with the managed nodes.

**SSH/inventory issue encountered**
During the Ansible setup, I initially had an inventory formatting problem.
The inventory contained the host and Ansible connection variables on separate lines, causing Ansible to interpret values such as:

ansible_user=azureuser as hostnames.

I corrected the inventory so that the connection variables were associated directly with the host.
I also encountered an SSH host key verification error. After verifying that the IP address belonged to the intended Azure VM, I accepted the VM's SSH host key and confirmed SSH connectivity.

---

# Task 5 — Create the Custom Ansible Inventory

## Goal

Create an Ansible inventory file that groups the managed VMs by role.

The inventory allows Ansible to run commands against all servers, or only specific groups such as `web`, `app`, or `db`.

### Evidence

#### Screenshot 10 — `inventory.ini` showing the `web`, `app`, and `db` groups

![ass-2-ss10](/week-09-ansible/screenshots/ASS-2-SS-10.png)

---

#### Screenshot 11 — Output of `ansible-inventory -i inventory.ini --graph`

![ass-2-ss11](/week-09-ansible/screenshots/ASS-2-SS-11.png)

---

### Notes

I created a custom Ansible inventory to organize the three Ubuntu servers according to their intended roles.
The inventory separates the servers into:

web
app
db

This allows Ansible commands to target all servers at once or only the servers belonging to a particular role. For example `ansible all -i inventory.ini -m ping` targets all managed servers, while `ansible web -i inventory.ini -m ping` targets only the web servers. I also used `ansible-inventory -i inventory.ini --graph` to verify that Ansible was correctly reading the inventory groups and hosts.
The inventory provides a logical abstraction between the physical VM IP addresses and their roles. This makes it easier to manage infrastructure as the environment grows.

**Inventory issue encountered**
Initially, I attempted to run `ansible -i inventory.ini web -m ping` while the inventory group was named webservers.
Ansible returned `Could not match supplied host pattern, ignoring: web No hosts matched, nothing to do` 
The problem was that Ansible was looking for a group named web, while the inventory contained webservers.
I corrected the group naming and inventory structure so that the group names used in commands matched the groups defined in inventory.ini.

---

# Task 6 — Run Ansible Ad-Hoc Commands

## Goal

Run Ansible ad-hoc commands from the controller to verify connectivity, check server information, and manage packages and services across inventory groups.

This task proves that the inventory is working and that Ansible can control multiple managed VMs without writing a playbook.

### Evidence

#### Screenshot 12 — Output of `ansible all -i inventory.ini -m ping`

![ass-2-ss12](/week-09-ansible/screenshots/ASS-2-SS-12.png)

---

#### Screenshot 13 — Output of `ansible all -i inventory.ini -m command -a "uptime"`

![ass-2-ss13](/week-09-ansible/screenshots/ASS-2-SS-13.png)

---

#### Screenshot 14 — Output of `ansible web -i inventory.ini -m apt -a "name=nginx state=present update_cache=yes" --become`

![ass-2-ss14](/week-09-ansible/screenshots/ASS-2-SS-14.png)

---

#### Screenshot 15 — Output of `ansible web -i inventory.ini -m service -a "name=nginx state=started enabled=yes" --become`

![ass-2-ss15](/week-09-ansible/screenshots/ASS-2-SS-15.png)

---

#### Screenshot 16 — Output of `ansible all -i inventory.ini -m apt -a "name=htop state=present update_cache=yes" --become`

![ass-2-ss16](/week-09-ansible/screenshots/ASS-2-SS-16.png)

---

#### Screenshot 17 — Output of `ansible web -i inventory.ini -m command -a "systemctl is-active nginx"`

![ass-2-ss17](/week-09-ansible/screenshots/ASS-2-SS-17.png)

---

### Notes

For this task, I used Ansible ad-hoc commands to verify connectivity, inspect the servers, install packages, and manage the Nginx service.

The first test used the Ansible ping module `ansible all -i inventory.ini -m ping` This confirmed that Ansible could successfully connect to the managed Ubuntu servers.
I then used the command module to retrieve system uptime `ansible all -i inventory.ini -m command -a "uptime"`
For the web servers, I installed Nginx using the Ansible apt module `ansible web -i inventory.ini -m apt -a "name=nginx state=present update_cache=yes" --become`
The Nginx service was then started and enabled `ansible web -i inventory.ini -m service -a "name=nginx state=started enabled=yes" --become`
I also installed htop across all servers `ansible all -i inventory.ini -m apt -a "name=htop state=present update_cache=yes" --become`
Finally, I verified that Nginx was active `ansible web -i inventory.ini -m command -a "systemctl is-active nginx"`
The expected result was: *active*

**Why `--become` was necessary**
Package installation and service management require elevated privileges on Ubuntu. The --become option allows Ansible to execute the operation with elevated privileges, typically through sudo. This allowed the Ansible controller to install packages and manage system services without logging into the VM directly as the root user.
The screenshots provide evidence of successful Ansible connectivity, package installation, service management, and Nginx verification.

---

# LinkedIn Post Required

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7509134319060283392-Qw2f/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

#### Screenshot — Published LinkedIn post

![linkedin-post](/week-09-ansible/screenshots/ASS-2-SS-18.png)

---

# Assignment Questions

Answer the following in your own words:

**1. What is the purpose of an Ansible inventory file?**

An Ansible inventory file defines the servers that Ansible manages and organizes them into logical groups.
It provides Ansible with information such as the host addresses, group membership, usernames, and SSH connection details.
For example, grouping servers as web, app, and db allows me to run a command against only the web servers instead of manually specifying every server.
The inventory therefore acts as the connection and organization layer between the Ansible controller and the managed infrastructure.

---

**2. What is the difference between the `web`, `app`, and `db` groups in your inventory?**

The groups represent different server roles.

 1. The web group contains servers responsible for web facing services such as Nginx.
 2. The app group represents servers intended to run application workloads or application services.
 3. The db group represents servers intended for database workloads.

The groups make it possible to apply different configuration and administration tasks to different types of servers.
For example, Nginx can be installed only on the web group without installing it on the application or database servers.

---

**3. What does the Ansible `ping` module verify?**

The Ansible ping module verifies that Ansible can successfully communicate with a managed host. It checks the connection and confirms that Ansible can execute its module on the remote machine.

A successful result such as:
"ping": "pong"

means the host is reachable and Ansible is able to communicate with it successfully.
It is important to note that the Ansible ping module is not the same as the traditional network ping command. It tests Ansible connectivity rather than simply testing ICMP network reachability.

---

**4. Why do package installation commands require `--become`?**

Package installation normally requires administrator privileges on Linux. The `--become` option tells Ansible to use privilege escalation, normally through sudo, when executing the command. For example, `ansible all -i inventory.ini -m apt -a "name=htop state=present" --become` allows Ansible to perform the package installation with the required privileges while still connecting using the normal administrative SSH account. Using privilege escalation avoids the need to enable direct root SSH access.

---

**5. When would you use an ad-hoc command instead of a playbook?**

I would use an ad-hoc command when I need to perform a quick, simple, or one time administrative task across one or more servers.
Examples include, Checking server uptime, Testing Ansible connectivity, Checking whether a service is running, Installing a package temporarily, 
Gathering a quick piece of system information. However for repeatable, complex, multi step, or production configuration, I would use an Ansible playbook instead.

A playbook provides a structured and repeatable way to define configuration, tasks, handlers, variables, and deployment logic.
In this assignment, ad-hoc commands were appropriate because the objective was to demonstrate direct Ansible control of the managed servers.

---

**6. What is one challenge you faced while setting up SSH or inventory, and how did you fix it?**

One challenge I encountered was an Ansible inventory configuration error. Initially, the inventory group name did not match the group I used in my Ansible command. I attempted to target the web group while the inventory contained a differently named group. Ansible therefore returned `Could not match supplied host pattern No hosts matched`
I resolved the issue by correcting the inventory group name and ensuring that the host-specific Ansible connection variables were correctly associated with the host.

I also encountered an SSH host-key verification issue. I verified the VM identity and accepted the correct SSH host key before testing the connection again.
This experience reinforced the importance of checking the inventory structure and validating SSH connectivity independently before troubleshooting Ansible itself.

**What I Learned**
This assignment gave me practical experience combining Infrastructure as Code with configuration management.
Terraform allowed me to define and provision the Azure infrastructure consistently, while Ansible provided a way to remotely manage and configure the resulting Linux servers.
I learned that successful automation depends not only on writing Terraform and Ansible configuration but also on understanding cloud quotas, networking, SSH authentication, inventory structure, Linux privileges, and service management.
One of the most useful lessons was troubleshooting the boundary between Terraform, Azure, SSH, and Ansible. An infrastructure deployment can fail at several different layers, so identifying the exact layer producing the error is essential

---

# Required Files

Confirm that the following files are included in your assignment workspace:

- [ ] `ansible-adhoc-lab/README.md`
- [ ] `ansible-adhoc-lab/terraform/providers.tf`
- [ ] `ansible-adhoc-lab/terraform/main.tf`
- [ ] `ansible-adhoc-lab/terraform/variables.tf`
- [ ] `ansible-adhoc-lab/terraform/outputs.tf`
- [ ] `ansible-adhoc-lab/ansible/inventory.ini`
- [ ] Updated `.gitignore`

---

# Submission Instructions

- Add all required screenshots from the tasks.
- Full Name must be visible in required screenshots.
- Mention whether you used Azure or AWS.
- Mention whether you used the three-VM option or four-VM option.
- Add the public IP addresses of the VMs, redacted if preferred.
- Add your `inventory.ini` proof.
- Add a short explanation of what you learned.
- Answer all assignment questions clearly in your own words.
- Add your LinkedIn post URL.
- Do not expose SSH private keys, Terraform state files, cloud credentials, passwords, access keys, secret keys, account IDs, or subscription IDs.

---

# Completion Checklist

- [ ] Task 1: `ansible-adhoc-lab` project structure created
- [ ] Task 1: `.gitignore` updated for Terraform files
- [ ] Task 2: Terraform configuration created
- [ ] Task 2: Server roles defined for either three or four VMs
- [ ] Task 2: `count` or `for_each` used
- [ ] Task 2: SSH restricted to the controller public IP
- [ ] Task 2: HTTP allowed only for web hosts
- [ ] Task 2: Terraform output maps roles to public IPs
- [ ] Task 3: Terraform initialized successfully
- [ ] Task 3: Terraform configuration validated
- [ ] Task 3: Terraform apply completed successfully
- [ ] Task 3: All selected VMs are running
- [ ] Task 4: SSH key-based access works for every VM
- [ ] Task 5: `inventory.ini` contains `web`, `app`, and `db` groups
- [ ] Task 5: `ansible-inventory -i inventory.ini --graph` shows the correct groups
- [ ] Task 6: `ansible all -i inventory.ini -m ping` returns `SUCCESS`
- [ ] Task 6: Ad-hoc commands run successfully
- [ ] Task 6: `--become` was used for package and service tasks
- [ ] Task 6: Nginx is active on the `web` group
- [ ] Screenshots 1–17 are included
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
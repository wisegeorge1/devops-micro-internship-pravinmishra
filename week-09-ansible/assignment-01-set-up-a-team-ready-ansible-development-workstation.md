# Assignment 01 — Set Up a Team-Ready Ansible Development Workstation

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will prepare an isolated and reusable Ansible development workstation.

You will install Ansible and supporting tools inside a Python virtual environment, configure VS Code, prepare SSH access, configure Git and pre-commit hooks, and document the complete setup.

This workstation will be used as the Ansible controller in upcoming assignments.

---

# Task 1 — Create and Initialize the Ansible Workspace

## Goal

Create the assignment workspace, initialize a Git repository, prepare the required directories, and add Git ignore rules for local and sensitive files.

### Evidence

#### Screenshot 1 — Terminal showing the `ansible-onboarding` path, `ls -la` output, and `git status` confirming the Git repository is on the `main` branch

![ass-1-ss1](/week-09-ansible/screenshots/ASS-1-SS-1a.png)
![ass-1-ss1](/week-09-ansible/screenshots/ASS-1-SS-1b.png)

---

# Task 2 — Create the Virtual Environment and Install Ansible Tools

## Goal

Create an isolated Python virtual environment and install Ansible and the required validation tools without modifying the system Python environment.

### Evidence

#### Screenshot 2 — Terminal showing the active `(.venv)` environment, `which ansible`, `ansible --version`, `ansible-lint --version`, `yamllint --version`, and `pre-commit --version`

![ass-1-ss2](/week-09-ansible/screenshots/ASS-1-SS-2.png)

---

# Task 3 — Configure VS Code for Ansible Development

## Goal

Configure Visual Studio Code to use the project’s Python virtual environment and provide validation support for Python, YAML, and Ansible files.

### Evidence

#### Screenshot 3 — VS Code Extensions panel showing the Ansible, YAML, and Python extensions installed

![ass-1-ss3](/week-09-ansible/screenshots/ASS-1-SS-3.png)

---

#### Screenshot 4 — VS Code showing `.vscode/settings.json` and `.editorconfig` open side by side, with the required settings clearly visible

![ass-1-ss4](/week-09-ansible/screenshots/ASS-1-SS-4.png)

---

# Task 4 — Create the Baseline Ansible Configuration

## Goal

Create a reusable `ansible.cfg` file containing the default settings that will be used in this workspace and upcoming Ansible assignments.

### Evidence

#### Screenshot 5 — `ansible.cfg` open in VS Code or another editor, showing the complete configuration

![ass-1-ss5](/week-09-ansible/screenshots/ASS-1-SS-5.png)

---

#### Screenshot 6 — Terminal showing `ansible --version` with the `ansible.cfg` path and the output of `ansible-config dump --only-changed`

![ass-1-ss6](/week-09-ansible/screenshots/ASS-1-SS-6.png)

---

# Task 5 — Configure SSH Readiness

## Goal

Prepare SSH key authentication, load the key into the SSH agent, configure reusable SSH client settings, and understand how trusted host fingerprints are stored.

### Evidence

#### Screenshot 7 — Terminal showing `ssh-add -l` with the ED25519 key loaded and the SSH configuration verification output

![ass-1-ss7](/week-09-ansible/screenshots/ASS-1-SS-7.png)

---

# Task 6 — Configure Git Identity and Pre-commit Hooks

## Goal

Configure your Git identity and install pre-commit hooks that validate YAML and Ansible files before commits are created.

### Evidence

#### Screenshot 8 — Terminal showing your Git full name, Git email, default branch, successful `pre-commit install` output, and `.git/hooks/pre-commit`

![ass-1-ss8](/week-09-ansible/screenshots/ASS-1-SS-8.png)

---

# Task 7 — Test the Complete Workstation Setup

## Goal

Verify that Ansible, the linting tools, Git hooks, SSH agent, and Git ignore rules are working correctly.

### Evidence

#### Screenshot 9 — Terminal showing `pre-commit run --all-files` completing successfully

![ass-1-ss9](/week-09-ansible/screenshots/ASS-1-SS-9.png)

---

#### Screenshot 10 — Terminal showing `ansible --version` with the project configuration path and `ssh-add -l` with the ED25519 key loaded

![ass-1-ss10](/week-09-ansible/screenshots/ASS-1-SS-10.png)

---

# Task 8 — Create the README and Onboarding Checklist

## Goal

Document the completed Ansible workstation setup and create a reusable checklist for preparing another workstation in the future.

### Evidence

#### Screenshot 11 — Terminal showing the final `ansible-onboarding` project structure

![ass-1-ss11](/week-09-ansible/screenshots/ASS-1-SS-11.png)

---

#### Screenshot 12 — VS Code Markdown preview showing your full name, project summary, and part of the “New Machine? Do This” checklist

![ass-1-ss12](/week-09-ansible/screenshots/ASS-1-SS-12.png)

---

# Assignment Questions

Answer the following in your own words:

**1. What is one feature that makes your workstation setup team-friendly?**

The setup is team friendly because it uses a project specific .venv, ansible.cfg, .gitignore, and pre-commit configuration. These files provide a consistent development and validation workflow that team members can reproduce on their own machines.

---

**2. What is one pitfall you avoided while completing the setup?**

A key pitfall avoided was installing Ansible and its Python dependencies globally with pip. Using the project specific   .venv keeps dependencies isolated and reduces the risk of conflicts with other Python projects or system packages. The setup also ensures that the SSH agent is configured for secure key based authentication without exposing or committing the private SSH key.

---

**3. Why should Ansible be installed inside a Python virtual environment?**

Installing Ansible inside a Python virtual environment (.venv) is a best practice for Python based tool management, particularly in production and automated CI/CD environments. Key Reasons to Use a Virtual Environment include but not limited to the following;

Dependency Isolation: Ansible relies on Python libraries (such as boto3 for AWS, azure cli or azure-mgmt-* for Azure, and paramiko for SSH). Installing Ansible globally can cause version conflicts if system level Python packages update or require different versions of shared dependencies.

Avoid System Python Package Corruption: Modern Linux distributions (such as Ubuntu 22.04+ or Alpine) enforce PEP 668, marking the system Python environment as externally managed. Running global pip install commands can break system management tools (like apt or apk).

Version Consistency Across Environments: Creating a .venv environment allows you to pin exact Ansible and module versions via a requirements.txt file. This guarantees that local development machines, CI/CD runners (like Azure Pipelines or GitHub Actions), and target hosts execute playbooks against identical dependencies.

No Root/Sudo Permissions Required: Installing packages globally using sudo pip poses security risks and modifies system binaries. Virtual environments live inside user space, eliminating the need for root privileges during installation.

Clean Cleanup & Maintenance: Deleting an environment is as simple as removing its directory (e.g., rm -rf .venv), whereas removing globally installed pip packages often leaves orphaned dependencies behind.

---

**4. Why must SSH private keys and `.venv/` remain outside version control?**

Keeping SSH private keys and Python virtual environments (.venv/) out of version control systems like Git is a critical practice for security, repository health, and operational performance.
1. SSH Private Keys Must Remain Secret
Security & Authentication Exposure: An SSH private key serves as a cryptographic credential that grants access to servers, repositories, and cloud resources. Pushing a private key to a repository, even a private one, exposes your infrastructure to unauthorized access, potential credential scraping, and privilege escalation.

Non-Repudiation Violation: SSH keys identify a specific user or machine. Sharing private keys via Git compromises individual accountability and breaks audit trails.

Git History Persistence: Once a key is committed, it remains stored in Git's object database history even if you delete the file in a subsequent commit. Fully purging a leaked key requires rewriting commit history across all branches or immediately revoking and rotating the key.

2. .venv/ Contains Environment Specific Binaries & Dependencies
System & Operating System Incompatibility: A .venv/ directory contains platform dependent binaries, C-extensions, and hardcoded absolute paths specific to the system where it was created. Committing a virtual environment generated on macOS or Windows will break if pulled down on a Linux machine or CI/CD runner.

Repository Bloat: Virtual environments contain hundreds or thousands of third party package files, taking up tens or hundreds of megabytes. Committing them inflates the repository size, slows down git clone, git pull, and git push operations, and degrades performance.

Redundant Dependency Management: Python projects handle dependencies using lightweight manifest files (such as requirements.txt, pyproject.toml, or Pipfile). Instead of tracking the installed code, you commit the manifest so collaborators can generate their own clean, isolated .venv/ locally via python3 -m venv .venv and pip install -r requirements.txt.

---

# Required Files

Confirm that the following files are included in your assignment workspace:

- [ ] `README.md`
- [ ] `requirements.txt`
- [ ] `.gitignore`
- [ ] `.editorconfig`
- [ ] `.vscode/settings.json`
- [ ] `ansible.cfg`
- [ ] `.pre-commit-config.yaml`
- [ ] `inventories/`
- [ ] `roles/`

---

# Submission Instructions

- Add all required screenshots in your submission.
- Full Name must be visible in required screenshots.
- All screenshots must be readable.
- Answer all assignment questions clearly in your own words.
- Do not expose SSH private-key contents, passwords, access tokens, API keys, credentials, private certificates, or other sensitive information.

---

# Completion Checklist

- [ ] Task 1: `ansible-onboarding` workspace created
- [ ] Task 1: Git initialized on the `main` branch
- [ ] Task 1: `.gitignore` created
- [ ] Task 2: Python virtual environment created
- [ ] Task 2: Virtual environment activated
- [ ] Task 2: Ansible installed inside `.venv`
- [ ] Task 2: `ansible-lint`, `yamllint`, and `pre-commit` installed
- [ ] Task 2: `requirements.txt` created
- [ ] Task 3: Required VS Code extensions installed
- [ ] Task 3: VS Code uses the Python interpreter from `.venv`
- [ ] Task 3: `.vscode/settings.json` created
- [ ] Task 3: `.editorconfig` created
- [ ] Task 4: `ansible.cfg` created
- [ ] Task 4: Ansible loads `ansible.cfg` from the project directory
- [ ] Task 5: ED25519 SSH key exists
- [ ] Task 5: SSH private key has not been exposed
- [ ] Task 5: SSH key loaded into the SSH agent
- [ ] Task 5: `~/.ssh/config` contains the required settings
- [ ] Task 5: `~/.ssh/known_hosts` exists
- [ ] Task 6: Git identity configured correctly
- [ ] Task 6: Pre-commit hooks installed
- [ ] Task 7: `pre-commit run --all-files` completes successfully
- [ ] Task 8: `README.md` contains your full name and workstation details
- [ ] Task 8: “New Machine? Do This” checklist contains 10–12 items
- [ ] All 12 required screenshots are included
- [ ] Assignment questions are answered
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
# Assignment 7 — AI-Assisted Azure Security Posture Audit

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash script that audits the Azure resources you deployed earlier this week — a virtual machine, a three-tier network with a Load Balancer, a Storage Account, and an Azure Database for MySQL server — for common security misconfigurations. You will connect that script to Claude Code as a reusable `/azure-audit` skill that explains findings and recommends a fix without ever running it, then fix one real finding yourself and prove the fix with a second audit run. This is the same read-only-evidence-then-human-fixes discipline from Week 3, now applied to Azure with the `az` CLI instead of Linux commands — and the cloud-agnostic counterpart to the AWS audit you built in Week 6.

---

# Task 1 — Confirm Your Resources and Create the Workspace

## Goal

Confirm your Azure CLI is authenticated and can see the VM, network, storage account, and MySQL server you built this week, then set up a workspace folder for the audit.

### Evidence

#### Screenshot 1 — `az account show` and `az vm list -d -o table` confirming your subscription and running VM (subscription ID partially blurred)

![runing-vm](/week-07-azure-cloud/screenshots/assignment-7-SS-1.png)

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` for this workspace that tells Claude what the audit covers and the safety rules it must follow: never run a mutating `az` command, never claim a finding without report evidence, and always let the human review and run any remediation.

### Evidence

#### Screenshot 2 — `CLAUDE.md` open in your editor showing the project overview, audit workflow, and safety rules

![claude](/week-07-azure-cloud/screenshots/assignment-7-SS-2.png)

---

# Task 3 — Use Agentic AI to Plan the Audit Before Writing the Script

## Goal

Ask Claude Code to read `CLAUDE.md` and propose a read-only, four-check audit plan (NSG rules open to `0.0.0.0/0` on port 22 or 3389, storage account public blob access, VM disk encryption status, and Azure Database for MySQL public network access) — without creating or editing any file yet.

### Evidence

#### Screenshot 3 — Claude Code showing the four-check plan, with no files created or modified

![four-check-plan](/week-07-azure-cloud/screenshots/assignment-7-SS-3a.png)
![four-check-plan](/week-07-azure-cloud/screenshots/assignment-7-SS-3b.png)
![four-check-plan](/week-07-azure-cloud/screenshots/assignment-7-SS-3c.png)
![four-check-plan](/week-07-azure-cloud/screenshots/assignment-7-SS-3d.png)

---

# Task 4 — Build the Azure Audit Bash Script

## Goal

Write a Bash script that runs the four checks from Task 3 using read-only `az` commands, writes a PASS/WARN/FAIL report with your Full Name, and exits with a different code for a healthy, warning, or failing result. Validate it with `bash -n` and make it executable.

### Evidence

#### Screenshot 4 — Your script open in your editor, showing the check functions and the `az` commands they call

![check-function](/week-07-azure-cloud/screenshots/assignment-7-SS-4.png)

---

#### Screenshot 5 — Output of `bash -n` (no syntax errors) and `ls -l` showing the script is executable

![output-bash](/week-07-azure-cloud/screenshots/assignment-7-SS-5.png)

---

# Task 5 — Run the Script and Review the Baseline Report

## Goal

Run the script against your live resources and read the report honestly, even if it shows a real finding — do not fix anything yet.

### Evidence

#### Screenshot 6 — Script output showing your Full Name and all four checks with a PASS, WARN, or FAIL result

![script-output](/week-07-azure-cloud/screenshots/assignment-7-SS-6.png)

---

# Task 6 — Create and Run the /azure-audit Skill

## Goal

Create a Claude Code skill restricted to read-only tools (no `Write`) that runs your script, reads the report, and explains every finding with the risk of leaving it unresolved — without ever running a remediation command itself.

### Evidence

#### Screenshot 7 — Your skill file's frontmatter showing `allowed-tools` without `Write`

![skills-frontmatter](/week-07-azure-cloud/screenshots/assignment-7-SS-7.png)

---

#### Screenshot 8 — `/azure-audit` output showing the baseline findings and Claude's explanation

![audit-output](/week-07-azure-cloud/screenshots/assignment-7-SS-8a.png)
![audit-output](/week-07-azure-cloud/screenshots/assignment-7-SS-8b.png)
![audit-output](/week-07-azure-cloud/screenshots/assignment-7-SS-8c.png)
![audit-output](/week-07-azure-cloud/screenshots/assignment-7-SS-8d.png)

---

# Task 7 — Fix a Real Finding and Re-Verify

## Goal

Pick one WARN or FAIL finding (or deliberately open an NSG rule to port 22 from `0.0.0.0/0` if your baseline was already clean), save that failing report, run the remediation command yourself — scoped to your own IP, not left open — and confirm the second audit run shows it resolved.

### Evidence

#### Screenshot 9 — Saved report showing the original finding before the fix

![initial-findings](/week-07-azure-cloud/screenshots/assignment-7-SS-9.png)

---

#### Screenshot 10 — Terminal output of the remediation command you ran yourself

![remediation-output](/week-07-azure-cloud/screenshots/assignment-7-SS-10.png)

---

#### Screenshot 11 — Second `/azure-audit` run (or report) showing the finding resolved

![second-audit-run](/week-07-azure-cloud/screenshots/assignment-7-SS-11a.png)
![second-audit-run](/week-07-azure-cloud/screenshots/assignment-7-SS-11b.png)

---

### Notes

Compare this assignment to the AWS audit you built in Week 6: which finding categories map to each other across the two clouds, and what stayed exactly the same about the workflow even though the `az`/`aws` commands are completely different?

The two assignments are essentially the same audit-and-remediation pattern translated from AWS to Azure. The cloud resources and CLI syntax change, but the security concepts and workflow remain remarkably consistent.

Finding categories that map across AWS and Azure
| Security concept	      |  AWS assignment	                                         |   Azure assignment                               |
| :-----------------------|:---------------------------------------------------------|:-------------------------------------------------|
| Network exposure	      |  Security Groups with overly open inbound rules	         |   NSG rules open to 0.0.0.0/0 on SSH/RDP         |
| Public storage exposure |  S3 static site / S3 bucket public-access configuration  |   Storage Account public blob access             |
| Compute security	      |  EC2 instance security/configuration	                 |   Azure Virtual Machine disk encryption          |
| Database exposure	      |  RDS database security/network configuration	         |   Azure Database for MySQL public network access |
| Disk/storage security	  |  EBS volume configuration	                             |   VM disk encryption status                      |

The mapping isn't perfectly one to one at the resource level. For example, EBS volume security maps conceptually to Azure managed disk encryption, while AWS Security Groups and Azure NSGs are the closest direct network control equivalents.

## What stayed exactly the same
The important part of the assignment is not the CLI. It's the control workflow:

1. Gather → 2. Analyze → 3. Human Act → 4. Verify

Both assignments follow this sequence:

Gather: Run a read-only audit against the cloud environment.
Analyze: Claude Code interprets the evidence and identifies security/cost findings.
Human Act: Claude recommends a remediation, but the human performs the change manually.
Verify: Run the audit again and use the new evidence to prove that the finding was resolved.
The same safety boundary also carries over:

The audit can observe and recommend, but it cannot remediate.

So AWS might use:

aws s3 ...
aws ec2 ...
aws rds ...

while Azure uses:

az storage ...
az vm ...
az network ...
az mysql ...

Those commands are completely different, but their role in the workflow is identical: collect evidence without changing the environment.

The key lesson
The assignment is teaching a cloud agnostic operational pattern, not AWS  or Azure specific command memorization:

Evidence first → AI analysis → human decision/action → evidence-based verification.

That's why the Azure assignment explicitly describes itself as the cloud agnostic counterpart to the AWS audit. The aws → az substitution is implementation detail; the read only evidence discipline and human remediation boundary are the actual skill being carried from Week 6 into Azure.

---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 11 required screenshots
- Do not expose your Azure subscription ID, tenant ID, client secrets, or connection strings

---

# Completion Checklist

- [ ] Task 1: Azure resources confirmed and workspace created (Screenshot 1)
- [ ] Task 2: `CLAUDE.md` created with project context and safety rules (Screenshot 2)
- [ ] Task 3: Claude produced a read-only four-check plan before any script existed (Screenshot 3)
- [ ] Task 4: Audit script built, syntax-checked, and executable (Screenshots 4–5)
- [ ] Task 5: Baseline audit run and reviewed honestly (Screenshot 6)
- [ ] Task 6: `/azure-audit` skill created with no `Write` permission and run successfully (Screenshots 7–8)
- [ ] Task 7: A real finding fixed by you (not Claude) and re-verified as resolved (Screenshots 9–11)
- [ ] Notes comparing this to the Week 6 AWS audit completed
- [ ] No subscription IDs, tenant IDs, or credentials exposed

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

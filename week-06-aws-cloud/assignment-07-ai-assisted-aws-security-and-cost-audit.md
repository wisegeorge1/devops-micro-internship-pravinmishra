# Assignment 7 — AI-Assisted AWS Security and Cost Audit

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash script that audits the AWS resources you deployed earlier this week — your S3 static site, EC2 instance(s), security groups, RDS database, and EBS volumes — for common security and cost misconfigurations.

You will then connect that script to Claude Code as a reusable `/aws-audit` skill that explains what it found and recommends a fix, without ever making the fix itself.

Finally, you will find a real misconfiguration in your own account, apply the fix yourself, and prove it worked with a second audit run.

---

# Task 1 — Confirm Your AWS Resources and Set Up Your Workspace

## Goal

Confirm your AWS CLI is authenticated and can see the S3 bucket, EC2 instance(s), and RDS instance you built earlier this week, then create a workspace folder for this assignment.

### Evidence

#### Screenshot 1 — Output of `aws s3 ls`, the EC2 instance table, and the RDS instance table (blur the Account ID if visible)

![ss1](/week-06-aws-cloud/screenshots/ass7-ss1.png)

---

#### Screenshot 2 — Output of `pwd` and `find . -maxdepth 4 -type d | sort`

![ss2](/week-06-aws-cloud/screenshots/ass7-ss2.png)

---

### Notes You Must Write (Very Important)

**1. Which resources from this week's earlier assignments did you see in the listings?**

S3 Bucket, RDS, Instance, EC2 Instance

**2. Why must you confirm your resources exist before writing an audit script against them?**

We confirm resource exist before writing scripts in order to have a form and reference with which we base our scripts on, a script cannot be written in vacumm where
nothing is available.

---

# Task 2 — Define Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` in your workspace that tells Claude the audit script is read-only, that it must never run a command that creates, modifies, or deletes an AWS resource, and that any remediation must be recommended, never executed automatically.

### Evidence

#### Screenshot 3 — `CLAUDE.md` open in VS Code showing all four sections

![ss3](/week-06-aws-cloud/screenshots/ass7-ss3.png)

---

### Notes You Must Write (Very Important)

**1. Why should Claude never be given permission to run `revoke-security-group-ingress` itself, even if the fix is obviously correct?**

Claude should not be given permission to run revoke-security-group-ingress or any other kind of sensitive commands itself because AI general hallucinates sometimes and mistakes on the part of Claude might result in the disruption or even destruction of sensitive infrastructure or code which can lead to potential loss.

**2. Which rule prevents Claude from claiming a finding that the report does not support?**

The safety rules prevents claude from claiming what the report does not support because it sets a boundary for claude based on industry relevant standards and procedure, so claude's decisions are based on those limits.


---

# Task 3 — Plan the Audit with Claude Code

## Goal

Ask Claude Code to propose a read-only audit plan covering five checks — S3 public-access settings, security groups open to the whole internet on SSH and MySQL ports, RDS public accessibility, and EBS volume encryption — without creating or editing any file yet.

### Evidence

#### Screenshot 4 — Claude Code showing the five-check plan

![ss4](/week-06-aws-cloud/screenshots/ass7-ss4a.png)
![ss4](/week-06-aws-cloud/screenshots/ass7-ss4b.png)
![ss4](/week-06-aws-cloud/screenshots/ass7-ss4c.png)
![ss4](/week-06-aws-cloud/screenshots/ass7-ss4d.png)

---

### Notes You Must Write (Very Important)

**1. Which part of this task represents the Gather phase?**

The read-only AWS CLI queries that were executed (describe-security-group-rules, get-public-access-block, describe-volumes, describe-db-instances) to inspect infrastructure state directly from the AWS APIs represents the gather phase

**2. Did every proposed command start with `describe-`, `get-`, or `list-`? Why does that matter?**

Yes, these command prefixes are basically read only syntaxes and cannot cause any kind of harm during execution. It matters because we do not want claude to make any kind of alterations like creation of a report or updating and deletion of any sort as specified in the safety boundaries we gave it.

---

# Task 4 — Build the AWS Audit Script

## Goal

Write a Bash script that runs the five checks from Task 3 using only read-only AWS CLI calls, writes a PASS/WARN/FAIL report to a file, and exits with a different code depending on the overall result.

Make it executable and confirm it has no syntax errors.

### Evidence

#### Screenshot 5 — Top section of `aws-audit.sh` showing the variables and the checks array

![ss5](/week-06-aws-cloud/screenshots/ass7-ss5.png)

---

#### Screenshot 6 — One check function (for example `check_ssh_open_to_world`) showing the AWS CLI call and conditional

![ss6](/week-06-aws-cloud/screenshots/ass7-ss6.png)

---

#### Screenshot 7 — Output of `bash -n scripts/aws-audit.sh` and `ls -l scripts/aws-audit.sh`

![ss7](/week-06-aws-cloud/screenshots/ass7-ss7.png)

---

### Notes You Must Write (Very Important)

**1. What is stored in the checks array, and how does the loop use it?**

The checks array stores the names of five Bash functions that perform individual AWS security and configuration checks.

checks=(
check_s3_public_access
check_ssh_open_to_world
check_mysql_open_to_world
check_rds_public_access
check_ebs_encryption
)

The five functions check:

check_s3_public_access — verifies whether the S3 bucket blocks and ignores public ACLs.

check_ssh_open_to_world — checks whether SSH (port 22) is open to everyone (0.0.0.0/0).

check_mysql_open_to_world — checks whether MySQL (port 3306) is open to everyone.

check_rds_public_access — determines whether the RDS instance is publicly accessible.

check_ebs_encryption — checks for unencrypted EBS volumes.

The for loop iterates through each function name and executes it:


for check_function in "${checks[@]}"
do
    "$check_function"
done

Here, "${checks[@]}" expands to all elements of the array, while "$check_function" executes the function whose name is currently stored in the variable.

In summary: The array makes the audit modular and easy to maintain. New checks can be added by defining another function and including its name in the array, without changing the loop itself.

**2. Why does every AWS CLI call in this script use `--query` and `--output text` instead of parsing raw JSON?**

The script uses --query to extract only the specific information needed from an AWS CLI response, and --output text to return that information in a simple textual format that Bash can use in variables and conditional statements.

For example:


bash
publicly_accessible=$(aws rds describe-db-instances \
    --db-instance-identifier "$rds_instance_id" \
    --region "$aws_region" \
    --query 'DBInstances[0].PubliclyAccessible' \
    --output text)
Instead of returning a complete JSON document containing many RDS properties, the command returns a value such as False.  The script can then compare that value directly:
if [ "$publicly_accessible" = "False" ]
then
    mark_pass "RDS instance is not publicly accessible"
fi
The main benefits are:
Simpler parsing: Bash receives a value it can readily compare or use in arithmetic.
Less unnecessary output: The script retrieves only the fields it needs.
Improved readability: The intended security check is easier to understand.
Fewer dependencies: It avoids requiring an additional JSON parser such as jq.
For numeric checks, --query can calculate a count directly. For example:
--query 'length(Volumes[])' --output text
This returns the number of volumes matching the API response, rather than the full volume data.

One important caveat: --query and --output text do not automatically handle every AWS CLI error. In this script, commands also use 2>/dev/null || echo "..." to suppress error messages and provide fallback values. Some fallbacks, such as treating a failed SSH-rule query as zero, could incorrectly produce a passing result when the AWS request actually failed. Robust audit scripts should distinguish a genuine clean result from a failed API call.

**3. Why does the script use different exit codes for HEALTHY, WARN, and FAIL?**

The script uses exit codes to communicate the overall audit result to the operating system, automation tools, and CI/CD pipelines.

The logic is defined in print_summary():


bash
if [ "$failure_count" -gt 0 ]
then
    overall_status="FAIL"
    script_exit_code=2
elif [ "$warning_count" -gt 0 ]
then
    overall_status="WARN"
    script_exit_code=1
else
    overall_status="HEALTHY"
    script_exit_code=0
fi
The exit codes mean:
Exit code
Status Meaning

0
HEALTHY

No warnings or failures were recorded.
1
WARN

No failures occurred, but one or more warnings were recorded.
2
FAIL

At least one security check failed. The script prioritizes failures over warnings. If both are present, the overall status is FAIL, and the exit code is 2.
These distinct codes are useful because other programs can respond automatically: Exit code 0: Continue the deployment or mark the audit as successful.
Exit code 1: Flag the audit for review while allowing a workflow to handle the warning according to policy. Exit code 2: Stop a deployment or trigger an alert because a security issue was detected. The script also prints the overall status and exit code in the report, making the result understandable to a person reading the file.

---

# Task 5 — Run the Baseline Audit

## Goal

Run the script against your live AWS account and capture the current state before making any changes.

### Evidence

#### Screenshot 8 — Output of `./scripts/aws-audit.sh` showing your Full Name and all five checks

![ss8](/week-06-aws-cloud/screenshots/ass7-ss8.png)

---

#### Screenshot 9 — Output showing the captured exit code and final summary

![ss9](/week-06-aws-cloud/screenshots/ass7-ss9.png)

---

### Notes You Must Write (Very Important)

**1. What is the overall status of your baseline audit?**

Overall Status: FAIL
Exit Code: 2

**2. Did any check return FAIL or WARN? If so, which one, and what evidence did it show?**

yes, S3 bucket = FAIL,  EBS volume =  WARN
[FAIL] S3 bucket 'pravin-portfolio-oweigeorge-us-east-1' does not fully block public ACLs (BlockPublicAcls=None, IgnorePublicAcls=None)
[WARN] 1 EBS volume(s) are not encrypted

**3. If every check passed, what does that tell you about the security posture of your account so far?**

If every check passed then it would indicate that the deployment is hardened and security breaches would be minimal.

---

# Task 6 — Build and Run the /aws-audit Skill

## Goal

Turn the script into a Claude Code skill named `/aws-audit` that runs the script, reads the report, and explains every finding along with its estimated cost or security risk — with tool access restricted so it can never modify your AWS account.

### Evidence

#### Screenshot 10 — `SKILL.md` showing the frontmatter, tool restrictions, and safety rules

![ss10](/week-06-aws-cloud/screenshots/ass7-ss10.png)

---

#### Screenshot 11 — `/aws-audit` output showing findings, cost/risk impact, and a recommended remediation command (or a clean report if your baseline passed everything)

![ss11](/week-06-aws-cloud/screenshots/ass7-ss11.png)
![ss11](/week-06-aws-cloud/screenshots/ass7-ss11a.png)
![ss11](/week-06-aws-cloud/screenshots/ass7-ss11b.png)
![ss11](/week-06-aws-cloud/screenshots/ass7-ss11c.png)

---

### Notes You Must Write (Very Important)

**1. Why does this skill have Bash, Read, and Grep, but not Write?**

Skill has bash, read and Grep because we do not want to give claude the capability of altering the state of our AWS resources, so it is created this way to enable claude access and make recommendations but not make any alterations.

**2. What part is performed by Bash, and what part is performed by Claude?**

Bash does the script execution and output reporting of the AWS deployment while claude analyses the output to give necessary advice on remediation in case it notices on breaches or shortcomings in the setup.

**3. Why is estimating cost/risk impact something the AI adds on top of a plain PASS/FAIL script?**
The context and boundaries which we have outlined for claude to measure potential risks and failure impact is what forms the basis for its estimating the cost/risk potential.

---

# Task 7 — Fix a Real Finding and Re-Verify

## Goal

Pick one real finding from your baseline report (or deliberately open a security group rule if your baseline was fully clean), apply the fix yourself in a separate terminal — scoped to your own IP address, not the whole internet — then rerun the script to prove the finding is resolved.

### Evidence

#### Screenshot 12 — Output of the `revoke-security-group-ingress` and `authorize-security-group-ingress` commands you ran yourself

![ss12](/week-06-aws-cloud/screenshots/ass7-ss12.png)

---

#### Screenshot 13 — Rerun of `./scripts/aws-audit.sh` showing the finding is now PASS

![ss13](/week-06-aws-cloud/screenshots/ass7-ss13.png)

---

### Notes You Must Write (Very Important)

**1. Which exact finding did you fix, and what command did you run?**

I fixed the EBS Volume encryption and s3 bucket public access

**2. Why did you scope the new rule to your own IP address instead of leaving it open to `0.0.0.0/0`?**

Because I would not want unauthorised access to the ec2 instance or deployment

**3. Did Claude execute the remediation command, or did you? Why does that matter?**

I did the remediation on my own. it matters because I would like to be in control of the whole deployment

**4. Which phase of the Agentic Loop does the Bash script represent? Which phase does Claude's explanation represent? Which phase is you running the fix?**

The bash script represents the gather phase where all necessary configuration data is derived from AWS portal.

Claude's explanation represents the reasoning / Analysis Phase where all configuartion data gathered is analysed and the deployments current posrture in evaluated against best practices and suggestions for remediation are highlighted.

Me running the fix is the execution/implementation phase where i get to apply whatever remediation I may have approved after going throung claude's recommendations.

---

# LinkedIn Post (Required)

## Goal

Create a LinkedIn post including:

- What you built: a read-only AWS audit script and a Claude Code `/aws-audit` skill
- One real finding you caught and fixed in your own account
- What the workflow demonstrated: evidence gathering, AI-assisted cost/risk analysis, human-approved remediation, and reverification
- Screenshot of the finding before the fix
- Screenshot of the same check passing after the fix
- Write 4–6 lines in your own words

Suggested tags:

`#DMIByPravinMishra #AWS #AgenticAI #ClaudeCode #DevOps`

### Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

<https://www.linkedin.com/posts/wisgeorge1_devops-cloudcomputingnbsp-continuouslearning-ugcPost-7519163583130128384-j1Kf/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

#### Screenshot of Published LinkedIn Post

![ss14](/week-06-aws-cloud/screenshots/ass7-linkedin.png)

---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:

- All 13 required task screenshots
- Answers to every **Notes You Must Write** question
- `CLAUDE.md`
- `scripts/aws-audit.sh`
- `.claude/skills/aws-audit/SKILL.md`
- `reports/aws-audit-report.txt` baseline report and the reverified report from Task 7
- GitHub folder or repository URL containing the assignment files
- Your Full Name visible in the required outputs
- LinkedIn post URL
- Screenshot of the published LinkedIn post
- GitHub repository URL (containing all assignment files)

---

# Completion Checklist

- [ ] Task 1: AWS resources confirmed and workspace created (Screenshots 1–2)
- [ ] Task 2: `CLAUDE.md` created with project context and safety rules (Screenshot 3)
- [ ] Task 3: Claude produced a read-only five-check audit plan before any script existed (Screenshot 4)
- [ ] Task 4: `aws-audit.sh` built, executable, and passes `bash -n` (Screenshots 5–7)
- [ ] Task 5: Baseline audit captured and saved with Full Name visible (Screenshots 8–9)
- [ ] Task 6: `/aws-audit` skill loads and runs successfully with no Write permission (Screenshots 10–11)
- [ ] Task 7: A real finding was fixed by you and reverified as PASS (Screenshots 12–13)
- [ ] Skill never executed a remediation command
- [ ] New security group rule is scoped to your own IP, not `0.0.0.0/0`
- [ ] All 13 required task screenshots are included
- [ ] All "Notes You Must Write" questions are answered in your own words
- [ ] No AWS credentials or unblurred account IDs exposed
- [ ] LinkedIn post published and URL submitted
- [ ] GitHub repository URL included in submission
- [ ] All assignment files committed and visible in GitHub repository

---

# Final Submission

Submit your GitHub repository URL containing all assignment files, screenshots, reports, and output.

### GitHub Repository URL

Paste your GitHub repository URL here:

https://github.com/wisegeorge1/devops-micro-internship-pravinmishra.git

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
# Assignment 6 — Building an AI-Assisted Git Safety Net (PR Ready Check)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In Week 2 you built Claude Code hooks that block a dangerous action *before* it happens (`PreToolUse`), and a restricted skill that could look but not touch (`allowed-tools` without `Write`). In this assignment you will discover that Git has the exact same idea, decades older: a **pre-commit hook** that blocks a commit before it's created.

You will build both halves of a real "PR Ready" workflow:

1. A **Git hook that follows fixed rules** — scans staged changes for hardcoded secrets and oversized files and refuses the commit. No AI involved, no guessing, just a rule that gives the same answer every time.
2. A **restricted Claude Code skill** (`/pr-ready`) that reads your staged diff and drafts a Pull Request title, description, and a short list of things worth a second look — the kind of judgment a fixed rule can't make (mixed changes, missing context, unclear intent). The skill never commits, pushes, or opens the PR. You do that yourself, using its draft as a starting point.

This mirrors the Agentic Loop from Week 3's Linux triage assignment: **Gather → Analyze → Human Act → Verify**. The hook and the skill both gather and analyze; only you act.

---

# Task 0 — Confirm Your Fork and Create a Feature Branch

## Goal

Confirm you are working in your own fork, then create a dedicated branch for this assignment.

### Evidence

#### Screenshot 1 — Output of git remote -v and git branch showing the new branch

![new-branch](/week-04-git-and-github/screenshots/new-branch.png)

---

### Notes

**1. Why create a dedicated branch instead of doing this work on main?**

Creating a dedicated branch instead of working directly on main is a standard Git workflow because it makes development safer, more organized, and easier to collaborate on.

---

# Task 1 — Stage a Change With Realistic Risk

## Goal

On your own fork of this repository (the one you've been submitting your DMI work in since onboarding), create a new branch and stage a change that a real reviewer should catch: a hardcoded-looking secret and a leftover debug statement.

### Evidence

#### Screenshot 1 — Output of  `git status` showing the staged file on feature/ai-pr-ready

![pr-staged](/week-04-git-and-github/screenshots/staged-file.png)

---

### Notes

**1. Why does this assignment use an obviously fake key instead of a real one?**

 - The assignment uses an obviously fake SSH key in order to prevent a security breach and for teaching purposes.
 - The assignment can show what an SSH key looks like without exposing sensitive information.
 

---

# Task 2 — Write a Real Git Pre-Commit Hook

## Goal

Create a tracked, shareable pre-commit hook that blocks a commit containing secret-like patterns or files over 1MB.

### Evidence

#### Screenshot 2 — `hooks/pre-commit` open in VS Code showing the full script


![pre-commit-file](/week-04-git-and-github/screenshots/pre-commit.png)

---

#### Screenshot 3 — Output of `git config core.hooksPath` confirming it points to `hooks`

![hooks-path](/week-04-git-and-github/screenshots/hooks-Path.png)

---

### Notes

**1. Why is `hooks/pre-commit` tracked in the repo instead of living only in `.git/hooks/`?**

This is because .git/hooks/ is not part of the Git repository, while a tracked hooks/pre-commit file is.
tracking hooks/pre-commit demonstrates how teams share automation. The hook can enforce standards such as:
Checking code formatting, Preventing commits that include secrets or credentials, Verifying documentation or tests.

By keeping the hook in the repository, everyone on the team can use the same automation instead of each developer maintaining a different local hook. So the tracked hooks/pre-commit file serves as the version controlled source of truth since the whole idea of Git in the first instance is version control, while .git/hooks/ is simply where Git executes hooks unless you've configured core.hooksPath to use the tracked location directly.

---

**2. Compare this to `PreToolUse` from Week 2 Assignment 6. What does each one intercept, and what do they have in common?**

**Differences in what they intercept**
hooks/pre-commit and PreToolUse are both examples of interception points,they allow you to inspect or enforce rules before an action takes place. The difference is what they intercept.
Git pre-commit hook intercepts a Git commit before it is created while a PreToolUse intercepts an AI tool call before the tool execute.

**What they have in common**
Although they operate in different environments, they share the same core idea:
 - They are preventive controls, not reactive ones.
 - They intercept an action before it happens.
 - They can enforce policies automatically.
 - They improve quality and safety.
 - They can block an operation if requirements aren't met.

Both are examples of guardrails that help ensure workflows follow defined standards before changes are made or actions are executed.

---

# Task 3 — Prove the Hook Blocks the Risky Commit

## Goal

Attempt to commit the staged file from Task 1 and show the hook rejecting it.

### Evidence

#### Screenshot 4 — Terminal showing `git commit` rejected with the hook's "BLOCKED" message naming the exact file

![blocked-commit](/week-04-git-and-github/screenshots/commit-blocked.png)

---

### Notes

**1. Which line in `hooks/pre-commit` matched your fake key, and why did it match?**

if git diff --cached -- "$file" | grep -qE 'AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|PRIVATE) KEY-----'; then

It matched because the fake key contained the header -----BEGIN OPENSSH PRIVATE KEY-----, which fits the regular expression used to detect potential private keys. The hook blocks the commit based on the pattern, regardless of whether the key is genuine or intentionally fake.

---

**2. Could this hook have caught a poorly-named variable that stores a secret without the `AKIA` prefix? What does that tell you about the limits of a fixed rule like this?**

No, I don't think so, because the hook only searches for specific text patterns, not for the meaning of the code.

It tells me that these rules do have limitations because, fixed rules are precise but narrow, they can only detect what they've been explicitly programmed to recognize, anything that doesn't match those patterns may be missed, resulting in false negatives. At the same time, fixed rules can also produce false positives by flagging harmless example data or fake credentials that merely resemble real secrets.

---

# Task 4 — Build the `/pr-ready` Skill

## Goal

Create a manually invoked Claude Code skill that reads your staged changes and produces a PR-readiness report and a draft PR description — without writing, committing, or pushing anything itself.

### Evidence

#### Screenshot 5 — `SKILL.md` frontmatter showing `allowed-tools: Bash, Read, Grep` (no `Write`) and `disable-model-invocation: true`

![fontmatter](/week-04-git-and-github/screenshots/frontmatter.png)

---

#### Screenshot 6 — `/pr-ready` output while the risky file is still staged, showing it flagged the secret and/or debug statement

![pr-1](/week-04-git-and-github/screenshots/PR-1.png)
![pr-2](/week-04-git-and-github/screenshots/PR-2.png)
![pr-3](/week-04-git-and-github/screenshots/PR-3.png)

---

### Notes

**1. Why does `/pr-ready` have `Bash` and `Read` but not `Write`?**

/pr-ready has Bash and Read permissions because it only needs to inspect the repository and run commands such as git status, git diff, or git log to verify that the project is ready for a Pull Request. It does not have Write permission because it is not intended to modify files or the repository. This follows the principle of least privilege, where a tool is given only the minimum permissions required to perform its task, reducing the risk of accidental or unauthorized changes..

---

**2. The pre-commit hook and `/pr-ready` both looked at the same staged diff. Did they flag the same things? What did one catch that the other didn't?**

Although both tools examined the staged diff, they had different objectives. The pre-commit hook enforced security and quality rules by detecting potential secrets and oversized files before allowing a commit. /pr-ready focused on verifying that the repository and staged changes were ready for a Pull Request, checking workflow readiness rather than scanning for sensitive data. Together, they complement each other by protecting both the codebase and the development workflow.

---

# Task 5 — Fix the Issues and Re-Verify

## Goal

Remove the secret and debug statement, then prove both gates now pass clean.

### Evidence

#### Screenshot 7 — `git commit` succeeding after the fix (no BLOCKED message)

![no-blocked-commit](/week-04-git-and-github/screenshots/no-blocked-commit.png)

---

#### Screenshot 8 — Second `/pr-ready` run showing a clean risk report and a drafted PR title + description

![pr-ready-1](/week-04-git-and-github/screenshots/PR-ready-1.png)
![pr-ready-1](/week-04-git-and-github/screenshots/PR-ready-2.png)
![pr-ready-1](/week-04-git-and-github/screenshots/PR-ready-3.png)
![pr-ready-1](/week-04-git-and-github/screenshots/PR-ready-4.png)

---

### Notes

**1. What exactly did you change to satisfy the pre-commit hook?**

To satisfy the pre-commit hook, I removed the content that matched the hook's secret detection rule before committing. The hook was configured to block staged changes containing patterns such as AWS access keys or private key headers like -----BEGIN OPENSSH PRIVATE KEY-----. After removing or replacing the fake key with no matching placeholder text and staging the updated file, the hook no longer detected a potential secret, and the commit succeeded.

---

# Task 6 — Push and Open a Pull Request Using the AI Draft

## Goal

Push your branch and open a real Pull Request, using `/pr-ready`'s drafted title and description as your starting point — read it critically and edit before you use it.

**Important:** Open this Pull Request with base repository set to **your own fork** — not the shared upstream `pravinmishraaws/devops-micro-internship-pravinmishra` repository. This assignment's hook and skill files are your own practice work, not a change meant for the shared class repo.

### Evidence

#### Screenshot 9 — Your Pull Request showing the base repository is your own fork, plus the title and description, with the `/pr-ready` draft visible for comparison (paste it in the PR conversation or your notes below)

![pull-forked-repo](/week-04-git-and-github/screenshots/pull-fork-repo.png)

---

#### PR Link

<https://github.com/wisegeorge1/devops-micro-internship-pravinmishra/tree/feature/ai-pr-ready>

---

### Notes

**1. What, if anything, did you edit in the AI's drafted PR description before using it? Why?**

I did not adjust the AI's PR description, because it is good for the purpose it was meant for.

---

**2. If you had blindly copy-pasted the AI's draft without reading it, what could go wrong?**

If I had copied the AI's draft without reading to understand what was therein, I could deploy a project that would be all together wrong.

---

**3. Why does this PR need to target your own fork instead of the shared upstream repository?**

This Pull Request needs to target my own fork first because I do not have direct write access to the shared upstream repository. Working through a fork allows me to make changes independently, test my updates, and submit them for review without affecting the original project.

---

# Task 7 — Map the Workflow to the Agentic Loop

## Goal

Explain this assignment's workflow using the same Gather → Analyze → Human Act → Verify structure from Week 3.

### Notes

**1. Which step(s) represent Gather?**

The Gather step represents the activities where information is collected before making decisions or performing checks.

In this assignment, the Gather steps include:

 - Forking the repository to create a personal copy of the project.
 - Cloning the forked repository to the local development environment.
 - Running git remote -v to collect information about the repository connections (origin and upstream).
 - Running git status to gather the current state of files and branches.
 - Reviewing staged changes with commands such as git diff --cached.
 - Collecting branch, commit, and Pull Request information before submission.
 - The pre-commit hook gathering staged file contents so it can scan them for possible secrets or oversized files.

These steps do not make decisions yet; they simply collect the information needed for the next stage, where tools analyze the data and humans decide what actions to take.

---

**2. Which step(s) represent Analyze?**

The Analyze step represents the activities where collected information is evaluated against rules, requirements, or expected standards to identify problems or confirm readiness.

In this assignment, the Analyze steps include:

  - The pre-commit hook scanning staged changes before a commit is created.
  - It checks for possible secrets, such as:
  - AWS access key patterns (AKIA...)
  - Private key formats (-----BEGIN OPENSSH PRIVATE KEY-----)
  - It also checks whether any staged file exceeds the 1MB size limit.
  - The /pr-ready workflow evaluating repository readiness before creating a Pull Request.
  - It checks whether the branch and changes are prepared correctly.
  - It verifies that the contribution follows the expected Git workflow.
  - Comparing the feature branch with the target branch before opening the Pull Request.
  - GitHub analyzes the differences between branches to show what changes will be submitted.

These steps are considered Analyze because they do not create changes themselves. Instead, they inspect information, apply rules, and provide feedback that helps determine whether the workflow can continue or whether corrections are needed.

---

**3. Which step is Human Act, and why must a human — not Claude — run `git commit`, `git push`, and open the PR?**

The Human Act step represents the point where the developer makes decisions and performs actions based on the information gathered and analyzed by the tools.

In this assignment, the Human Act steps include:

  - Reviewing the results from the pre-commit hook and fixing any issues found.
  - Deciding what changes should be included in the commit.
  - Writing or approving the commit message.
  - Reviewing the AI-generated Pull Request description and confirming that it accurately represents the work 
    completed.

    Running:
    git commit
    git push
    Opening the Pull Request on GitHub.

A human must perform actions like git commit, git push, and opening the Pull Request because these actions have real consequences on the repository and collaboration workflow. They require ownership, authorization, and judgment.

While an AI assistant like Claude can help explain commands, suggest commit messages, or draft a Pull Request description, it should not independently make decisions that affect shared repositories. A human developer must verify that:

  - The correct files are being committed.
  - No sensitive information is included.
  - The changes represent the intended work.
  - The correct branch and repository are being updated.
  - The Pull Request accurately communicates the contribution.

This follows the principle of human-in-the-loop development, where AI assists with analysis and productivity, but humans remain responsible for actions that change systems or publish work to others.

---

**4. Which step is Verify?**

The Verify step represents the final stage where the results of the workflow are checked to confirm that everything was completed correctly and the contribution is ready for review.

In this assignment, the Verify steps include:

Confirming that the commit was created successfully using Git history commands such as:

git log --oneline
Verifying that the feature branch was successfully pushed to the GitHub fork.
Checking that the GitHub Pull Request contains:
The correct source repository and branch.
The correct target repository and main branch.
The correct Pull Request title and description.
The expected file changes.
Reviewing the final Pull Request page to confirm that the contribution was submitted successfully and is ready for maintainer review.

The Verify stage is important because it ensures that the intended changes were actually delivered, the workflow was followed correctly, and no mistakes were introduced before the contribution reaches the shared project.

---

**5. In one or two sentences: why do you need *both* the fixed-rule pre-commit hook and the AI skill? Isn't one enough?**

They solve different problems that's why you need them. The fixed-rule pre-commit hook provides fast, consistent automated checks for known issues like secrets and oversized files, while the AI skill provides broader analysis, reasoning, and guidance that can identify context based problems that fixed rules may miss.

---

# Task 8 — LinkedIn Post

## Goal

Publish a LinkedIn post summarizing what you built and what you learned about combining fixed-rule safety checks with AI-assisted review.

### Evidence

#### LinkedIn Post URL

<https://www.linkedin.com/posts/wisgeorge1_devops-git-github-share-7486216962591764480-70Qo/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

## Key Learnings

Add 3-5 bullet points on what you learned this week.

- Human judgement is crucial for any automation task.
- I got to know that Git commands are endless and there is always one available for every task.
- Collaboration is the engine of team work. But controls must be in place to ensure plans are strictly followed.

---

# Submission Instructions

- Ensure `hooks/pre-commit` and `.claude/skills/pr-ready/SKILL.md` are committed to your GitHub repository
- Add all required screenshots to your submission
- All written answers must be in your own words
- Do not use a real secret or credential anywhere in your submission — the fake key in Task 1 is intentional and must stay clearly fake
- Open your Pull Request against your own fork, not the shared upstream repository
- Push your final changes to your forked repository
- Include your PR link and LinkedIn post URL

---

## GitHub Repository URL

Paste your forked repository URL here:

<https://github.com/wisegeorge1/devops-micro-internship-pravinmishra>

---

# Completion Checklist

- [ ] Branch `feature/ai-pr-ready` created with a staged file containing a fake secret and a debug statement
- [ ] `hooks/pre-commit` created and tracked in the repo (not only in `.git/hooks/`)
- [ ] `core.hooksPath` configured to point at `hooks/`
- [ ] Pre-commit hook shown blocking the risky commit
- [ ] `.claude/skills/pr-ready/SKILL.md` created with correct `allowed-tools` (no `Write`) and `disable-model-invocation: true`
- [ ] `/pr-ready` run against the risky diff and shown flagging issues
- [ ] Risky file fixed; `git commit` succeeds cleanly
- [ ] `/pr-ready` re-run showing a clean report and drafted PR title/description
- [ ] Pull Request opened using the AI draft as a starting point, with your own fork as the base repository (not upstream), PR link included
- [ ] Agentic Loop mapping (Task 7) completed in your own words
- [ ] LinkedIn post published and URL submitted
- [ ] All required screenshots added
- [ ] GitHub repository URL provided

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*

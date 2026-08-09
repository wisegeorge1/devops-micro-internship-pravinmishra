# Assignment 4 — Gotto Job: Backlog Refinement & Sprint 1 in Jira

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this 90-minute, time-boxed exercise, you will act as a Scrum team — or run in Solo Mode, playing every role yourself — to turn the Gotto Job template into a value-ordered backlog, estimate the work in story points, plan Sprint 1, open the burndown chart, and ship one small UI-only increment (text, color, spacing, a label, or a CTA — no backend changes).

---

# Task 1 — Roles & Mode Setup (Team vs Solo)

## Goal

Choose Team Mode or Solo Mode, and document how each Scrum role (Product Owner, Scrum Master, Dev Lead, DevOps Lead) was handled.

### Evidence

#### Screenshot 1 — Jira "Create project" screen, or the project sidebar after creation

![project-creation](/week-05-devops-lifecycle/screenshots/jira-create.png)

---

### Notes

Write one line for each role: PO (what you prioritized), SM (how you ensured process), Dev Lead (what you built), DevOps Lead (how you shipped).

Product Owner (PO): Prioritized the highest value UI improvement, focusing on clarifying the Gotto Job hero tagline to “Find Your Next Role Fast.”

Scrum Master (SM): Ensured the Scrum process by managing the backlog, estimating story points, planning Sprint 1, tracking progress, and keeping the work within the 90 minute time box.

Deve Lead: Built the UI only hero tagline enhancement and verified that the updated text was clear, readable, and visually consistent.

DevOps Lead: Committed the change with Git, deployed it to the AWS EC2 live environment, and verified the update through the public application URL.

---

# Task 2 — Create the Jira Project (Team-managed → Scrum)

## Goal

Create a Team-managed Scrum project named `Gotto Job – Team <#>` (Team Mode) or `Gotto Job – <YourName>` (Solo Mode).

### Evidence

#### Screenshot 2 — Project created page showing the project name and key

![project](/week-05-devops-lifecycle/screenshots/jira-project-1.png)

---

# Task 3 — Create the Epic

## Goal

Create the Epic `Improve Gotto Job UI discoverability & trust` to group the UI improvement initiative.

### Evidence

#### Screenshot 3 — Backlog showing the Epic panel with the Epic visible

![epic-visible](/week-05-devops-lifecycle/screenshots/epic-panel.png)

---

# Task 4 — Seed the Product Backlog (6–8 Stories + Fibonacci Points + Ranking)

## Goal

Create at least six Stories under the Epic, estimate each with 1, 2, or 3 story points, and rank them by value.

### Evidence

#### Screenshot 4 — Backlog showing the Epic and at least six Stories under it

![six-stories-epic](/week-05-devops-lifecycle/screenshots/6-stories.png)

---

#### Screenshot 5 — One Story opened showing its Story Points and acceptance criteria filled in

![1-story](/week-05-devops-lifecycle/screenshots/1-story-covered.png)

---

# Task 5 — Planning Poker (Estimate + Debate Notes)

## Goal

Confirm the Story Points (1, 2, or 3) for each Story and record brief reasoning for each estimate.

### Evidence

#### Screenshot 6 — Backlog showing Story Points visible, or two or three Stories opened showing their points

![story-points](/week-05-devops-lifecycle/screenshots/story-points.png)

---

### Notes

For each story, explain in one or two lines why it is a 1, 2, or 3 (mention any debate, even in Solo Mode).

Primary CTA color (1 point)
This was estimated at 1 point because it involves a straightforward CSS style change with minimal implementation risk and simple visual verification. In Solo Mode, I briefly considered 2 points due to checking color contrast and hover states across the site, but the effort remained small.

Job card typography (2 points)
This was estimated at 2 points because it requires updating typography styles and validating consistency across all job listing cards and responsive layouts. I debated 1 point, but cross page testing and UI refinement justified the higher estimate.

Remote badge (UI-only) (2 points)
This was estimated at 2 points because it involves conditional UI rendering for REMOTE jobs, badge styling, and verifying that only eligible cards display the badge correctly. I considered 3 points, but since no backend logic was required, the implementation complexity remained moderate.

Posted on <date> text (1 point)
This was estimated at 1 point because it only requires displaying a static, human readable date on each job card with minimal development effort. There was little debate since the change is simple and low risk.

Advanced search labels (2 points)
This was estimated at 2 points because multiple form labels and placeholders need updating while maintaining alignment, readability, and usability. I considered 1 point, but verifying the form layout across different screen sizes increased the effort.

Job detail Apply Now CTA (1 point)
This was estimated at 1 point because adding a prominent, accessible button with a simple mailto: or # link is a small UI enhancement with limited implementation complexity. No significant debate was needed.

Footer trust links (1 point)
This was estimated at 1 point because adding the About and Contact links and verifying keyboard accessibility and navigation requires minimal coding and testing. Although accessibility was considered, the task remained low complexity.


---

# Task 6 — Sprint Planning: Create Sprint 1 + Sprint Goal + Scope

## Goal

Create Sprint 1, move three or four Stories into it (approximately 3–6 points), set the Sprint Goal, and break each selected Story into Build, Verify, Deploy, and Screenshot Sub-tasks.

### Evidence

#### Screenshot 7 — Sprint 1 with the selected Stories inside it

![selected-stories](/week-05-devops-lifecycle/screenshots/3-6-stories.png)

---

#### Screenshot 8 — One Story showing the Sub-tasks created

![sub-task-story](/week-05-devops-lifecycle/screenshots/story-subtask.png)

---

# Task 7 — Reports: Open Burndown Chart

## Goal

Open the Burndown Chart and confirm it exists for Sprint 1. It is acceptable if the chart is not yet populated.

### Evidence

#### Screenshot 9 — Burndown Chart page opened, even if empty
![burn-down-chart-2](/week-05-devops-lifecycle/screenshots/burndown-2.png)

---

# Task 8 — Ship One Small Increment (Build + Deploy + Proof)

## Goal

Implement one small UI-only Story from Sprint 1, commit it, deploy it live, and move the Story and its Sub-tasks to Done in Jira.

### Evidence

#### Screenshot 10 — Jira board showing the Story moved to Done

![story-moved-done](/week-05-devops-lifecycle/screenshots/story-DONE.png)

---

#### Screenshot 11 — Git commit output

![git-commit-output](/week-05-devops-lifecycle/screenshots/commit-output.png)

---

#### Screenshot 12 — Live URL in the browser showing the UI change, with the URL visible

![ui-change](/week-05-devops-lifecycle/screenshots/live-change.png)

---

# Task 9 — Retro Notes (Scrum Pillar + Value)

## Goal

Add a retro comment covering what went well, what to improve, one Scrum pillar observed (Transparency, Inspection, or Adaptation), and one Scrum value (Openness, Focus, Commitment, Courage, or Respect).

### Evidence

#### Screenshot 13 — Jira retro comment visible

![srint-retro](/week-05-devops-lifecycle/screenshots/retro.png)

---

# Task 10 — LinkedIn Post (Mandatory)

## Goal

Publish a LinkedIn post about what you delivered, including your live URL, three to five lines on what you did and learned, and one screenshot (Burndown Chart, Sprint board, or the live UI change).

## Evidence

#### LinkedIn Post URL

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-share-7491701240960069632-3q2z/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

#### Screenshot 14 — Published LinkedIn post

![post-linked](/week-05-devops-lifecycle/screenshots/post-linkedin.png)

---

# Submission Instructions

- Add all 14 required screenshots
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [ ] Task 1: Team Mode or Solo Mode selected and all four roles documented (Screenshot 1 & Notes)
- [ ] Task 2: Team-managed Scrum project created with the required name (Screenshot 2)
- [ ] Task 3: UI improvement Epic created (Screenshot 3)
- [ ] Task 4: 6–8 Stories added under the Epic and ranked by value (Screenshots 4 & 5)
- [ ] Task 5: Story Points set (1, 2, or 3) with reasoning recorded (Screenshot 6 & Notes)
- [ ] Task 6: Sprint 1 created with Sprint Goal, 3–4 Stories, and Sub-tasks (Screenshots 7 & 8)
- [ ] Task 7: Burndown Chart opened (Screenshot 9)
- [ ] Task 8: One UI-only increment implemented, committed, deployed, and verified (Screenshots 10–12)
- [ ] Task 9: Retro comment with one Scrum pillar and one Scrum value (Screenshot 13)
- [ ] Task 10: Mandatory LinkedIn post published with the live URL, backlog refinement, Sprint planning, one shipped increment, proof, and Screenshot 14
- [ ] Full Name visible in required screenshots
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

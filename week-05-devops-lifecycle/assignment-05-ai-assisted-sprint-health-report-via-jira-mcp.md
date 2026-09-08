# Assignment 5 — AI-Assisted Sprint Health Report via Jira MCP

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will connect Claude Code to your Jira board through an MCP server, the same way you connected it to GitHub in Week 2, and build a read-only `/sprint-health` skill. The skill reads your current sprint through Jira's API and reports sprint velocity, stories at risk of missing the sprint, and items missing an estimate — but it must never create, edit, comment on, or transition a single ticket itself. You will prove that boundary holds by making a real change on the board yourself and confirming the skill only ever reports, never acts.

---

# Task 1 — Create a Jira API Token

## Goal

Generate an API token from your Atlassian account that the MCP server will use to authenticate with your Jira site. Do not screenshot the token value itself.

### Evidence

#### Screenshot 1 — Jira API token creation confirmation page showing the token name, with the token value not visible

![token-creation](/week-05-devops-lifecycle/screenshots/ass-5-SS-1.png)

### Notes You Must Write (Very Important):

Why does the MCP server need your site URL and account email in addition to the token?

The MCP server needs both URL and account email because the token alone often isn't enough to establish the connection reliably.
Site URL tells the MCP server which instance/tenant to connect to. For example, a company may have separate production, staging, or self-hosted sites, and the same token format could be valid across them, while the account email identifies which user/account the token belongs to. It is commonly used for authentication flows, API requests, auditing, or selecting the correct account/tenant.
Token is just the credential that proves the server is authorized to act as that account.

---

# Task 2 — Create .mcp.json at the Project Root

## Goal

Create or update `.mcp.json` at your project root with a Jira MCP server block, following the same shape as the GitHub MCP server you configured in Week 2.

### Evidence

#### Screenshot 2 — `.mcp.json` open in VS Code showing the Jira server configuration

![mcp-json](/week-05-devops-lifecycle/screenshots/ass-5-SS-2.png)

### Notes You Must Write (Very Important):

Compare this jira block to the github block from Week 2 Assignment 5. The GitHub server ran via npx (a Node.js package); this one runs via uvx (a Python package) — what stays exactly the same shape despite that difference, and why doesn't Claude Code care which language a given MCP server is written in?

They both have the same overall configuration shape despite the differences outlined. The most important structure remain the same like MCP server name, command, arguments, environment variables / credentials. In other words, Claude Code doesn't fundamentally care whether the configuration launches the server with npx or uvx the command and arguments tell Claude Code how to start the process, while the environment variables provide whatever configuration or credentials that particular server needs.

Why doesn't Claude Code care about the language?
Because MCP defines the communication interface, not the implementation language. Once the server starts, Claude Code communicates with it through the MCP protocol. Claude Code sees an MCP server exposing tools/resources/prompts; it doesn't need to know whether the code behind those tools is Python or JavaScript.



---

# Task 3 — Add Your Credentials to settings.local.json

## Goal

Add your Jira site URL, account email, and API token to `.claude/settings.local.json`, and confirm that file is listed in `.gitignore` so it is never committed.

### Evidence

#### Screenshot 3 — `settings.local.json` open in VS Code showing the `env` section, with the actual token value blurred or covered

![env-section](/week-05-devops-lifecycle/screenshots/ass-5-SS-3.png)

### Notes You Must Write (Very Important):

Why must JIRA_API_TOKEN live in settings.local.json and never in .mcp.json?

Because JIRA_API_TOKEN is a secret credential, while .mcp.json is intended to describe the MCP server configuration. Putting the token in .mcp.json creates a risk, the principle is separation of configuration from secrets.

---

# Task 4 — Verify the Connection with /mcp

## Goal

Restart Claude Code and confirm the Jira MCP server shows as connected.

### Evidence

#### Screenshot 4 — `/mcp` output showing `jira: connected`

![jira-mcp-connected](/week-05-devops-lifecycle/screenshots/ass-5-SS-4.png)

---

# Task 5 — Run a Live Query to Prove Real Board Data

## Goal

Ask Claude to list the issues in your current active sprint through the Jira MCP connection, and confirm the result matches what you see on your live board in the browser.

### Evidence

#### Screenshot 5 — Claude's response showing the live sprint issue list retrieved via Jira MCP

![active-sprints](/week-05-devops-lifecycle/screenshots/ass-5-SS-5.png)

### Notes You Must Write (Very Important):

How did you confirm this was real board data and not something Claude guessed?

I confirmed by looking at the results side by side with the Jira Board data on my browser

---

# Task 6 — Build the /sprint-health Skill

## Goal

Create a `/sprint-health` skill restricted to read-only Jira tools plus `Read`, with no issue-mutating tools and no `Write`. Run it and confirm it produces a report covering sprint velocity, at-risk stories, and items missing an estimate.

### Evidence

#### Screenshot 6 — `SKILL.md` frontmatter showing `allowed-tools` limited to read-only Jira tools plus `Read`, with `disable-model-invocation: true`

![allowed-tools](/week-05-devops-lifecycle/screenshots/ass-5-SS-6.png)

#### Screenshot 7 — `/sprint-health` output showing the full triage report against your real sprint

![triage](/week-05-devops-lifecycle/screenshots/ass-5-SS-7.png)

### Notes You Must Write (Very Important):

1. Which Jira MCP tools does this skill's allowed-tools list include, and which mutating tools (create issue, update issue, transition issue, add comment) does it deliberately exclude?

## Allowed Jira MCP tools
The skill permits exactly these Jira tools:
 - mcp__jira__jira_search
 - mcp__jira__jira_get_issue
 - mcp__jira__jira_get_sprint
 - mcp__jira__jira_get_board
   Plus the filesystem/read capability : Read

## Deliberately excluded mutation tools
There are no write/mutation tools in allowed-tools. In particular, it excludes tools for:
 - Create issue
 - Update/edit issue
 - Transition issue
 - Add comment
 So this is a strictly read-only sprint-health skill. It can inspect the board, sprint, and issues and produce calculations/reporting, but it cannot modify Jira.

2. Why does a Scrum Master need this restriction more than almost any other role in this course?

A Scrum Master needs this restriction because their role is primarily to facilitate, surface impediments, and improve the team’s process and not to make changes on the team’s behalf.

---

# Task 7 — Prove the Skill Never Mutates the Board

## Goal

Manually update one ticket on your board in the browser (for example, move a story to "Done" or add a missing estimate), then run `/sprint-health` again and confirm the new report reflects your change — proving the skill only ever reads live state and never wrote to the board itself.

### Evidence

#### Screenshot 8 — Second `/sprint-health` run showing the report now reflects your manual board change

![manual-change](/week-05-devops-lifecycle/screenshots/ass-5-SS-8.png)

### Notes You Must Write (Very Important):

Map this assignment to Gather → Analyze → Human Act → Verify from Week 3 Assignment 6. Which step did you perform manually in the browser, and why must that step stay human?

1. Gather: The Jira MCP read tools gather the current active sprint, its issues, statuses, assignees, story points, and update 
   timestamps.

2. Analyze: The sprint-health skill analyzes that data, calculating velocity, identifying at risk stories, and finding missing 
   estimates or acceptance criteria.

3. Human Act: I made alterations manually in the Jira browser just to be sure Claude is not guessing or just making up 
   suggestions and spinning figures from abstract places.

4. Verify: I cross checked the live Jira board/browser to confirm that the intended state or change actually occurred when I ran 
   the /sprint-health a second time.

## Why must Human Act stay human?
Because there is an intentional establishment of a human in the loop boundary. The AI can identify a problem, but it shouldn't decide what the team should do about it.

---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 8 required screenshots
- All the required notes

---

# Completion Checklist

- [ ] Task 1: Jira API token created, value never screenshotted (Screenshot 1)
- [ ] Task 2: `.mcp.json` has the Jira server block (Screenshot 2)
- [ ] Task 3: Credentials stored in `settings.local.json`, token blurred, file gitignored (Screenshot 3)
- [ ] Task 4: `/mcp` shows the Jira server connected (Screenshot 4)
- [ ] Task 5: Live query returned real sprint data, verified against the browser (Screenshot 5)
- [ ] Task 6: `/sprint-health` skill created with correct read-only `allowed-tools`, and produced a full report (Screenshots 6–7)
- [ ] Task 7: A manual board change was reflected in a second `/sprint-health` run (Screenshot 8)
- [ ] Skill never created, edited, transitioned, or commented on any issue
- [ ] Reflection answered (Notes)
- [ ] No API token value exposed

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

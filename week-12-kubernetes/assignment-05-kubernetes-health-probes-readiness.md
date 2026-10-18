# Assignment 5 — Kubernetes Health Probes (Readiness)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will configure and test a Kubernetes readiness probe. You will create a baseline NGINX Deployment, add an HTTP readiness probe, intentionally break it, observe a stalled rollout, and restore the working configuration.

You will also demonstrate how readiness probes protect rolling updates.

---

# Task 0 — Prepare the Lab Environment

## Goal

Confirm that you are connected to your learning cluster and remove the previous assignment’s HPA and NGINX Deployment before starting this lab.

No screenshot or written notes are required for this pre-check.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the readiness-probe lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/health-probes-readiness`

![ss1](/week-12-kubernetes/screenshots/Ass5-ss1.png)

---

### Notes

**1. What is the purpose of a readiness probe?**

A readiness probe tells Kubernetes whether a container is currently ready to serve requests. If the check fails, Kubernetes marks the Pod as not ready.

**2. Why is a Pod being Running not always enough to confirm it can serve traffic?**

`Running` means the Pod's containers have started and are running, but the application may still be initializing, loading configuration, or unable to respond successfully. Readiness checks test the application's ability to serve requests rather than just whether the container is running.

---

# Task 2 — Create a Baseline Deployment Without Probes

## Goal

Create a baseline NGINX Deployment with two replicas and no readiness probe.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy-baseline.yaml` manifest

![ss2](/week-12-kubernetes/screenshots/Ass5-ss2.png)

---

#### Screenshot 3 — Output showing a successful rollout and two running NGINX Pods

![ss3](/week-12-kubernetes/screenshots/Ass5-ss3.png)

---

#### Screenshot 4 — Relevant output from `kubectl describe deployment nginx-deployment`

![ss4](/week-12-kubernetes/screenshots/Ass5-ss4.png)

---

### Notes

**1. How many replicas does this Deployment maintain?**

Two replicas, as requested by `spec.replicas: 2`.

**2. What does `maxUnavailable: 0` mean during a rolling update?**

It tells the Deployment controller not to reduce the number of available replicas below the desired count because of the rolling update. Kubernetes can create up to one extra Pod (`maxSurge: 1`) while replacing old Pods. If replacement Pods never become ready, the rollout can stall.

**3. Is a readiness probe configured in this baseline Deployment?**

No. The baseline has no readiness probe configured explicitly. Kubernetes still reports Pod readiness conditions, but it has no custom HTTP readiness check for this container yet.

---

# Task 3 — Add a Readiness Probe

## Goal

Add an HTTP readiness probe so Kubernetes checks whether each NGINX container is ready to accept requests.

### Evidence

#### Screenshot 5 — Completed `01-nginx-deploy-readiness.yaml` manifest showing the readiness probe

![ss5](/week-12-kubernetes/screenshots/Ass5-ss5.png)

---

#### Screenshot 6 — Output of the successful rollout and ready Pods

![ss6](/week-12-kubernetes/screenshots/Ass5-ss6.png)

---

#### Screenshot 7 — Pod description showing readiness conditions and readiness probe details

![ss7](/week-12-kubernetes/screenshots/Ass5-ss7.png)
![ss7](/week-12-kubernetes/screenshots/Ass5-ss7a.png)

---

### Notes

**1. What path and port does the readiness probe check?**

It checks HTTP path `/` on port `80` inside the NGINX container.

**2. What does `initialDelaySeconds: 2` do?**

It delays the first readiness check for two seconds after the container starts.

**3. What does `periodSeconds: 5` do?**

It sets the interval between readiness checks to approximately five seconds.

**4. What must happen before Kubernetes considers this Pod ready?**

The readiness check must succeed. In this configuration, the NGINX HTTP endpoint must return a successful HTTP status code for the probe.

---

# Task 4 — Break and Restore Readiness

## Goal

Intentionally fail the readiness probe, observe the NotReady behavior, and then restore the working probe configuration.

### Evidence

#### Screenshot 8 — `02-nginx-readiness-broken.yaml` showing `/does-not-exist`

![ss8](/week-12-kubernetes/screenshots/Ass5-ss8.png)

---

#### Screenshot 9 — Output showing the rollout timeout or incomplete rollout

![ss9](/week-12-kubernetes/screenshots/Ass5-ss9.png)

---

#### Screenshot 10 — Pod details showing `Ready: False` or readiness-probe failure events

![ss10](/week-12-kubernetes/screenshots/Ass5-ss10.png)

---

#### Screenshot 11 — Output showing successful rollout and ready Pods after the fix

![ss11](/week-12-kubernetes/screenshots/Ass5-ss11.png)

---

### Notes

**1. Why did the readiness probe fail?**

The probe requested `/does-not-exist`, which normally returns HTTP 404 from NGINX. A non-successful response causes the readiness check to fail.

**2. What happened to the Pod readiness status?**

The new Pod remained `NotReady` (`READY` typically shows `0/1`) even though its container could still be running.

**3. Why did the rollout fail to complete?**

The new Pods never passed the readiness check, so Kubernetes could not count them as available replacements.

**4. How did you restore the Deployment successfully?**

I reapplied the working manifest with the readiness path restored to `/`, then waited for the readiness checks to succeed and the rollout to complete.

---

# Task 5 — See How Readiness Protects Rolling Updates

## Goal

Observe how readiness prevents a bad new Pod from replacing healthy Pods during a rolling update.

### Evidence

#### Screenshot 12 — Successful update command and rollout status

![ss12](/week-12-kubernetes/screenshots/Ass5-ss12.png)

---

#### Screenshot 13 — ReplicaSets and Pods after the successful rolling update

![ss13](/week-12-kubernetes/screenshots/Ass5-ss13.png)

---

#### Screenshot 14 — Completed `04-readiness-broken-patch.yaml`

![ss14](/week-12-kubernetes/screenshots/Ass5-ss14.png)

---

#### Screenshot 15 — Output showing the expected stalled rollout or timeout

![ss15](/week-12-kubernetes/screenshots/Ass5-ss15.png)

---

#### Screenshot 16 — Deployment or Pod output showing the effect of the broken readiness probe

![ss16](/week-12-kubernetes/screenshots/Ass5-ss16.png)

---

#### Screenshot 17 — Successful rollout status after restoring the fixed configuration

![ss17](/week-12-kubernetes/screenshots/Ass5-ss17.png)

---

### Notes

**1. What happened during the successful rolling update?**

Kubernetes created a new ReplicaSet, started Pods using the new image, waited for them to pass readiness checks, and progressively removed the old Pods.

**2. Why did Kubernetes create a new ReplicaSet?**

The container image changed, which changed the Deployment's Pod template. Deployments use ReplicaSets to manage the old and new versions of their Pods during updates.

**3. Why were the new Pods unable to replace the existing healthy Pods after readiness was broken?**

The new Pods failed their readiness probes, so Kubernetes did not count them as available. The rollout could not progress normally to completion.

**4. How does `maxUnavailable: 0` protect availability during this rollout?**

It prevents the Deployment's rolling update strategy from intentionally allowing fewer than the desired number of available replicas during the update. With `maxSurge: 1`, Kubernetes can create one extra Pod while waiting for a replacement to become ready.

---

# Task 6 — Share Your Readiness-Probe Learning on LinkedIn

## Goal

Share what you learned about Kubernetes readiness probes and how they protect rolling updates.

### Evidence

#### Screenshot 18 — Published LinkedIn post

![ss18](/week-12-kubernetes/screenshots/Ass5-ss18.png)

#### Linkedin post link

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7517580394922311683-5h2A/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Add all required screenshots numbered 1–18.
- Ensure your full name is visible in required screenshots.
- Use clear, readable screenshots showing the relevant manifest or output.
- Include the completed baseline and readiness-probe manifests in your repository.
- Answer all Notes questions for Tasks 1–5 in your own words.
- Include evidence of the intentional readiness failure and successful recovery.
- Do not expose tokens, passwords, kubeconfig files, account IDs, or other sensitive information.

---

# Completion Checklist

- [ ] Learning cluster confirmed and previous assignment resources removed where applicable
- [ ] Readiness-probe lab directory created (Screenshot 1)
- [ ] Baseline Deployment created successfully (Screenshot 2)
- [ ] Two baseline Pods running and successful rollout verified (Screenshot 3)
- [ ] Baseline Deployment details reviewed (Screenshot 4)
- [ ] Readiness probe added successfully (Screenshot 5)
- [ ] Successful readiness rollout verified (Screenshot 6)
- [ ] Pod readiness conditions and probe details inspected (Screenshot 7)
- [ ] Broken readiness configuration created (Screenshot 8)
- [ ] Stalled rollout or timeout observed (Screenshot 9)
- [ ] NotReady status or readiness-probe failure events captured (Screenshot 10)
- [ ] Working readiness configuration restored (Screenshot 11)
- [ ] Successful image update completed (Screenshot 12)
- [ ] ReplicaSets and Pods inspected after the update (Screenshot 13)
- [ ] Broken-readiness patch created (Screenshot 14)
- [ ] Stalled rollout observed after the patch (Screenshot 15)
- [ ] Effect of broken readiness captured (Screenshot 16)
- [ ] Final recovery completed (Screenshot 17)
- [ ] LinkedIn post published (Screenshot 18)
- [ ] Notes for Tasks 1–5 completed
- [ ] Required manifests included
- [ ] All screenshots are clear and readable
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

*This submission is part of DevOps Micro Internship (DMI) — Agentic AI Track.*

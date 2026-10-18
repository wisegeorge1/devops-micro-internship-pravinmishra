# Assignment 6 — Kubernetes Health Probes (Liveness)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will configure and test a Kubernetes liveness probe. You will create a baseline NGINX Deployment, add an HTTP liveness probe, intentionally make it fail, observe container restarts, and restore the working configuration.

---

# Task 0 — Prepare the Lab Environment

## Goal

Confirm that you are connected to your learning cluster and remove the previous HPA and NGINX Deployment before starting this lab.

No screenshot or written notes are required for this pre-check.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the liveness-probe lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/health-probes-liveness`

![ss1](/week-12-kubernetes/screenshots/Ass6-ss1.png)

---

### Notes

**1. What problem does a liveness probe solve?**

A liveness probe helps Kubernetes detect when a container is persistently unhealthy, even though its process may still be running. After the configured number of consecutive failures, Kubernetes restarts the container.

**2. What is the key difference between a readiness probe and a liveness probe?**

A readiness probe determines whether a Pod should receive traffic. A liveness probe determines whether a container should be restarted. A failed readiness probe ordinarily marks a Pod unready without restarting it; a failed liveness probe triggers a container restart after the failure threshold is reached.

---

# Task 2 — Create a Baseline Deployment Without Probes

## Goal

Create a baseline NGINX Deployment with two replicas and no health probes.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy-baseline.yaml` manifest

![ss2](/week-12-kubernetes/screenshots/Ass6-ss2.png)

---

#### Screenshot 3 — Output showing a successful rollout and two running NGINX Pods

![ss3](/week-12-kubernetes/screenshots/Ass6-ss3.png)

---

#### Screenshot 4 — Relevant output from `kubectl describe deployment nginx-deployment`

![ss4](/week-12-kubernetes/screenshots/Ass6-ss4.png)

---

### Notes

**1. How many replicas does this Deployment maintain?**

Two replicas.

**2. Are any health probes configured in the baseline Deployment?**

No. The baseline manifest contains neither a readiness probe nor a liveness probe.

**3. Why is a baseline useful before adding a liveness probe?**

It gives you a known starting point. You can compare the Deployment before and after adding a probe and observe how Kubernetes behaves when the probe fails.

---

# Task 3 — Add a Liveness Probe

## Goal

Add an HTTP liveness probe so Kubernetes can periodically check whether the NGINX container is still responsive.

### Evidence

#### Screenshot 5 — Completed `01-nginx-deploy-liveness.yaml` manifest showing the liveness probe

![ss5](/week-12-kubernetes/screenshots/Ass6-ss5.png)

---

#### Screenshot 6 — Output showing successful rollout and running Pods

![ss6](/week-12-kubernetes/screenshots/Ass6-ss6.png)

---

#### Screenshot 7 — Pod description showing liveness-probe details

![ss7](/week-12-kubernetes/screenshots/Ass6-ss7.png)

---

### Notes

**1. What path and port does the liveness probe check?**

It checks the HTTP path `/` on port `80`.

**2. What does `initialDelaySeconds: 10` do?**

It delays the first liveness check until 10 seconds after the container starts, giving the application time to initialize.

**3. What does `failureThreshold: 3` mean?**

Three consecutive failed liveness checks cause Kubernetes to restart the container. The exact elapsed time depends on probe scheduling and response timing.

**4. Does a successful liveness probe control whether a Pod receives traffic? Explain briefly.**

No. Liveness controls whether Kubernetes restarts the container. Readiness determines whether the Pod is ready to receive traffic.

---

# Task 4 — Trigger and Observe a Liveness Restart

## Goal

Intentionally make the liveness probe fail and observe Kubernetes restart the unhealthy container.

### Evidence

#### Screenshot 8 — `02-nginx-liveness-broken.yaml` showing `/does-not-exist`

![ss8](/week-12-kubernetes/screenshots/Ass6-ss8.png)

---

#### Screenshot 9 — Pod output showing an increased RESTARTS count

![ss9](/week-12-kubernetes/screenshots/Ass6-ss9.png)

---

#### Screenshot 10 — Pod description showing liveness-probe failure events or restart details

![ss10](/week-12-kubernetes/screenshots/Ass6-ss10.png)

---

#### Screenshot 11 — Output showing stable running Pods after applying the fixed configuration

![ss11](/week-12-kubernetes/screenshots/Ass6-ss11.png)

---

### Notes

**1. Why did the liveness probe fail?**

The probe requested `/does-not-exist`, which typically returned HTTP 404. Kubernetes treated that response as a failed liveness check.

**2. What happened after Kubernetes detected repeated liveness-probe failures?**

After three consecutive failures, kubelet restarted the affected container. The Pod's restart count increased, and Pod events recorded the failures and restart activity.

**3. What does the RESTARTS column prove?**

An increased count shows that the container has restarted within that Pod. Combined with the Pod's events, it helps confirm that Kubernetes responded to the failed liveness checks.

**4. How did you restore the Deployment to a stable state?**

I applied the fixed manifest, `03-nginx-liveness-fixed.yaml`, which restored the probe path to `/`. I then waited for the Deployment to settle and confirmed that two NGINX Pods were running with no new restarts during the observation period.

---

# Task 5 — Optional: Observe a Restart Loop

## Goal

Observe why overly aggressive or incorrectly configured liveness probes can create restart loops.

Complete this section only if you attempt Task 5. Otherwise, mark it as “Not attempted.”

**Task status:** Completed 

### Evidence

#### Optional Screenshot — Pod output showing the RESTARTS count increasing during the restart-loop observation

![ss12](/week-12-kubernetes/screenshots/Ass6-ss-optional.png)

No specific restart count or CrashLoopBackOff status is required.

---

### Notes — Answer Only If Attempted

**1. What is a restart loop?**

A restart loop occurs when a container repeatedly starts, fails a health check or another startup condition, and is restarted. In a liveness-triggered loop, the container repeatedly fails its configured liveness check and gets restarted.

**2. Why can an aggressive liveness probe be harmful?**

If a probe has insufficient startup allowance, an overly short timeout, or an excessively low failure threshold, it can restart a container that is merely starting slowly or experiencing temporary load. Repeated restarts can prevent the application from recovering.

**3. Why should liveness checks be lightweight and carefully tuned?**

They should detect genuine application failures without adding significant load or confusing temporary dependency issues with an application deadlock. Appropriate delays, timeouts, and thresholds reduce unnecessary restarts.

---

# Task 6 — Share Your Liveness-Probe Learning on LinkedIn

## Goal

Share what you learned about Kubernetes liveness probes, container restarts, and the difference between readiness and liveness.

### Evidence

#### Screenshot 12 — Published LinkedIn post

![ss12](/week-12-kubernetes/screenshots/Ass6-ss12.png)

#### Linkedin post URL

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7517606924356382720-HDAL/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Add all required screenshots numbered 1–12.
- Include the optional Task 5 screenshot only if you attempt that task.
- Ensure your full name is visible in required screenshots.
- Use clear, readable screenshots showing the relevant manifest or output.
- Include the completed baseline and liveness-probe manifests in your repository.
- Answer all Notes questions for Tasks 1–4 in your own words.
- If you attempt Task 5, complete its Notes and restore the working configuration afterward.
- Do not expose tokens, passwords, kubeconfig files, account IDs, or other sensitive information.

---

# Completion Checklist

- [ ] Learning cluster confirmed and previous assignment resources removed where applicable
- [ ] Liveness-probe lab directory created (Screenshot 1)
- [ ] Baseline Deployment manifest completed (Screenshot 2)
- [ ] Successful rollout and two baseline Pods verified (Screenshot 3)
- [ ] Baseline Deployment details reviewed (Screenshot 4)
- [ ] Liveness probe added successfully (Screenshot 5)
- [ ] Successful liveness-probe rollout verified (Screenshot 6)
- [ ] Liveness-probe details inspected (Screenshot 7)
- [ ] Broken liveness configuration created (Screenshot 8)
- [ ] Increased container restart count observed (Screenshot 9)
- [ ] Liveness-probe failure events or restart details captured (Screenshot 10)
- [ ] Working liveness configuration restored and stable Pods verified (Screenshot 11)
- [ ] Optional Task 5 evidence and Notes completed, if attempted
- [ ] Working configuration restored after Task 5, if attempted
- [ ] LinkedIn post published (Screenshot 12)
- [ ] Notes for Tasks 1–4 completed
- [ ] Required manifests included
- [ ] All required screenshots are clear and readable
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

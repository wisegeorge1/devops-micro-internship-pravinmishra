# Assignment 4 — Auto-Scaling & Auto-Healing: Let Kubernetes React for You

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Create Deployments, test Pod auto-healing, configure CPU requests and limits, verify Metrics Server, and create a Horizontal Pod Autoscaler.

Optionally generate CPU load to observe how the HPA responds.

---

# Task 0 — Check the Existing Cluster Resources

## Goal

Confirm that you are connected to your learning cluster and inspect existing Deployments and HPAs.

### Evidence

No screenshots required.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the auto-scaling lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/autoscaling`

![ss1](/week-12-kubernetes/screenshots/Ass4-ss1.png)

---

### Notes

**1. What is the difference between auto-healing and auto-scaling?**

Auto-healing restores the desired state when Pods fail or are deleted. Auto-scaling changes the number of desired replicas in response to changing workload demand or another configured scaling metric.

---

**2. Which Kubernetes feature will you use for CPU-based auto-scaling?**

The Horizontal Pod Autoscaler (HPA), which adjusts a workload's desired replica count based on observed metrics such as CPU utilization.

---

# Task 2 — Test Auto-Healing with a Deployment

## Goal

Create a Deployment with two replicas, delete one Pod, and observe Kubernetes create a replacement Pod.

### Evidence

#### Screenshot 2 — Completed `autohealing-deployment.yaml` manifest

![ss2](/week-12-kubernetes/screenshots/Ass4-ss2.png)

---

#### Screenshot 3 — Output of `kubectl get pods` showing two running Pods before deletion

![ss3](/week-12-kubernetes/screenshots/Ass4-ss3.png)

---

#### Screenshot 4 — Output of the `kubectl delete pod` command

![ss4](/week-12-kubernetes/screenshots/Ass4-ss4.png)

---

#### Screenshot 5 — Output of `kubectl get pods` showing the replacement Pod and two running Pods

![ss5](/week-12-kubernetes/screenshots/Ass4-ss5.png)

---

### Notes

**1. What happened after you deleted one Pod?**

Kubernetes detected that the actual number of Pods was below the desired count and created a replacement Pod.

---

**2. What Kubernetes resource maintains the desired replica count for this Deployment?**

The ReplicaSet maintains the Pod replica count. The Deployment manages the ReplicaSet and its rollout lifecycle.

---

**3. What proves that auto-healing worked?**

The deleted Pod disappeared, a new Pod name appeared, and the Deployment returned to two ready, running Pods.

---

# Task 3 — Create a Deployment for HPA

## Goal

Create a Deployment with CPU resource requests and limits so that HPA can calculate CPU utilization.

### Evidence

#### Screenshot 6 — Completed `hpa-deployment.yaml` manifest showing CPU requests and limits

![ss6](/week-12-kubernetes/screenshots/Ass4-ss6.png)

---

#### Screenshot 7 — Output showing `nginx-deployment` and its running Pods

![ss7](/week-12-kubernetes/screenshots/Ass4-ss7.png)

---

### Notes

**1. What does `cpu: "100m"` mean?**

In Kubernetes, 100m means 100 millicores, equivalent to 0.1 of one CPU core. It represents one-tenth of a CPU core's processing capacity. For example, cpu: "500m" represents half a CPU core.

---

**2. What is the difference between a CPU request and a CPU limit?**

CPU request: The amount of CPU Kubernetes uses when scheduling a container onto a node. It also serves as the baseline for CPU utilization calculations used by the Horizontal Pod Autoscaler (HPA).

CPU limit: The maximum CPU processing time a container can use. If a container attempts to exceed its CPU limit, it may be throttled.

---

**3. Why does CPU-based HPA require CPU requests?**

The Horizontal Pod Autoscaler calculates CPU utilization as a percentage of the CPU requested by containers. For example, if a container requests 200m CPU and uses 100m, its CPU utilization is 50% of its request.

If the CPU request is not defined, Kubernetes cannot calculate CPU utilization as a percentage of that request, so CPU utilization based HPA cannot make the required scaling decisions for that container.

---

# Task 4 — Enable and Verify Metrics Server

## Goal

Ensure the cluster can collect resource metrics for the HPA.

### Evidence

#### Screenshot 8 — Output showing Metrics Server running, or `!` displaying Pod metrics

![ss8](/week-12-kubernetes/screenshots/Ass4-ss8.png)

---

### Notes

**1. Why does HPA need Metrics Server?**

HPA needs current resource usage metrics to compare observed CPU utilization with its configured target.

---

**2. What issue can occur if Metrics Server is not working?**

The HPA may display `<unknown>` for its CPU target and cannot make normal CPU based scaling decisions.

---

**3. What does `kubectl top pods` help you check?**

It displays recent CPU and memory usage for Pods, helping you verify that metrics collection is working.

---

# Task 5 — Create a Horizontal Pod Autoscaler

## Goal

Create an HPA that keeps at least two Pods running and can scale up to five Pods when average CPU utilization exceeds 50%.

### Evidence

#### Screenshot 9 — The imperative command output OR completed `hpa-nginx.yaml` manifest

![ss9](/week-12-kubernetes/screenshots/Ass4-ss9.png)

---

#### Screenshot 10 — Output of `kubectl get hpa` and the relevant `kubectl describe hpa` command

![ss10](/week-12-kubernetes/screenshots/Ass4-ss10.png)

---

### Notes

**1. What does `minReplicas: 2` mean?**

The HPA should not scale the Deployment below two replicas.The HPA should not scale the Deployment below two replicas.

---

**2. What does `maxReplicas: 5` mean?**

The HPA should not scale the Deployment above five replicas.

---

**3. What does `averageUtilization: 50` mean?**

It sets the target average CPU utilization to 50% of the CPU requests for the relevant containers.

---

**4. Why should only one HPA manage a Deployment at a time?**

Multiple HPAs targeting the same Deployment can issue competing scaling recommendations and cause confusing or unstable replica counts. Keep one HPA responsible for this workload.

---

# Task 6 — Optional: Generate CPU Load and Observe Scaling

## Goal

Generate CPU load in one NGINX Pod and observe how HPA responds.

### Evidence

If you skip this task, write “Not completed — optional” and leave the remaining Task 6 placeholders blank.

Task status: Add your status here.

#### Screenshot 11 — Terminal showing the CPU-load command running inside the selected Pod

![ss11](/week-12-kubernetes/screenshots/Ass4-ss11.png)

---

#### Screenshot 12 — Output of `kubectl get hpa` and `kubectl get pods` while HPA evaluates or changes the replica count

![ss12](/week-12-kubernetes/screenshots/Ass4-ss12.png)

---

### Notes

Complete these answers only if you perform the optional test.

**1. Did the HPA change the number of Pods? Explain what you observed.**

The Deployment scaled from two to four replicas, Four was the highest replica count I observed and the CPU target shown by `kubectl get hpa -w` was 50%/50%. the scaling was observed during the test.

---

**2. If scaling did not happen, what are two possible reasons?**

* CPU utilization did not exceed the configured target for long enough, or the load was insufficient relative to the target.

* Metrics Server or HPA metrics were unavailable or delayed. Another possibility is that a CPU limit restricted the generated load.

---

**3. Why is automatic scale-down useful after traffic decreases?**

It reduces unnecessary resource consumption when demand falls, helping avoid paying for or reserving more compute capacity than the application needs.

---

# LinkedIn Requirement

### Evidence

#### Screenshot 13 — Published LinkedIn post showing your name, the required explanation, and the attached Kubernetes screenshot

![ss13](/week-12-kubernetes/screenshots/Ass4-ss13.png)

#### Linkedin Post Link

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7517515302822105088-KnhS/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Include required Screenshots 1–10 and Screenshot 13.
- Include Screenshots 11–12 only if you complete Task 6.
- Full Name must be visible in required screenshots.
- Ensure screenshots are clear and readable.
- Include the completed `autohealing-deployment.yaml` and `hpa-deployment.yaml` files.
- Include `hpa-nginx.yaml` if you selected the declarative HPA method.
- Complete the Notes sections for Tasks 1–5 in your own words.
- Complete Task 6 notes only if you perform the optional test.
- Do not expose passwords, tokens, private keys, kubeconfig files, or account IDs.

---

# Completion Checklist

- [ ] Checked the active context and existing cluster resources
- [ ] Created the autoscaling working directory (Screenshot 1)
- [ ] Created `autohealing-deployment.yaml` (Screenshot 2)
- [ ] Confirmed two auto-healing Pods were running (Screenshot 3)
- [ ] Deleted one managed Pod (Screenshot 4)
- [ ] Confirmed that the Pod was automatically replaced (Screenshot 5)
- [ ] Created `hpa-deployment.yaml` with CPU requests and limits (Screenshot 6)
- [ ] Verified `nginx-deployment` and its running Pods (Screenshot 7)
- [ ] Verified Metrics Server and confirmed Pod metrics are available (Screenshot 8)
- [ ] Created one HPA using the selected method (Screenshot 9)
- [ ] Verified minimum replicas of 2, maximum replicas of 5, and a CPU target of 50% (Screenshot 10)
- [ ] Completed Notes for Tasks 1–5
- [ ] Completed Task 6 evidence and notes, or marked it “Not completed — optional”
- [ ] Stopped the CPU-load command and exited the container shell, if Task 6 was completed
- [ ] Published the LinkedIn post with the required explanation and attached screenshot (Screenshot 13)
- [ ] Included the required manifest files
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

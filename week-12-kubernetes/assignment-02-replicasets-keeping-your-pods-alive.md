# Assignment 02 — ReplicaSets: Keeping Your Pods Alive

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will create three NGINX Pods using a ReplicaSet, test auto-healing by deleting one Pod, and scale the ReplicaSet from three to five Pods.

---

# Task 0 — Pre-check: Remove the Pod from Assignment 01

## Goal

Confirm that you are connected to your learning cluster and remove the previous standalone Pod to prevent the ReplicaSet from adopting it.

### Evidence

![ss0](/week-12-kubernetes/screenshots/Ass2-ss0.png)

---

# Task 1 — Set Up Your Working Directory

## Goal

Create and enter a dedicated directory for this ReplicaSet lab.

### Evidence

#### Screenshot 01 — Output of `pwd` showing the working directory ending in `/k8s-labs/replicasets`

![ss1](/week-12-kubernetes/screenshots/Ass2-ss1.png)

---

### Notes

**1. Why is it useful to keep Kubernetes manifests in organized directories?**

Keeping Kubernetes manifests in organized directories is useful because it makes your configuration easier to manage, reuse, troubleshoot, and maintain as your project grows.

A Kubernetes manifest is a YAML file that defines a resource, such as a Pod, Deployment, Service, ConfigMap, or Secret.

---

**2. What file will you create in this directory for this assignment?**

I will create `nginx-replicaset.yaml`, which defines the desired state of the NGINX ReplicaSet.

---

# Task 2 — Create and Apply the NGINX ReplicaSet

## Goal

Create a ReplicaSet that maintains three NGINX Pods.

### Evidence

#### Screenshot 02 — Completed `nginx-replicaset.yaml` manifest showing `replicas: 3`

![ss2](/week-12-kubernetes/screenshots/Ass2-ss2.png)

---

#### Screenshot 03 — Output of `kubectl apply -f nginx-replicaset.yaml`

![ss3](/week-12-kubernetes/screenshots/Ass2-ss3.png)

---

#### Screenshot 04 — Output of `kubectl get pods` showing three NGINX Pods with `1/1` under `READY` and `Running` under `STATUS`

![ss4](/week-12-kubernetes/screenshots/Ass2-ss4.png)

---

### Notes

**1. What does `replicas: 3` mean in this manifest?**

It tells Kubernetes that the desired number of matching Pods for this ReplicaSet is three. The ReplicaSet controller creates or removes Pods as needed to move the current count toward that desired count.

---

**2. Why must `selector.matchLabels` match `template.metadata.labels`?**

The selector determines which Pods the ReplicaSet manages. The Pod template labels identify the Pods it creates. These labels must match so the ReplicaSet can recognize and manage its own Pods correctly. Kubernetes validates this relationship when creating the ReplicaSet.

---

**3. What image and image tag are used for the NGINX container?**

The container uses the official NGINX image with the tag `nginx:1.21.1`, and the container port declared in the manifest is `80`.

---

# Task 3 — Test ReplicaSet Auto-Healing

## Goal

Delete one Pod managed by the ReplicaSet and observe Kubernetes automatically create a replacement.

### Evidence

#### Screenshot 05 — Output of the command deleting one ReplicaSet-managed Pod

![ss5](/week-12-kubernetes/screenshots/Ass2-ss5.png)

---

#### Screenshot 06 — Output of `kubectl get pods` showing the replacement Pod with a different name from the deleted Pod

![ss6](/week-12-kubernetes/screenshots/Ass2-ss6.png)

---

#### Screenshot 07 — Output showing three NGINX Pods with `1/1` under `READY` and `Running` under `STATUS` again

![ss7](/week-12-kubernetes/screenshots/Ass2-ss7.png)

---

### Notes

**1. What happened after you deleted one Pod?**

The selected Pod was terminated and removed. The ReplicaSet detected that only two matching Pods remained and created a new Pod to restore the desired count of three.

---

**2. How does the ReplicaSet know that a replacement Pod is needed?**

The ReplicaSet controller continuously reconciles the desired replica count in `spec.replicas` against the actual number of matching Pods. When the actual count is below the desired count, it creates replacement Pods from the Pod template.

---

**3. What proves that auto-healing worked successfully?**

The deleted Pod's name disappears, a new Pod with a different name appears, and the ReplicaSet returns to three ready Pods with `DESIRED`, `CURRENT`, and `READY` equal to three.

---

# Task 4 — Manually Scale the ReplicaSet

## Goal

Scale the ReplicaSet from three NGINX Pods to five NGINX Pods by changing the YAML manifest.

### Evidence

#### Screenshot 08 — Updated `nginx-replicaset.yaml` showing `replicas: 5`

![ss8](/week-12-kubernetes/screenshots/Ass2-ss8.png)

---

#### Screenshot 09 — Output of `kubectl get pods` showing five NGINX Pods with `1/1` under `READY` and `Running` under `STATUS`

![ss9](/week-12-kubernetes/screenshots/Ass2-ss9.png)

---

### Notes

**1. What change did you make to scale the ReplicaSet?**

I changed `spec.replicas` in `nginx-replicaset.yaml` from `3` to `5` and reapplied the manifest using `kubectl apply -f nginx-replicaset.yaml`.

---

**2. Did you manually create the additional Pods? Explain why or why not.**

No. The ReplicaSet controller automatically created two additional Pods because the desired count increased from three to five.

---

**3. What would happen if you changed the replica count from five back to three?**

After applying the change, Kubernetes would work to reduce the number of matching Pods from five to three. Two excess Pods would be terminated, leaving three replicas as the desired state. Which individual Pods are removed is determined by Kubernetes and should not be assumed in advance.

---

# LinkedIn Requirement

Create a LinkedIn post that includes:

- A short explanation of what a Kubernetes ReplicaSet does.
- What happened when you deleted one NGINX Pod.
- How Kubernetes automatically created a replacement Pod to maintain the desired replica count.
- What you learned by changing the replica count from three to five.
- One screenshot showing either:
  - Three Pods running after the auto-healing test, or
  - Five Pods running after scaling the ReplicaSet.

Do not share sensitive information, cluster credentials, tokens, or kubeconfig details in your post.

### Evidence

#### Screenshot 10 — Published LinkedIn post showing your name, the required explanation, and the attached Pod screenshot

![ss10](/week-12-kubernetes/screenshots/Ass2-ss10.png)

---

### Post Link

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7517384489740726272-v6A7/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Add all required screenshots, numbered 01–10, to this template.
- Full Name must be visible in required screenshots.
- Ensure screenshots are clear and readable.
- Submit the final `nginx-replicaset.yaml` file showing `replicas: 5`. Screenshot 02 provides evidence of the initial manifest with `replicas: 3`.
- Complete the Notes sections in Tasks 1–4 in your own words.
- Include the published LinkedIn post URL.
- Do not expose tokens, passwords, private keys, kubeconfig files, or account IDs.

---

# Completion Checklist

- [ ] Completed Task 0 and confirmed that the previous `nginx-pod` is no longer listed
- [ ] Created and entered the ReplicaSet working directory (Screenshot 01)
- [ ] Created `nginx-replicaset.yaml` with an initial replica count of three (Screenshot 02)
- [ ] Applied the ReplicaSet manifest successfully (Screenshot 03)
- [ ] Confirmed three NGINX Pods are running (Screenshot 04)
- [ ] Deleted one ReplicaSet-managed Pod (Screenshot 05)
- [ ] Observed the automatically created replacement Pod (Screenshot 06)
- [ ] Confirmed three NGINX Pods are running again (Screenshot 07)
- [ ] Changed the replica count from three to five (Screenshot 08)
- [ ] Confirmed five NGINX Pods are running (Screenshot 09)
- [ ] Submitted the final `nginx-replicaset.yaml` file with `replicas: 5`
- [ ] Completed the Notes sections in Tasks 1–4
- [ ] Published the LinkedIn post with the required explanation and Pod screenshot (Screenshot 10)
- [ ] Included the published LinkedIn post URL
- [ ] Included all required screenshots
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

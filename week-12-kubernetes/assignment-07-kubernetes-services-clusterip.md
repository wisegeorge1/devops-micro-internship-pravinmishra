# Assignment 7 — Kubernetes Services (ClusterIP)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will create and test a Kubernetes ClusterIP Service. You will connect it to a healthy NGINX Deployment, access it using DNS and its ClusterIP, break and restore its selector, and observe how readiness affects Service routing.

---

# Task 0 — Prepare the Lab Environment

## Goal

Confirm your learning-cluster context and remove previous lab resources where applicable before starting this assignment.

No screenshot or written notes are required for this pre-check.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the ClusterIP Service lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/services/clusterip`

![ss1](/week-12-kubernetes/screenshots/Ass7-ss1.png)

---

### Notes

**1. Why is it not reliable to communicate with an application using a Pod IP address?**

Pod IP addresses can change when Pods are replaced, recreated, or scaled. Hardcoding a Pod IP creates a dependency on a temporary address and can break communication after a workload changes.

**2. What Kubernetes resource provides a stable internal address for a group of Pods?**

A Kubernetes Service, specifically a ClusterIP Service for internal cluster communication, provides a stable virtual IP and a stable DNS name.

---

# Task 2 — Create a Healthy NGINX Deployment

## Goal

Create an NGINX Deployment with labels, readiness probes, and liveness probes that can act as the backend for a Service.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy.yaml` manifest

![ss2](/week-12-kubernetes/screenshots/Ass7-ss2.png)

---

#### Screenshot 3 — Output showing successful rollout and two ready NGINX Pods

![ss3](/week-12-kubernetes/screenshots/Ass7-ss3.png)

---

### Notes

**1. Which label will the Service use to find these Pods?**

The Service will use `app: nginx`.

**2. Why is readiness important before connecting Pods to a Service?**

Readiness allows Kubernetes to distinguish Pods that are ready to serve requests from Pods that are starting or unhealthy. A failed readiness probe ordinarily excludes a Pod from ready Service backends.

**3. What port does the NGINX container listen on?**

Port `80`, which is configured through `containerPort: 80`.

---

# Task 3 — Create a ClusterIP Service

## Goal

Create a stable internal Service that routes traffic to the NGINX Pods.

### Evidence

#### Screenshot 4 — Completed `01-nginx-svc-clusterip.yaml` manifest

![ss4](/week-12-kubernetes/screenshots/Ass7-ss4.png)

---

#### Screenshot 5 — Output showing the ClusterIP Service, endpoints, or EndpointSlices

![ss5](/week-12-kubernetes/screenshots/Ass7-ss5a.png)
![ss5](/week-12-kubernetes/screenshots/Ass7-ss5b.png)

---

### Notes

**1. What is the purpose of a ClusterIP Service?**

It provides a stable internal IP address and DNS name for communicating with a group of Pods from within the cluster.

**2. What is the difference between `port` and `targetPort`?**

`port` is the port exposed by the Service. `targetPort` is the port on the selected backend Pods where traffic is sent.

**3. Why must the Service selector match the Pod labels?**

The selector is how Kubernetes discovers which Pods belong to the Service. If it matches no Pods, the Service has no corresponding backend endpoints.

**4. What information do EndpointSlices contain?**

They contain backend endpoint information, including Pod IP addresses, ports, and conditions such as whether an endpoint is ready to receive traffic.

---

# Task 4 — Access the Service from Inside the Cluster

## Goal

Create a client Pod and access the NGINX Service using DNS and its ClusterIP.

### Evidence

#### Screenshot 6 — Output showing the `tester` Pod running

![ss6](/week-12-kubernetes/screenshots/Ass7-ss6.png)

---

#### Screenshot 7 — Successful Service request using DNS name and ClusterIP

![ss7](/week-12-kubernetes/screenshots/Ass7-ss7.png)

---

#### Screenshot 8 — Successful DNS lookup for the Service

![ss8](/week-12-kubernetes/screenshots/Ass7-ss8.png)

---

### Notes

**1. Why should an application use `nginx-svc` instead of a Pod IP address?**

The Service name is stable, while individual Pod IPs may change. Using the Service avoids having to update application configuration whenever a Pod is replaced.

**2. What does the DNS name `nginx-svc.default.svc.cluster.local` represent?**

It is the fully qualified DNS name of the Service `nginx-svc` in the `default` namespace, using the `cluster.local` cluster DNS domain.

**3. Why can the client access the Service even if the backend Pod IPs change?**

The Service keeps its stable internal identity while Kubernetes updates the backend endpoints as Pods are created, replaced, or removed.

---

# Task 5 — Break and Restore the Label-Selector Contract

## Goal

Break the Service selector, observe that usable endpoints disappear, and then restore the correct selector.

### Evidence

#### Screenshot 9 — `02-nginx-svc-selector-broken.yaml` showing the incorrect selector

![ss9](/week-12-kubernetes/screenshots/Ass7-ss9.png)

---

#### Screenshot 10 — Empty endpoints or EndpointSlice output after applying the broken selector

![ss10](/week-12-kubernetes/screenshots/Ass7-ss10.png)

---

#### Screenshot 11 — Failed request output from the `tester` Pod

![ss11](/week-12-kubernetes/screenshots/Ass7-ss11.png)

---

#### Screenshot 12 — Restored endpoints and successful Service request

![ss12](/week-12-kubernetes/screenshots/Ass7-ss12a.png)
![ss12](/week-12-kubernetes/screenshots/Ass7-ss12b.png)
![ss12](/week-12-kubernetes/screenshots/Ass7-ss12c.png)

---

### Notes

**1. Why did the Service endpoints become empty?**

The Service selector changed to `app: does-not-match`, which did not match the NGINX Pods' `app: nginx` labels. Kubernetes therefore had no matching Pods to register as backends.

**2. What caused the request from the client Pod to fail?**

The Service had no usable backend endpoints, so traffic could not reach an NGINX Pod through that Service.

**3. How did you restore connectivity to the NGINX Pods?**

I reapplied `01-nginx-svc-clusterip.yaml`, restoring the correct `app: nginx` selector. Kubernetes then rediscovered the matching ready Pods, and the HTTP request succeeded again.

---

# Task 6 — Observe How Readiness Affects Service Routing

## Goal

Observe how a new Pod that fails readiness is excluded from ready Service backends while the existing healthy Pod continues serving traffic.

### Evidence

#### Screenshot 13 — Output showing the Deployment scaled to one ready Pod

![ss13](/week-12-kubernetes/screenshots/Ass7-ss13.png)

---

#### Screenshot 14 — Completed `03-readiness-broken.yaml` patch file

![ss14](/week-12-kubernetes/screenshots/Ass7-ss14.png)

---

#### Screenshot 15 — Output showing the expected incomplete rollout or NotReady Pod

![ss15](/week-12-kubernetes/screenshots/Ass7-ss15.png)

---

#### Screenshot 16 — EndpointSlice output showing the healthy Pod with `ready: true` and the new NotReady Pod with `ready: false`

![ss16](/week-12-kubernetes/screenshots/Ass7-ss16.png)

---

#### Screenshot 17 — Service EndpointSlice output showing ready backends after restoring the Deployment

![ss17](/week-12-kubernetes/screenshots/Ass7-ss17.png)

---

### Notes

**1. Why was the new NotReady Pod excluded from ready Service backends?**

Its readiness probe failed because the configured endpoint returned HTTP 404. Kubernetes therefore marked the Pod unready, preventing it from being selected as a ready backend for normal Service traffic.


**2. What is the relationship between readiness probes and Service routing?**

Readiness probes determine whether Pods are ready to serve traffic. The Service and EndpointSlice mechanisms use this readiness information to direct normal traffic to eligible backends.

**3. Why does this behavior protect users from unhealthy application instances?**

It helps prevent traffic from being routed to instances that are still starting or failing their health checks, while healthy instances can continue serving requests.

---

# Task 7 — Share Your ClusterIP Service Learning on LinkedIn

## Goal

Share what you learned about ClusterIP Services, Kubernetes DNS, selectors, and readiness-aware Service routing.

### Evidence

#### Screenshot 18 — Published LinkedIn post

![ss18](/week-12-kubernetes/screenshots/Ass7-ss18.png)

#### Linkedin post link

<https://www.linkedin.com/posts/wisgeorge1_devops-cloudcomputingnbsp-continuouslearning-ugcPost-7517667563594653697-544W/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Add all required screenshots numbered 1–18.
- Ensure your full name is visible in required screenshots.
- Use clear, readable screenshots showing the relevant manifest or output.
- Include the completed NGINX Deployment and ClusterIP Service manifests in your repository.
- Answer all Notes questions for Tasks 1–6 in your own words.
- Include evidence of the intentional failures and successful recovery.
- Do not expose tokens, passwords, kubeconfig files, account IDs, or other sensitive information.

---

# Completion Checklist

- [ ] Learning-cluster context confirmed and previous lab resources removed where applicable
- [ ] ClusterIP lab directory created (Screenshot 1)
- [ ] Healthy NGINX Deployment manifest completed (Screenshot 2)
- [ ] Successful rollout and two ready NGINX Pods verified (Screenshot 3)
- [ ] ClusterIP Service manifest completed (Screenshot 4)
- [ ] Service and backend endpoints or EndpointSlices verified (Screenshot 5)
- [ ] Client Pod created and running (Screenshot 6)
- [ ] Service accessed using DNS name and ClusterIP (Screenshot 7)
- [ ] Service DNS resolution verified (Screenshot 8)
- [ ] Broken selector manifest created (Screenshot 9)
- [ ] Empty endpoints observed (Screenshot 10)
- [ ] Failed Service request captured (Screenshot 11)
- [ ] Original selector restored and connectivity verified (Screenshot 12)
- [ ] Deployment scaled to one ready Pod (Screenshot 13)
- [ ] Broken readiness patch created (Screenshot 14)
- [ ] Incomplete rollout or NotReady Pod observed (Screenshot 15)
- [ ] Readiness effect on Service backends verified (Screenshot 16)
- [ ] Deployment restored and ready Service backends verified (Screenshot 17)
- [ ] LinkedIn post published (Screenshot 18)
- [ ] Notes for Tasks 1–6 completed
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

# Assignment 8 — Kubernetes Services (NodePort)

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Create a healthy NGINX Deployment, expose it through a NodePort Service, test access using a node IP and NodePort, and observe how the Service behaves when a backend Pod is replaced.

---

# Task 1 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the NodePort Service lab.

### Evidence

#### Screenshot 1 — Terminal showing that you are working inside `~/k8s-labs/services/nodeport`

![ss1](/week-12-kubernetes/screenshots/Ass8-ss1.png)

### Notes

**1. What is the difference between ClusterIP and NodePort?**

A `ClusterIP` Service provides an internal virtual IP and DNS name for communication within the cluster. A `NodePort` Service also has a ClusterIP, but additionally exposes the Service through a port on the cluster nodes.

**2. What does a NodePort Service allow users to do?**

It allows clients to reach a Service using a reachable node IP and its assigned NodePort, for example `http://NODE_IP:NODEPORT`. External connectivity still depends on the cluster's network configuration and firewall rules.

---

# Task 2 — Create a Healthy NGINX Deployment

## Goal

Create a healthy NGINX Deployment that can act as the backend for the NodePort Service.

### Evidence

#### Screenshot 2 — Completed `00-nginx-deploy.yaml` manifest

![ss2](/week-12-kubernetes/screenshots/Ass8-ss2.png)

---

#### Screenshot 3 — Output showing successful rollout and two ready NGINX Pods

![ss3](/week-12-kubernetes/screenshots/Ass8-ss3.png)

### Notes

**1. Which label will the NodePort Service use to find the NGINX Pods?**

`app: nginx`.

**2. Why must the Pods be ready before they can receive Service traffic?**

Readiness indicates that a Pod can serve requests. Pods that fail readiness are normally excluded from ready Service backends.

**3. What port does the NGINX container listen on?**

TCP port `80` in this configuration.

---

# Task 3 — Create the NodePort Service

## Goal

Create a NodePort Service that exposes the NGINX application through a port on every cluster node.

### Evidence

#### Screenshot 4 — Completed `01-nginx-svc-nodeport.yaml` manifest

![ss4](/week-12-kubernetes/screenshots/Ass8-ss4.png)

---

#### Screenshot 5 — Output showing the NodePort Service and its endpoints or EndpointSlices

![ss5](/week-12-kubernetes/screenshots/Ass8-ss5.png)

### Notes

**1. What is the purpose of `type: NodePort`?**

Exposes the Service through a port on each node, subject to the cluster's networking implementation.

**2. What is the difference between `port`, `targetPort`, and `nodePort`?**

  * `port: 80` — the Service's port.

  * `targetPort: 80` — the backend container port receiving traffic.

  * `nodePort` — the node-level port clients use alongside a reachable node IP.

**3. What NodePort was assigned or selected in your environment?**

Assigned NodePort: 30354

**4. Why do Service endpoints need ready Pods?**

Ready endpoints represent backend Pods eligible to receive normal Service traffic.

---

# Task 4 — Find a Node IP and Test the NodePort

## Goal

Find a reachable node IP and access the NodePort Service.

### Evidence

#### Screenshot 6 — Output of `kubectl get nodes -o wide`

![ss6](/week-12-kubernetes/screenshots/Ass8-ss6.png)

---

#### Screenshot 7 — Output showing the `tester` Pod running

![ss7](/week-12-kubernetes/screenshots/Ass8-ss7.png)

---

#### Screenshot 8 — Successful NodePort response from the laptop or the `tester` Pod

If neither route is supported by your environment, include the failed request output and ready endpoint evidence, and explain the limitation in your Notes.

![ss8](/week-12-kubernetes/screenshots/Ass8-ss8.png)

### Notes

**1. Which node IP and NodePort did you test?**

I tested node IP : 172.19.0.2   NordPort : 30354

**2. Was your laptop able to reach the NodePort directly? Explain your result.**

yes, I got a response of `HTTP/1.1 200 OK` and `<!DOCTYPE html>` my port forwarding showed this output 
`Forwarding from 127.0.0.1:8080 -> 80 `
`Forwarding from [::1]:8080 -> 80`
`Handling connection for 8080`
and the `curl -I http://localhost:8080` on a separate terminal gave me a  `HTTP/1.1 200 OK` response while the port forwarding was still on.

**3. Why can external NodePort access behave differently in Minikube, kind, Docker Desktop, and cloud clusters?**

Minikube may require a helper or tunnel; kind and Docker Desktop may use container networking; cloud clusters may have firewall and routing restrictions. The Service's existence does not guarantee end-to-end external connectivity.

---

# Task 5 — Optional: Test the Label-Selector Contract

## Goal

Break the Service selector, observe that usable endpoints disappear, and restore the correct selector.

Complete the Evidence and Notes below only if you attempted this optional task.

### Evidence

#### Screenshot 9 — `02-nginx-svc-selector-broken.yaml` showing the incorrect selector

![ss9](/week-12-kubernetes/screenshots/Ass8-ss9.png)

---

#### Screenshot 10 — Empty endpoints or EndpointSlice output after applying the broken selector

![ss10](/week-12-kubernetes/screenshots/Ass8-ss10.png)

---

#### Screenshot 11 — Restored endpoints or EndpointSlices after applying the original Service manifest

![ss11](/week-12-kubernetes/screenshots/Ass8-ss11.png)

### Notes

**1. Why did the Service endpoints become empty?**

The Service selector no longer matched the backend Pods' `app: nginx` label.

**2. Why is NodePort only useful when matching ready Pods exist?**

 NodePort exposes an entry point to the Service; it does not create an application backend. Without usable endpoints, the request has nowhere to go. 

**3. How did you restore the backend connectivity?**

I Reapplied `01-nginx-svc-nodeport.yaml`, waited for EndpointSlices to recover, and repeated the previously successful test.

---

# Task 6 — Observe Resilience During Pod Churn

## Goal

Delete one NGINX Pod and observe its replacement while the Service continues routing traffic to available Pods.

### Evidence

#### Screenshot 12 — Output of the Pod deletion command

![ss12](/week-12-kubernetes/screenshots/Ass8-ss12.png)

---

#### Screenshot 13 — Output showing the replacement Pod and two running, ready Pods

![ss13](/week-12-kubernetes/screenshots/Ass8-ss13.png)

### Notes

**1. What happened after you deleted one Pod?**

The selected Pod terminated; Kubernetes created a replacement, and the Service could continue routing to the remaining ready backend.

**2. Which Kubernetes resource created the replacement Pod?**

The Deployment manages a ReplicaSet, and the ReplicaSet maintains the desired replica count by creating replacement Pods.

**3. Why can the NodePort Service continue working during Pod churn?**

The Service provides a stable entry point while its backend endpoints change. A remaining ready Pod can serve requests during replacement, provided the network path and Service configuration are functioning.

---

# Task 7 — Share Your NodePort Learning on LinkedIn

## Goal

Share what you learned about NodePort Services, backend Pods, and network access in your Kubernetes environment.

### Evidence

#### Screenshot 14 — Published LinkedIn post about your NodePort Service lab

![ss14](/week-12-kubernetes/screenshots/Ass8-ss14.png)

#### Linkedin post link

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7517706225250279424-xTF9/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Include the completed YAML manifests created during the lab.
- Add all required screenshots: Screenshots 1–8 and 12–14.
- Include Screenshots 9–11 only if you attempted optional Task 5.
- Complete the Notes for Tasks 1–4 and Task 6.
- Complete Task 5 Notes only if you attempted that task.
- Use clear, readable screenshots showing the relevant commands and outputs.
- Ensure your full name is visible in the required screenshots.
- If NodePort access is restricted by your environment, include the failed request output, ready endpoint evidence, and an explanation.
- Do not expose passwords, access tokens, private keys, kubeconfig contents, or account IDs.

---

# Completion Checklist

- [ ] Created and entered `~/k8s-labs/services/nodeport` (Screenshot 1)
- [ ] Created and applied the NGINX Deployment manifest (Screenshot 2)
- [ ] Confirmed successful rollout and two ready NGINX Pods (Screenshot 3)
- [ ] Created the NodePort Service manifest (Screenshot 4)
- [ ] Verified the Service and its endpoints or EndpointSlices (Screenshot 5)
- [ ] Recorded the assigned or selected NodePort
- [ ] Identified a node IP (Screenshot 6)
- [ ] Confirmed that the `tester` Pod is running (Screenshot 7)
- [ ] Tested NodePort access, or documented the environment limitation with evidence (Screenshot 8)
- [ ] Optional: Tested and restored the Service selector (Screenshots 9–11)
- [ ] Deleted one NGINX Pod (Screenshot 12)
- [ ] Confirmed the replacement Pod and two running, ready Pods (Screenshot 13)
- [ ] Completed all required Notes
- [ ] Published the LinkedIn post (Screenshot 14)
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

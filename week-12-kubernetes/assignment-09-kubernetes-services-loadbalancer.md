# Assignment 09 — Kubernetes Services: LoadBalancer on AKS

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

Deploy a healthy NGINX application to Azure Kubernetes Service (AKS), expose it publicly using a LoadBalancer Service, observe readiness behavior, and scale the application behind the same public endpoint.

---

# Task 1 — Create or Connect to an AKS Cluster

## Goal

Create a small AKS cluster for this lab, or connect to an existing approved AKS lab cluster.

### Evidence

#### Screenshot 1 — Output of `kubectl get nodes` showing ready AKS node(s)

![ss1](/week-12-kubernetes/screenshots/Ass9-ss1.png)

### Notes

**1. Why does this lab use a cloud-capable Kubernetes environment such as AKS for the LoadBalancer Service?**

A local cluster may not be integrated with a cloud load-balancer provider. AKS integrates Kubernetes Service provisioning with Azure networking, enabling Azure to create and configure load-balancing resources.

**2. What Azure resources can Kubernetes provision when a LoadBalancer Service is created?**

Depending on the cluster's configuration, a public LoadBalancer Service can cause Azure to configure load-balancing rules, frontend IP configuration, and associated backend connectivity. A public IP resource may also be provisioned for the Service. AKS has separate networking resources for cluster outbound connectivity.

**3. Why is it important to delete unused AKS resources after the lab?**

Compute, networking, and public IP resources can incur costs. Deleting a dedicated lab Resource Group after saving evidence helps prevent ongoing charges from resources you no longer need.


---

# Task 2 — Set Up Your Lab Directory

## Goal

Create and enter a dedicated directory for the LoadBalancer Service manifests.

### Evidence

#### Screenshot 2 — Terminal showing the output of `pwd` confirming that you are working inside `~/k8s-labs/services/loadbalancer`

![ss2](/week-12-kubernetes/screenshots/Ass9-ss2.png)

### Notes

**1. Why is it useful to keep Kubernetes manifests organized in dedicated directories?**

It keeps project files easy to find, review, version control, and reuse while reducing the chance of applying the wrong manifest.

**2. What are the names of the main Deployment and LoadBalancer Service YAML files you will create in this assignment?**


  * `00-nginx-deploy.yaml` — NGINX Deployment.

  * `01-nginx-svc-loadbalancer.yaml` — public LoadBalancer Service.

  * `02-readiness-broken.yaml` — temporary readiness-probe patch for the controlled failure test.

---

# Task 3 — Deploy a Healthy NGINX Application

## Goal

Create a healthy NGINX Deployment with readiness and liveness probes.

### Evidence

#### Screenshot 3 — Completed `00-nginx-deploy.yaml` manifest

![ss3](/week-12-kubernetes/screenshots/Ass9-ss3.png)

---

#### Screenshot 4 — Output showing successful rollout and two ready NGINX Pods

![ss4](/week-12-kubernetes/screenshots/Ass9-ss4.png)

### Notes

**1. Why must Pods be ready before they should receive public traffic?**

An application may be running but not yet able to serve requests. Readiness helps keep such Pods out of the ready backend pool.

**2. What is the role of the readiness probe in this Deployment?**

It checks whether NGINX can respond successfully to an HTTP request on `/`. A failed readiness check marks the Pod unready.

**3. What is the role of the liveness probe in this Deployment?**

It checks whether the container is alive and responsive. Repeated liveness failures can cause Kubernetes to restart the container.

Readiness and liveness solve different problems: readiness controls traffic eligibility; liveness helps recover from certain unhealthy container states.

---

# Task 4 — Create and Test the LoadBalancer Service

## Goal

Create a public LoadBalancer Service and verify that the NGINX application is reachable from the internet.

### Evidence

#### Screenshot 5 — Completed `01-nginx-svc-loadbalancer.yaml` manifest

![ss5](/week-12-kubernetes/screenshots/Ass9-ss5.png)

---

#### Screenshot 6 — Output showing the Service with an assigned EXTERNAL-IP

![ss6](/week-12-kubernetes/screenshots/Ass9-ss6.png)

---

#### Screenshot 7 — Successful curl output from the public IP

![ss7](/week-12-kubernetes/screenshots/Ass9-ss7.png)

### Notes

**1. What does `type: LoadBalancer` instruct AKS to do?**
Request a cloud load-balancer integration so that the Service can be reached through an external endpoint when public provisioning is supported.

**2. What public IP was assigned to your Service?**

68.220.231.210

**3. How does the public request eventually reach the NGINX Pods?**

The client contacts the public IP, Azure and AKS networking deliver traffic to the Service, and Service routing directs it to an eligible backend Pod.

**4. Why should you wait for EXTERNAL-IP before testing the Service?**

The Service needs time for Azure provisioning and configuration. Before an address is assigned, there is no confirmed public endpoint to test.

---

# Task 5 — Observe How Readiness Protects Public Traffic

## Goal

Intentionally break readiness and observe how Kubernetes excludes unready Pods from ready Service backends while existing healthy Pods continue serving public traffic.

### Evidence

#### Screenshot 8 — Completed `02-readiness-broken.yaml` patch file

![ss8](/week-12-kubernetes/screenshots/Ass9-ss8.png)

---

#### Screenshot 9 — Output showing the expected incomplete rollout or readiness failure

![ss9](/week-12-kubernetes/screenshots/Ass9-ss9.png)

---

#### Screenshot 10 — EndpointSlice output showing ready healthy backends and the effect of the readiness failure

![ss10](/week-12-kubernetes/screenshots/Ass9-ss10.png)

---

#### Screenshot 11 — Successful public curl response after recovery

![ss11](/week-12-kubernetes/screenshots/Ass9-ss11.png)

### Notes

**1. Why did the rollout not complete?**

The new Pod's readiness probe requests a nonexistent path, so NGINX responds with an unsuccessful HTTP status and the Pod cannot become ready.

**2. Why can the public endpoint still work while new Pods fail readiness?**

Existing ready Pods remain eligible to receive requests, so the Service can continue using them while the new Pod fails readiness.

**3. What would happen if Kubernetes routed traffic to Pods before they were ready?**

Clients could receive errors, incomplete responses, or other failures while an application starts or initializes.

**4. How did you restore the Deployment successfully?**

I Reapplied `00-nginx-deploy.yaml`, waited for the rollout, and confirmed healthy Pods and ready endpoints.

---

# Task 6 — Scale the Deployment Behind the Load Balancer

## Goal

Scale the NGINX Deployment and confirm that more ready Pods become available behind the same public endpoint.

### Evidence

#### Screenshot 12 — Two ready NGINX Pods verified initially; four ready Pods verified after scaling

![ss12](/week-12-kubernetes/screenshots/Ass9-ss12.png)

---

#### Screenshot 13 — Successful public curl response after scaling

![ss13](/week-12-kubernetes/screenshots/Ass9-ss13.png)

### Notes

**1. What changed after scaling the Deployment from two to four replicas?**

The Deployment maintains four Pods, and the Service's eligible endpoint set expands as the additional Pods become ready.

**2. Did the public IP change after scaling? Explain why or why not.**

It did not change merely because the Deployment replica count changed. The same Service remains in place.

**3. Why does scaling behind a LoadBalancer Service not require users to change the URL or IP they use?**

The Service and public endpoint provide a stable entry point while Kubernetes updates the backend endpoints behind it.

---

# Task 7 — Share Your LoadBalancer Lab on LinkedIn

## Goal

Share what you learned about exposing an NGINX application publicly through a LoadBalancer Service on AKS.

### Evidence

#### Screenshot 14 — Published LinkedIn post about your LoadBalancer lab on AKS

![ss14](/week-12-kubernetes/screenshots/Ass9-ss14.png)

#### LinkedIn post link

<https://www.linkedin.com/posts/wisgeorge1_devops-cloudcomputingnbsp-continuouslearning-ugcPost-7517854940761841664-CcmE/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

# Submission Instructions

- Include the completed YAML files:
  - `00-nginx-deploy.yaml`
  - `01-nginx-svc-loadbalancer.yaml`
  - `02-readiness-broken.yaml`
- Add all required screenshots, numbered 1–14, under their corresponding Evidence sections.
- Use clear, readable screenshots showing the relevant commands, configuration, and outputs.
- Ensure your full name is visible in the required screenshots.
- Complete the Notes for Tasks 1–6 in your own words.
- Capture all required evidence before cleaning up Azure resources.
- Plan or complete Azure cleanup according to your lab ownership and reuse arrangements.
- Do not expose passwords, tokens, private keys, cluster credentials, kubeconfig contents, subscription IDs, account IDs, or infrastructure details you are not permitted to share.

---

# Completion Checklist

- [ ] Created or connected to an approved AKS lab cluster
- [ ] Confirmed ready AKS node(s) (Screenshot 1)
- [ ] Created and entered the LoadBalancer lab directory (Screenshot 2)
- [ ] Created the NGINX Deployment manifest (Screenshot 3)
- [ ] Verified successful rollout and two ready NGINX Pods initially (Screenshot 4)
- [ ] Created the LoadBalancer Service manifest (Screenshot 5)
- [ ] Verified the assigned external IP (Screenshot 6)
- [ ] Verified successful public access using curl (Screenshot 7)
- [ ] Created the broken readiness patch (Screenshot 8)
- [ ] Observed the expected incomplete rollout or readiness failure (Screenshot 9)
- [ ] Inspected EndpointSlices during the readiness failure (Screenshot 10)
- [ ] Restored the healthy Deployment and verified public access (Screenshot 11)
- [ ] Scaled the Deployment to four ready Pods and verified updated Service backends (Screenshot 12)
- [ ] Verified public access after scaling (Screenshot 13)
- [ ] Completed the Notes for Tasks 1–6
- [ ] Published the LinkedIn post (Screenshot 14)
- [ ] Included all required YAML files and screenshots
- [ ] Planned or completed Azure cleanup
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

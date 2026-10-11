# Assignment 5 — Publish a Docker Container on Docker Hub

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Purpose

In this assignment, you will publish a Dockerized React application to Docker Hub, remove the local image tags, pull the image again from Docker Hub, and run it to verify that it can be downloaded and deployed from a container registry.

---

# Task 1 — Publish a Docker Image to Docker Hub

## Goal

Tag a locally built React image, publish it to Docker Hub, remove the local copy, pull it again from Docker Hub, and run it successfully.

### Evidence

#### Screenshot 1 — Public Docker Hub Repository

Add a screenshot of Docker Hub showing your newly created public repository:

```text
my-react-app
```

![ss1](/week-11-docker/screenshots/Ass-5-SS1.png)

---

#### Screenshot 2 — Successful Docker Login

Add a screenshot of the terminal showing:

```text
Login Succeeded
```

Ensure that your full name is visible and that no password, Personal Access Token, or device code is exposed.

![ss2](/week-11-docker/screenshots/Ass-5-SS2.png)

---

#### Screenshot 3 — Correctly Tagged Image

Add a screenshot of the terminal showing:

```bash
docker image ls <YOUR_DOCKERHUB_USERNAME>/my-react-app
```

The output must show the `latest` tag.

![ss3](/week-11-docker/screenshots/Ass-5-SS3.png)

---

#### Screenshot 4 — Successful Docker Push

Add a screenshot of the terminal showing successful completion of:

```bash
docker push <YOUR_DOCKERHUB_USERNAME>/my-react-app:latest
```

The output must include a pushed status or image digest.

![ss4](/week-11-docker/screenshots/Ass-5-SS4.png)

---

#### Screenshot 5 — Published `latest` Tag in Docker Hub

Add a screenshot of your Docker Hub repository showing the uploaded `latest` image tag.

![ss5](/week-11-docker/screenshots/Ass-5-SS5.png)

---

#### Screenshot 6 — Local Image Removed and Pulled Again

Add a screenshot of the terminal showing:

- The targeted local image tags removed
- Successful `docker pull` output
- `docker image ls` showing the pulled image

![ss6](/week-11-docker/screenshots/Ass-5-SS6.png)

---

#### Screenshot 7 — Running Pulled Image

Add a screenshot of the terminal showing:

```bash
docker ps
```

The output must show the running `react-container` with:

```text
0.0.0.0:80->80/tcp
```

![ss7](/week-11-docker/screenshots/Ass-5-SS7.png)

---

#### Screenshot 8 — React Application in Browser

Add a browser screenshot showing the React application at:

```text
http://<YOUR-VM-PUBLIC-IP>
```

Ensure that the VM public IP is visible in the address bar. Add your full name as a clear caption directly below the screenshot.

![ss8](/week-11-docker/screenshots/Ass-5-SS8.png)

---

# Docker Hub Repository URL

**Repository URL:** `<https://hub.docker.com/repository/docker/wisegeorge1/my-react-app>`

---

# Registry and Image Tagging Notes

Write a short explanation covering:

- Why image tagging is required before pushing to Docker Hub
- Why a container registry is useful in DevOps workflows
- Why production deployments should use versioned image tags instead of relying only on `latest`

1. Why image tagging is required before pushing to Docker Hub

Docker Hub identifies images using a repository name and tag, such as:

wisegeorge1/my-react-app:latest


The original local image:
react-multistage:latest

does not identify the Docker Hub repository where the image should be stored. The docker tag command creates a registry compatible reference:


docker tag react-multistage:latest \
  wisegeorge1/my-react-app:latest


This tells Docker where the image belongs when docker push is executed. Tagging does not rebuild the image; it creates another reference to the existing image.

2. Why a container registry is useful in DevOps workflows

A container registry such as Docker Hub provides a central location for storing, versioning, and distributing Docker images. A CI/CD pipeline can build and test an image once, push it to the registry, and then allow development, staging, and production environments to pull that same tested image.

This creates a workflow such as:
Code
  ↓
CI/CD Pipeline
  ↓
Build & Test
  ↓
Docker Image
  ↓
Container Registry
  ↓
Development / Staging / Production


This improves consistency because environments can deploy the same application artifact instead of rebuilding the application separately.

3. Why production should use versioned tags instead of relying only on latest

The latest tag is mutable. It can point to a different image after another push, making it difficult to determine exactly which application version is running in production.

For example:
my-react-app:latest
could point to version 1.0 today and version 1.1 tomorrow.
Production deployments should instead use explicit version tags such as:
my-react-app:v1.0.0
my-react-app:v1.0.1
my-react-app:v1.1.0

or CI-generated tags such as:
my-react-app:build-125
my-react-app:commit-a1b2c3d


Versioned tags make deployments traceable and reproducible, simplify rollback, and make it clear which image version is running in each environment. For even stronger immutability, deployments can reference the image's SHA-256 digest.

## summary
tagging identifies where an image belongs, a registry provides reliable image distribution, and versioned tags make production deployments predictable and auditable.


---

# LinkedIn Requirement

## Goal

Create a LinkedIn post about publishing a Docker container image to Docker Hub.

Include:

- Assignment title: **Publish a Docker Container Image to Docker Hub**
- Your Docker Hub repository URL
- What you published
- How you verified the remote image by pulling and running it
- Key learning outcomes

### Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

<https://www.linkedin.com/posts/wisgeorge1_dmibypravinmishra-devops-cloudcomputing-ugcPost-7515183153649541120-aAwI/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADp8HhoB_UGFhHiID8Ba-4DVResYfMJJsuY>

---

#### LinkedIn Post Screenshot

![ss9](/week-11-docker/screenshots/Ass-5-SS9.png)

---

# Submission Instructions

- Complete all steps in sequence.
- Include Screenshots 1–8 exactly as specified.
- Include your Docker Hub repository URL.
- Include the Registry and Image Tagging Notes.
- Include the LinkedIn post URL and screenshot.
- Ensure that your full name is visible in all terminal screenshots.
- Add your full name as a clear caption below the browser screenshot.
- Do not expose passwords, Personal Access Tokens, device codes, credentials, or other sensitive information.

---

# Completion Checklist

- [ ] Public `my-react-app` repository created
- [ ] Docker login completed successfully
- [ ] `react-multistage:latest` tagged correctly
- [ ] Image pushed to Docker Hub
- [ ] `latest` tag verified in Docker Hub
- [ ] Targeted local image tags removed
- [ ] Image pulled again from Docker Hub
- [ ] Pulled image runs successfully
- [ ] React application is accessible through the VM public IP
- [ ] Docker Hub repository URL included
- [ ] Registry and image-tagging notes completed
- [ ] LinkedIn post URL and screenshot included
- [ ] All required screenshots included
- [ ] Full name visible in terminal screenshots
- [ ] Browser screenshot has a full-name caption
- [ ] No passwords, tokens, or credentials exposed
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

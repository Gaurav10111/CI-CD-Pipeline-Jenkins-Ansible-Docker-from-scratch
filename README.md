# 🚀 CI/CD Pipeline: Jenkins + Ansible + Docker (From Scratch)

This project demonstrates a complete CI/CD pipeline built **entirely from scratch** using Dockerized Jenkins, Ansible automation, and a custom private Docker registry. It showcases seamless integration of code pull, image build, secure image push, and automated deployment via Ansible—all without Docker Hub.

---

## 📁 Project Structure

CI-CD-Pipeline-Jenkins-Ansible-Docker/  
│  
├── app/  
│   ├── Dockerfile  
│   ├── app.py  
│   ├── requirements.txt  
│   └── Jenkinsfile  
│  
├── Config-Scripts/  
│   ├── setup_jenkins_master.sh  
│   ├── setup_image_builder.sh  
│   ├── setup_ansible_master.sh  
│   ├── setup_deployer_node.sh  
│  
├── Ansible_WS/  
│   ├── ansible.cfg  
│   ├── inventory  
│   └── deploy.yml  

---

## 🧱 1. Infrastructure Setup

- Launched a **single EC2 instance** (Amazon Linux/RHEL).
- Pulled and ran **five custom containers**:
  - Jenkins Master
  - Image Builder Node
  - Ansible Master
  - Deployer Node
  - Private Docker Registry
- Each container is initialized via custom scripts in `/Config-Scripts`.

---

## 🔐 2. SSH & User Configuration

- Configured key-based SSH access:
  - `Jenkins → Image Builder` (for build & push)
  - `Jenkins → Ansible Master` (to trigger playbook)
  - `Ansible Master → Deployer Node` (for app deployment)
  
- Created dedicated users with passwordless sudo:
  - `jenkins`, `jenkinsAgent`, `ansible`, `deployer`

- SSH Setup:
  - `~/.ssh` directory created with proper permissions
  - Keys distributed using `ssh-copy-id` or manually

---

## ⚙️ 3. Jenkins Setup

- Jenkins runs as a **Docker container** with:
  - Custom volume for persistence
  - Public keys added for agents
  - GitHub and SSH credentials configured

- Node Configuration:
  - Permanent node added for the **image builder**
  - Connected using SSH launcher

---

## 📦 4. Private Docker Registry

- Deployed a Docker registry container on port `5000`
- Used EC2 **private IP** in `Jenkinsfile` for push/pull
- Verified registry with:
  ```bash
  curl http://<PRIVATE-IP>:5000/v2/_catalog
  curl http://<PRIVATE-IP>:5000/v2/<image-name>/tags/list
  ```

---

## 🧪 5. Jenkins CI/CD Pipeline
Defined in Jenkinsfile inside /app directory

Pipeline stages:

Checkout Code from GitHub  
          ↓  
Build Docker Image (on image builder)  
↓  
Push Image to Registry  
↓  
Transfer Ansible Workspace to Ansible Master  
↓  
Run Ansible Playbook to deploy app on deployer node  

---
## 📤 6. Deployment & App Access
App runs inside Docker on the deployer node

Exposed port `5000` in container

Access using EC2 public IP:
```bash
http://<EC2-PUBLIC-IP>:5000
```
---
### 📌 Final Validation Checklist  
🔑 SSH Key Permissions & Ownership  
Ensure all SSH keys and folders are securely configured:  

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chown -R <user>:<user> ~/.ssh
```
---
### ⚙️ Services Check
Verify essential services:

#### Docker Daemon
```bash
sudo systemctl status docker
```

#### SSH Daemon
```bash
sudo systemctl status sshd
```
---
### 📝 Registry Insecure Access Config
Check /etc/docker/daemon.json on image builder:

```bash
{
  "insecure-registries": ["<PRIVATE-IP>:5000"]
}
```
Then restart Docker:
```bash
sudo systemctl daemon-reexec
sudo systemctl restart docker
```
---
#### 📦 Docker Image Verification
Make sure image was pushed:
```bash
curl http://<PRIVATE-IP>:5000/v2/<image-name>/tags/list
```

#### 📂 Jenkins Credentials
Verify Jenkins credentials:

SSH Key credentials for agents

GitHub token credential


#### ✅ Technologies Used
Jenkins (CI Orchestrator)

Ansible (Deployment Automation)

Docker (Containerization)

EC2 (Base host & target machine)

Private Docker Registry (Image store)

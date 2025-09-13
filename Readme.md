# Pipeline Setup Guide

## Architecture Overview

```
GitHub Repository → Jenkins → Docker Hub → AWS ECS → CloudWatch
     ↓               ↓           ↓           ↓          ↓
 Code Push      Build & Test  Store Image  Deploy App  Monitor
```

## Prerequisites

- AWS Account with appropriate permissions
- GitHub Account
- Docker Hub Account
- Jenkins Server (can be on EC2)
- Terraform installed (optional but recommended)

## 1. Repository Structure

First, ensure your repository has this structure:

```
devops-task/
├── app.js
├── package.json
├── package-lock.json
├── logoswayatt.png
├── Dockerfile
├── Jenkinsfile
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
├── Output_images
└── README.md
```

## 2. Application Files

### Dockerfile
### package.json 
## 3. Jenkins Pipeline
### Jenkinsfile
### terraform/outputs.tf
### terraform/terraform.tfvars
```hcl
aws_region = "us-east-1"
docker_image = "your-dockerhub-username/devops-sample-app"
```

## 5. Setup Instructions

### Step 1: Prepare GitHub Repository
1. Fork/clone the repository
2. Create `dev` branch: `git checkout -b dev`
3. Add all the files above to your repository
4. Push to GitHub

### Step 2: Set up Jenkins
1. Install Jenkins on EC2 or use existing instance
2. Install required plugins:
   - Pipeline
   - GitHub Integration
   - Docker Pipeline
   - AWS Credentials

3. Configure credentials in Jenkins:
   - Docker Hub credentials (username/password/PAT)
   - AWS credentials (Access Key/Secret Key)

### Step 3: Configure GitHub Webhook
1. Go to your repository → Settings → Webhooks
2. Add webhook URL: `http://your-jenkins-url/github-webhook/`
3. Select "Just the push event"

you can also use ngrok - ngrok creates secure tunnels to your local machine, making your local Jenkins server accessible from the internet so GitHub can send webhooks to trigger your CI/CD pipeline.

### Step 4: Deploy Infrastructure
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Step 5: Create Jenkins Pipeline
1. New Item → Pipeline
2. Configure GitHub project URL
3. Build Triggers → GitHub hook trigger for GITScm polling
4. Pipeline → Pipeline script from SCM → Git

## 6. Monitoring and Logging

### CloudWatch Monitoring
Access logs and metrics:

1. **CloudWatch Logs**: 
   - Go to CloudWatch → Logs → Log Groups
   - Find `/ecs/devops-app`
   - View container logs

2. **ECS Metrics**:
   - CloudWatch → Metrics → ECS
   - Monitor CPU, Memory, Network utilization


### Key Metrics to Monitor
- CPU Utilization
- Memory Utilization
- Request Count
- Response Time
- Error Rate

## 7. Branching Strategy

### Main Branch
- Production-ready code
- Protected branch
- Requires PR reviews

### Dev Branch
- Development code
- Feature integration

## 8. Pipeline Flow

1. **Code Push** → GitHub receives code push
2. **Webhook** → Triggers Jenkins build
3. **Checkout** → Jenkins pulls latest code
4. **Build** → Install dependencies
5. **Dockerize** → Build Docker image
6. **Push** → Push image to Docker Hub
7. **Deploy** → Update ECS service
8. **Monitor** → CloudWatch tracks metrics/logs

## 9. Best Practices Implemented

- **Infrastructure as Code**: Terraform for reproducible infrastructure
- **Containerization**: Docker for consistent environments
- **Automated Testing**: Integrated test stage
- **Blue-Green Deployment**: ECS service updates
- **Monitoring**: CloudWatch integration
- **Security**: IAM roles, Security groups
- **Scalability**: ECS Fargate auto-scaling capability

## 10. Troubleshooting

### Common Issues:
1. **Jenkins Build Fails**: Check credentials and permissions
2. **Docker Push Issues**: Verify Docker Hub credentials
3. **ECS Deployment Fails**: Check IAM roles and security groups
4. **Application Not Accessible**: Verify security group rules

## Issues and Fixes

### Issue 1: Wrong Credential Type
**Problem**: Using "Secret text" instead of "Username with password"
**Fix**: Recreate credentials with correct type

### Issue 2: Expired or Invalid PAT
**Problem**: Personal Access Token expired or has wrong permissions
**Fix**: Generate new PAT with Read/Write/Delete permissions

### Issue 3: Repository Name Mismatch
**Problem**: Repository name in Jenkinsfile doesn't match Docker Hub
**Fix**: Ensure exact match: `username/repository-name`

### Issue 5: Jenkins User Permissions
**Problem**: Jenkins user doesn't have Docker permissions
**Fix**: Add jenkins user to docker group:
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

## Verification Steps

After implementing fixes:

1. **Check Jenkins Credentials**:
   - Go to Manage Jenkins → Manage Credentials
   - Verify your Docker Hub credentials exist with correct ID

2. **Test Build**:
   - Trigger a manual build
   - Check console output for authentication success

3. **Verify Docker Hub**:
   - Check if images appear in your Docker Hub repository
   - Verify tags are correct

## Environment Variables Check

Make sure these are properly set in your environment:

```bash
# In your Jenkins pipeline environment
DOCKER_IMAGE = 'your-actual-dockerhub-username/devops-sample-app'
```

Replace `your-actual-dockerhub-username` with your real Docker Hub username.


## Architecture Diagram

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   GitHub    │───▶│   Jenkins   │───▶│ Docker Hub  │
│ Repository  │    │   Server    │    │  Registry   │
└─────────────┘    └─────────────┘    └─────────────┘
                           │                    │
                           ▼                    │
                   ┌─────────────┐              │
                   │   AWS ECS   │◀─────────────┘
                   │  (Fargate)  │
                   └─────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │ CloudWatch  │
                   │ Monitoring  │
                   └─────────────┘
```
## Support & Contact

**Created by**: Anuragstark  
**Email**: anuragchauhan536@gmail.com  

If you have any questions about this CI/CD pipeline setup or encounter any issues, feel free to reach out via email. Happy to help with Jenkins, Docker, AWS ECS...

**Thank you for using this guide!** 
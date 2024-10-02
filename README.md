# **Litecoin Deployment and AWS Infrastructure Automation**

This repository contains the deployment of a Dockerized Litecoin application and the automation of AWS infrastructure using Terraform and Terragrunt. Additionally, it includes a Lambda function that handles file movements within an S3 bucket.

---

## **Table of Contents**
- [Project Overview](#project-overview)
- [Task Breakdown](#task-breakdown)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Task 3: Terraform/Terragrunt AWS Infrastructure](#task-3-terraformterragrunt-aws-infrastructure)
- [Task 4: AWS Lambda Function for S3](#task-4-aws-lambda-function-for-s3)
- [CI/CD Workflow](#cicd-workflow)
- [License](#license)

---

## **Project Overview**

This project comprises four main tasks:
1. **Docker**: Containerizing the Litecoin application using Docker and ensuring its secure deployment.
2. **CI/CD**: Implementing a continuous integration/continuous deployment (CI/CD) pipeline to automatically build and deploy the Docker image to a remote server using GitHub Actions.
3. **Terraform/Terragrunt**: Creating AWS infrastructure with Terraform, including an S3 bucket with lifecycle policies and necessary IAM roles and policies.
4. **AWS Lambda**: Writing a Lambda function triggered by file uploads to an S3 bucket, which moves the file to a different directory.

---

## **Task Breakdown**

### **Task 1: Docker - Containerizing Litecoin**
- The project includes a Dockerfile that builds and runs the Litecoin application.
- The image is built on a secure, minimal base image (`Ubuntu 18.04`), ensuring security by adding a non-root user and stripping binaries.
- You can execute the Litecoin daemon by running:
  ```bash
  docker run asyncdeveloper/litecoin
  ```

### **Task 2: CI/CD - Build and Deployment Pipeline**
- A GitHub Actions pipeline is configured to automatically build the Docker image, push it to DockerHub, and deploy the updated container to a remote server.
- The pipeline includes stages for building the Docker image, pushing it to DockerHub, and deploying it to a remote VM using SSH and Docker Compose.

### **Task 3: Terraform/Terragrunt AWS Infrastructure**
- This task automates the provisioning of AWS resources using Terraform and Terragrunt.
- Resources provisioned:
  - An S3 bucket with a lifecycle policy to delete files older than 7 days.
  - An IAM policy to allow a specific group to push/delete objects to/from the S3 bucket.
  - An IAM group with the attached policy.
  - An IAM user that is part of the group.
  - An IAM role for another AWS service to push/delete objects from the bucket.

### **Task 4: AWS Lambda Function for S3**
- A simple Lambda function (written in Python) is triggered when a file is uploaded to a specific directory in the S3 bucket.
- The Lambda function moves the file to another directory within the same bucket (e.g., from `mydir1/` to `mydir2/`).
- This automates the file organization in the bucket after uploads.

---

## **Prerequisites**

- **AWS Account**: To apply the Terraform/Terragrunt code and create the required resources.
- **Docker**: To run the Litecoin container.
- **DockerHub Account**: To push the Docker image as part of the CI/CD pipeline.
- **GitHub Account**: To use GitHub Actions for CI/CD.
- **Terraform and Terragrunt**: To manage AWS infrastructure.

---

## **Setup Instructions**

### **1. Clone the Repository**
  To work with the litecoin application in task 1 and 2, you have to clone `https://github.com/geek0ps/litecoin-deployment.git`
   ```bash
   git clone https://github.com/geek0ps/litecoin-deployment.git
   cd litecoin-deployment
   ```

  To work with the S3, IAM and Lambda Resources you have to clone `https://github.com/geek0ps/geek-project.git`
    ```bash
   git clone https://github.com/geek0ps/geek-project.git
   cd geek-project
   ```

### **2. Docker Setup for Litecoin Deployment**
   - Ensure Docker is installed on your local machine or remote server.
   - Build the Docker image:
     ```bash
     docker build -t litecoin-deployment .
     ```
   - Run the Litecoin container:
     ```bash
     docker run -d -p 9333:9333 -p 9332:9332 litecoin-deployment
     ```

### **3. Running Terragrunt Code for AWS Infrastructure**

   - Navigate to the directory where the Terragrunt configuration is stored:
   For s3 and IAM resources in task 1 and 2:
     ```bash
      cd iac/dev/eu-west-1/bucket-iam-resources
     ```

    For Lambda and IAM resources in task 3 and 4:
      ```bash
      cd iac/dev/eu-west-1/lambda-resources
     ```

   - Run the Terragrunt commands to provision AWS resources:
     ```bash
     terragrunt init
     terragrunt plan
     terragrunt apply
     ```

### **4. Configure AWS Credentials Locally**

   - Generate AWS credentials by creating an IAM user with programmatic access.
   - Configure the AWS CLI locally:
     ```bash
     aws configure
     ```
     Input the AWS Access Key, Secret Access Key, and region (e.g., `eu-west-1`).

### **5. DockerHub Setup for CI/CD**
   - Create a [DockerHub account](https://hub.docker.com/).
   - Generate a Personal Access Token (PAT) to use as the password in GitHub Actions for Docker login.

---

## **Task 3: Terraform/Terragrunt AWS Infrastructure**

### **Steps to Run the Code:**

1. Install Terraform and Terragrunt locally:
   ```bash
   sudo apt-get install terraform
   wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.35.5/terragrunt_linux_amd64
   sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
   chmod +x /usr/local/bin/terragrunt
   ```

2. Navigate to the `bucket-iam-resources` directory:
   ```bash
   cd iac/dev/eu-west-1/bucket-iam-resources
   ```

3. Initialize, plan, and apply the infrastructure:
   ```bash
   terragrunt init
   terragrunt plan
   terragrunt apply
   ```

---

## **Task 4: AWS Lambda Function for S3**

### **Steps to Run the Code:**

1. Install Terraform and Terragrunt locally:
   ```bash
   sudo apt-get install terraform
   wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.35.5/terragrunt_linux_amd64
   sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
   chmod +x /usr/local/bin/terragrunt
   ```

2. Navigate to the `lambda-resources` directory:
   ```bash
   cd iac/dev/eu-west-1/lambda-resources
   ```

3. Initialize, plan, and apply the infrastructure:
   ```bash
   terragrunt init
   terragrunt plan
   terragrunt apply
   ```

---

## **CI/CD Workflow**

The CI/CD pipeline in this project uses GitHub Actions to automate the build and deployment process. Upon each push to the `main` branch, the workflow performs the following actions:
1. **Build**: Docker image is built from the repository.
2. **Push**: The image is pushed to DockerHub with the current commit SHA as the tag.
3. **Deploy**: The new Docker image is pulled from DockerHub, and the running container is updated on the remote server.

You will need to configure the following GitHub Secrets:
- `DOCKER_USERNAME`: Your DockerHub username.
- `DOCKER_PASSWORD`: Your DockerHub personal access token (PAT).
- `SERVER_IP`: The IP address of the server for deployment.
- `SERVER_USERNAME`: The username for SSH into the server.
- `SERVER_PASSWORD`: The password or SSH private key for the server.

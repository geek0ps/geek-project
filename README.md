# **Litecoin Deployment and AWS Infrastructure Automation**

This repository contains the deployment of a Dockerized Litecoin application and the automation of AWS infrastructure using Terraform and Terragrunt. Additionally, it includes a Lambda function that handles file movements within an S3 bucket.

---

## **Table of Contents**
- [Project Overview](#project-overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [CI/CD Workflow](#cicd-workflow)
- [Secrets Configuration](#secrets-configuration)
---

## **Project Overview**

This project comprises four main tasks:
1. **Docker**: Containerizing the Litecoin application using Docker and ensuring its secure deployment.
2. **CI/CD**: Implementing a continuous integration/continuous deployment (CI/CD) pipeline to automatically build and deploy the Docker image to a remote server using GitHub Actions.
3. **Terraform/Terragrunt**: Creating AWS infrastructure with Terraform, including an S3 bucket with lifecycle policies and necessary IAM roles and policies.
4. **AWS Lambda**: Writing a Lambda function triggered by file uploads to an S3 bucket, which moves the file to a different directory.

---

## **Prerequisites**

To work with this project, ensure you have the following:

- **AWS Account**: To apply the Terraform/Terragrunt code and create the required resources.
- **Docker**: To run the Litecoin container.
- **DockerHub Account**: To push the Docker image as part of the CI/CD pipeline.
- **GitHub Account**: To use GitHub Actions for CI/CD.
- **Terraform and Terragrunt**: To manage AWS infrastructure.
- **CLI Tools**: Make sure to install the following command-line tools:
  - **Docker**: [Docker Installation Guide](https://docs.docker.com/get-docker/)
  - **Terraform**: [Terraform Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  - **Terragrunt**: [Terragrunt Installation Guide](https://terragrunt.gruntwork.io/docs/getting-started/installation/)

---

## **Setup Instructions**

### **1. Clone the Repositories**
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
   - For S3 and IAM resources in Task 3:
     ```bash
     aws configure
     cd iac/dev/eu-west-1/bucket-iam-resources
     terragrunt apply
     ```

   - For Lambda and IAM resources in Task 4:
     ```bash
     aws configure
     cd iac/dev/eu-west-1/lambda-resources
     terragrunt apply
     ```


**Theory Answer:**
Use a Deployment Package (ZIP file)
  - Step 1: Install the required library locally (on your machine) or in a virtual environment using pip.
    ```bash
    pip install <library-name> -t /path/to/your/lambda/folder
    ```
  - Step 2: Package the installed libraries along with your Lambda function code into a ZIP file. Make sure all dependencies and your Lambda function (lambda_function.py) are in the root of the ZIP.
    ```bash
    cd /path/to/your/lambda/folder
    zip -r lambda_function.zip .
    ```
  - Step 3: Upload this ZIP file to AWS Lambda through the AWS Management Console, AWS CLI, or SDK.


---

## **CI/CD Workflow**

The CI/CD pipeline automates the process of building the Docker image, pushing it to DockerHub, and deploying the updated image to a remote server using GitHub Actions.

### **Secrets Configuration**

Before running the CI/CD pipeline, ensure that the necessary secrets are configured in your GitHub repository under **Settings > Secrets and variables > Actions > New repository secret**.

Here is the list of required secrets:

1. **`DOCKER_USERNAME`**: Your DockerHub username.
2. **`DOCKER_PASSWORD`**: A personal access token (PAT) for DockerHub.
3. **`SERVER_IP`**: The IP address of the remote server where the Docker container will be deployed.
4. **`SERVER_USERNAME`**: The username of the remote server for SSH access.
5. **`SERVER_PASSWORD` or `SERVER_SSH_KEY`**: Either the password for the SSH connection or an SSH private key.

### **Setting up the CI/CD Workflow**

1. **Add the secrets**: Follow the instructions above to add the required secrets to your GitHub repository.
   
2. **Trigger the Workflow**: The CI/CD pipeline is triggered on a `push` to the `main` branch. Once triggered, the following steps occur:
   - **Build the Docker image**: The image is built from the Dockerfile and tagged with the latest Git commit SHA.
   - **Push to DockerHub**: The image is pushed to DockerHub using the credentials provided in the secrets.
   - **Deploy to the server**: The Docker image is pulled from DockerHub and deployed on the remote server using SSH and Docker Compose.


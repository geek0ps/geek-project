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

---

## **Project Overview**

This project comprises four main tasks:
1. **Docker**: Containerizing the Litecoin application using Docker for secure deployment. [View the repository for Task 1 and 2](https://github.com/geek0ps/litecoin-deployment).
2. **CI/CD**: Implementing a continuous integration/continuous deployment (CI/CD) pipeline to automatically build and deploy the Docker image to a remote server using GitHub Actions. [View the repository for Task 1 and 2](https://github.com/geek0ps/litecoin-deployment).
3. **Terraform/Terragrunt**: Automating the creation of AWS resources, such as S3 buckets and IAM policies, using Terraform and Terragrunt.
4. **AWS Lambda**: Writing a Lambda function triggered by file uploads to an S3 bucket, which moves the files to a different directory.

---

## **Prerequisites**

The following CLI tools need to be installed on your system before proceeding:

1. **Docker**: To run the Litecoin container. Install [Docker](https://docs.docker.com/get-docker/).
2. **AWS CLI**: For managing AWS credentials and testing Lambda functions. Install [AWS CLI](https://aws.amazon.com/cli/).
3. **Terraform**: To manage infrastructure as code. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli).
4. **Terragrunt**: A wrapper for Terraform to make the code DRY. Install [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/).
5. **Git**: To clone the repositories and manage version control. Install [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
6. **DockerHub Account**: To push the Docker image for Litecoin. Sign up at [DockerHub](https://hub.docker.com/).
7. **GitHub Account**: To use GitHub Actions for CI/CD. Sign up at [GitHub](https://github.com/).

---

## **Setup Instructions**

### **1. Clone the Repository**

To work with the Litecoin application in Task 1 and 2:
   ```bash
   git clone https://github.com/geek0ps/litecoin-deployment.git
   cd litecoin-deployment
   ```

For the S3, IAM, and Lambda resources in Task 3 and Task 4:
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
   ```bash
   cd iac/dev/eu-west-1/bucket-iam-resources
   ```

   - Initialize Terragrunt and apply the Terraform configuration:
     ```bash
     terragrunt init
     terragrunt apply
     ```

   - This will provision the S3 bucket, IAM policies, and associated resources.

---

## **Task 4: AWS Lambda Function for S3**
   - The AWS Lambda function is deployed via the AWS Console or Terraform scripts.
   - The function is triggered when files are uploaded to the S3 bucket.

---

## **CI/CD Workflow**
- The GitHub Actions pipeline automates the deployment of the Dockerized Litecoin app.
- To update the pipeline configuration, edit the `.github/workflows/ci-cd.yml` file.



### **Note**
The CI/CD workflow assumes there is docker-compose installed on the virtual machine being deployed to and it also assumes there is docker-compose.yml file situated in the home directory of the user specified.
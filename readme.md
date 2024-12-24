# Jenkins CI/CD Pipeline for Code Quality and Security Analysis

This repository contains a Jenkins pipeline setup for continuous integration and continuous deployment (CI/CD). The pipeline integrates several open-source tools to assess code quality, code coverage, cyclomatic complexity, and security vulnerabilities.

## Tools Integrated

- **SonarQube**: Analyzes the code quality, technical debt, and provides metrics such as cyclomatic complexity.
- **JaCoCo**: Provides code coverage reports for Java applications.
- **OWASP Dependency-Check**: Scans for security vulnerabilities in project dependencies.
- **Email Notifications**: Sends build success and failure notifications.

## Pipeline Overview

The Jenkins pipeline is defined in a `Jenkinsfile` and consists of the following stages:

1. **Git Checkout**: Checks out the code from the GitHub repository.
2. **Compile**: Compiles the project using Maven.
3. **Test Cases**: Runs unit tests using Maven.
4. **SonarQube Analysis**: Analyzes the code using SonarQube for code quality and technical debt.
5. **Quality Gate**: Waits for the SonarQube quality gate to ensure the code passes the quality checks.
6. **OWASP Dependency-Check**: Scans project dependencies for known security vulnerabilities using OWASP Dependency-Check.
7. **JaCoCo Report**: Generates code coverage reports with JaCoCo.
8. **Notifications**: Sends email notifications upon success or failure of the build.

## Prerequisites

Before running this pipeline, ensure the following:

- **Jenkins** is installed and configured with the necessary plugins.
- The Jenkins environment has **SonarQube**, **JaCoCo**, and **OWASP Dependency-Check** installed and configured.
- The GitHub repository is set up and accessible to Jenkins.
- You have an SMTP server or email service configured in Jenkins for sending email notifications.

## Jenkins Setup

1. **Install Jenkins** on your local or cloud-based VM.
2. **Configure Jenkins Plugins**:

   - Git Plugin
   - Maven Plugin
   - SonarQube Plugin
   - OWASP Dependency-Check Plugin
   - JaCoCo Plugin
   - HTML Publisher Plugin
   - Email Extension Plugin

3. **Configure Jenkins Tools**:

   - Configure **JDK** and **Maven** in Jenkins' global tool configuration (for the build process).

4. **Create Jenkins Job**:
   - Create a **Pipeline Job** in Jenkins.
   - Set the **Pipeline script** option to "Pipeline from SCM".
   - Choose **Git** as the SCM and provide the repository URL.
   - Set the branch to `main` or the default branch used in your project.

## Terraform Setup for Jenkins and SonarQube

### Step 1: Initialize Terraform

To provision Jenkins and SonarQube in a dedicated VPC, run the following Terraform commands in the project directory:

```bash
terraform init
terraform apply -auto-approve
```

Refer Sonar.docx for more snapshots

## **Rearc Quest Submission by Sujit Ghodajkar**
I have performed this task in KodeKloud Playgrounds.
---

### **Summary Plan of Action for Deploying our Node.js Application in AWS**

### **Step 1: Set Up AWS Resources Using Terraform**

1. **Create an S3 Bucket for Terraform State (optional)**
    - Use Terraform to define remote backend for storing the state.
2. **Define Resources in Terraform**:
    - **ECR Repository**: For storing the Docker image.
    - **ECS Cluster**: To host the tasks.
    - **Task Definition**: Specify the container image, environment variables (e.g., `SECRET_WORD`), CPU/memory requirements.
    - **Fargate Service**: Use Fargate to run the task and associate it with an Application Load Balancer (ALB).
    - **ALB**: Configure HTTP listener, target group, and health checks.
    - **Auto-Scaling Group**: Define scaling policies to trigger based on CPU usage >70%.
3. **Network Configuration**:
    - Create a VPC, subnets (public/private), internet gateway, NAT gateway, and security groups.

### **Step 2: Build and Push the Docker Image to ECR**

1. **Login to ECR**
    
2. **Build and Tag the Image**
    
3. **Push the Image**
    

### **Step 3: Deploy the Application Using Terraform**

1. Run Terraform commands:
    
    ```
    terraform init
    terraform plan
    terraform apply
    
    ```
    
2. This creates:
    - ECS Cluster and Service
    - Task Definition (linked to the ECR image)
    - ALB with DNS output
    - Auto-scaling configuration

### **Step 4: Validate the Deployment**

1. Access the application using the ALB DNS name from the Terraform output:
    
    ```
    http://<load_balancer_dns>
    
    ```
    
2. Verify:
    - Index page displays the secret word.
    - `/docker`, `/secret_word`, and `/loadbalanced` endpoints work as expected.

---

### **Below are the steps to deploy the application in AWS**:

## **1. Prerequisites**

Before you begin, ensure you have the following:

- AWS account with appropriate IAM permissions.
- Terraform installed on your local machine.
- Docker installed to build and push the application image.
- Node.js application source code.

---

## **2. Steps to Deploy**

### **Step 1: Create an ECR Repository**

1. Use AWS CLI or the Management Console to create an ECR repository.
    
    ```
    aws ecr create-repository --repository-name <your-app-repo>
    ```
    
2. Authenticate Docker to ECR:
    
    ```
    aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com
    ```
    
3. Build and push your Docker image:

Use the provided Dockerfile to build the docker image of our Node.js application

    
    ```
    docker build -t <your-app-repo>:latest .
    docker tag <your-app-repo>:latest <account_id>.dkr.ecr.<region>.amazonaws.com/<your-app-repo>:latest
    docker push <account_id>.dkr.ecr.<region>.amazonaws.com/<your-app-repo>:latest
    ```
---
![alt text](Images/Docker-image-push-ECR.png)

![alt text](Images/Image-ECR.png)

### **Step 2: Write Terraform Configuration for AWS Resources**

### **2.1 Terraform Setup**

1. Create a Terraform working directory:
    
    ```
    mkdir rearc-app-terraform
    cd rearc-app-terraform
    ```
    
2. Initialize Terraform:
    
    ```
    terraform init
    ```
    

### **2.2 Terraform Configuration File**

Write the all the resources names to be created in a `main.tf` files provided in rearc-app-terraform and modules


### **Step 3: Apply Terraform Configuration**

Run the following commands to deploy the resources:

1. Initialize Terraform:
    
    ```
    terraform init
    ```
    
2. Validate the configuration:
    
    ```
    terraform validate
    ```
    
3. Apply the configuration:
    
    ```
    terraform apply
    ```
    
    Confirm the changes to provision the infrastructure.
    

---

resources created in the AWS as below:

![alt text](Images/Task_definition_ECS.png)

![alt text](Images/AWS-ECS-service-started.png)

![alt text](Images/AWS-loadbalancer-details.png)

### **Step 4: Access the Application**

1. Retrieve the DNS name of the Application Load Balancer from the Terraform output or AWS Management Console.
2. Access the application via the DNS name:
    
    ```
    http://<alb-dns-name>
    ```
    

---

Our application accessible on the web using load-balancer DNS:

![alt text](Images/AWS-deployment-finalpage.png)

3. Cleanup - To avoid incurring costs, delete all resources created:

    ```
    terraform destroy
    ```

---

### **Given More Time, I Would Improve...**

1. **Enhance Security**
    - **TLS Configuration**: I tried using self-signed certificates for TLS this time but still couldn’t achieve the TLS (HTTPS). As in a production environment, I would use AWS Certificate Manager (ACM) to issue and manage proper SSL certificates for secure HTTPS connections.
    - **IAM Role Optimization**: The IAM roles created have broad permissions for the deployment. With more time, I would provide least privilege by refining the IAM policies to grant only the minimum required permissions.
2. **Enhance Monitoring**
    - **Enhanced Monitoring**: While basic CloudWatch metrics are enabled, I would integrate a robust monitoring solution like AWS CloudWatch Logs Insights or a third-party tool such as Grafana or Prometheus to track application performance and container health in detail.
3. **Auto-Scaling Fine-Tuning**
    - The auto-scaling policy is based solely on CPU utilization (>70%). Given more time, I would incorporate additional metrics like memory usage, request count, and response times to create a more balanced and responsive scaling mechanism.
4. **Infrastructure as Code (IaC) Best Practices**
    - **Modularize Terraform Code**: I would refactor the terraform files into reusable modules (e.g., for ECS, ALB, and VPC) to improve maintainability and reusability.
    - **State Management**: A local backend was used for the Terraform state file. In a production setting, I would use a remote backend like an S3 bucket with DynamoDB state locking to enable collaboration and state management.
5. **Load Balancer Optimization**
    - Currently, the load balancer uses a simple HTTP listener. With more time and resources, I would have achieved the HTTPS and Domain routing
6. **Secrets Management**
    - The `SECRET_WORD` was passed directly as an environment variable. Ideally, I would use AWS Secrets Manager to securely store and retrieve sensitive data.
7. **Documentation**
    - I provided a basic README, but more comprehensive documentation would be added, including detailed setup instructions, architectural diagrams, and troubleshooting guides for easier handover and understanding.
8. **Cross-Cloud Deployment**
    - I focused on AWS for this deployment. With additional time, I would demonstrate the ability to deploy the application in multiple cloud providers (e.g., GCP, Azure) to showcase cross-cloud proficiency.
    - I tried the deployment in Azure using app service, service plan and load balancing but couldn’t complete it. see the proof below:

    ![alt text](Images/azure-docker-image-registry.png)

    ![alt text](Images/Azure-Deploy-Failure-AppService.png)

### 

By addressing these areas, the solution could evolve into a production-grade deployment with greater reliability, security, and maintainability.
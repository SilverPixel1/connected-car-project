🚗 Connected Car Cloud Platform
Event‑Driven AWS Microservices Architecture
📌 Overview
This project demonstrates the design and implementation of a scalable, event‑driven Connected‑Car cloud platform on AWS.
It simulates vehicle telemetry data, ingests it via a REST API, processes events asynchronously, and stores structured results in a NoSQL database.
The platform was built following cloud best practices, including Infrastructure as Code (IaC), containerization, microservices, and CI/CD automation.

🏗️ Architecture
High‑Level Architecture Diagram
📁 Docs/architecture.png
Docs/architecture.png

Architecture Flow (End‑to‑End)


Car Simulator
A Python‑based simulator generates realistic vehicle telemetry data:

car_id
latitude / longitude
temperature
slip / road condition indicators



Ingest API (FastAPI)

Exposed via an Application Load Balancer
Runs on ECS Fargate
Validates incoming requests
Publishes events to Amazon SQS



Message Queue (Amazon SQS)

Decouples ingestion from processing
Absorbs traffic spikes
Enables asynchronous event processing



Processor Service

ECS Fargate consumer service
Retrieves messages from SQS
Applies business logic (region mapping based on GPS)
Persists structured data into DynamoDB



Persistence (Amazon DynamoDB)

Partition Key: region
Sort Key: timestamp
Optimized for write‑intensive, time‑series workloads




☁️ AWS Services Used

VPC (Public & Private Subnets)
Application Load Balancer
ECS Fargate
Amazon ECR
Amazon SQS
Amazon DynamoDB
IAM (Task Roles, Least Privilege)
CloudWatch Logs


🔐 Security Design

Workloads isolated inside a dedicated VPC
Public access limited to the Ingest API via ALB
Processor runs exclusively in Private Subnets
IAM Task Roles used for AWS access (no hardcoded credentials)
Least‑Privilege principle enforced
Centralized logging via CloudWatch


🛠️ Infrastructure as Code (Terraform)
All cloud resources are provisioned using Terraform.
Key Terraform Modules

vpc.tf – networking and routing
alb.tf – application load balancer
ecs.tf – ECS cluster, services, and task definitions
iam.tf – execution & task roles
sqs.tf – message queue
dynamodb.tf – persistence layer
variables.tf, outputs.tf

✅ No manual configuration (No ClickOps)
✅ Reproducible infrastructure
✅ Environment‑agnostic design

🐳 Containerization
Each component is containerized using Docker:

ingest-api
processor
simulator

Images are built locally and via CI, then stored in Amazon ECR.

🔄 CI/CD Pipeline (GitHub Actions)
A fully automated CI/CD pipeline is implemented using GitHub Actions.
Pipeline Trigger

Push to main branch

CI/CD Workflow

Checkout repository
Configure AWS credentials
Authenticate to Amazon ECR
Build Docker images
Push images to ECR
Force rolling deployment on ECS services

✅ Zero‑downtime deployments
✅ Fully automated
✅ No manual image updates

📂 Project Structure
.
├── app/
│   ├── ingest-api/
│   ├── processor/
│   └── simulator/
│
├── terraform/
│   ├── vpc.tf
│   ├── ecs.tf
│   ├── iam.tf
│   ├── alb.tf
│   ├── sqs.tf
│   └── dynamodb.tf
│
├── .github/
│   └── workflows/
│       └── deploy.yml
│
├── Docs/
│   └── architecture.png
│
├── README.md
└── LICENSE

🧪 Testing & Observability

Health checks via ALB
Container logs available in CloudWatch
Message flow observable through SQS metrics
DynamoDB data validation via console or queries


🚧 Challenges & Lessons Learned
Terraform State Management

Loss of local state caused Terraform drift
Highlighted importance of remote backends (S3 + state locking)

IAM Complexity

Correct separation between Execution Role and Task Role
Debugging permission issues in ECS environments

Message‑Driven Debugging

Incorrect SQS Queue configuration led to silent failures
Emphasized the need for logging and validation

CI/CD & YAML Sensitivity

YAML formatting is highly error‑prone
Precise repository structure required for Actions


🔮 Future Improvements

Dead Letter Queue (DLQ) for failed messages
Auto Scaling based on SQS queue depth
CloudWatch dashboards and alarms
Structured JSON logging
Versioned Docker tags
Terraform remote state backend
Schema validation for incoming telemetry


📜 License
This project is licensed under the Apache License 2.0 – see the LICENSE file for details.

✅ Summary
This project demonstrates:

Real‑world cloud architecture patterns
Infrastructure automation with Terraform
Event‑driven microservices
Secure, scalable AWS deployments
Production‑style CI/CD workflows

It reflects practical experience with AWS Cloud Engineering and DevOps workflows.

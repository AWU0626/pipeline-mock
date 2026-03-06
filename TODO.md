# Homework 3 – High-Level Requirements

- [ ] 1. Terraform to deploy the structure (API Gateway + Lambda)  
   - [x] Files to create:  
     - `main.tf`  
     - `variables.tf`  
     - `outputs.tf`  
   - Use Terraform **modules**  
   - [x] Create a `diff` folder  

- [ ] 2. Add Lambda authorizer to `/verify` endpoint  

- [ ] 3. Request to `/verify` should bring a Bearer token (Authorization: Bearer \<JWT\>)  

- [ ] 4. Use EC2 to host Spring Security / Spring Boot  
   - Do authentication with Spring Security  
   - Generate JWT for the user  
   - Use DynamoDB to store user info  
   - Add an Application Load Balancer (ALB) in front of the EC2 instance  

- [x] 5. generate CSV sensor data and upload the CSV to S3  

- [x] 6. Create AWS Glue  
   - [x] Create a Glue **workflow**  
   - [x] `job1` → load CSV from S3  
   - [x] `job2` → clean up CSV file and save cleaned data to a new CSV in S3  

- [x] 7. Use AWS Step Functions to orchestrate AWS Glue + SageMaker training  
   - Step Function should start the Glue workflow  

- [x] 8. After AWS Glue workflow is finished, Step Function should trigger SageMaker training  
   - SageMaker reads the cleaned CSV from S3  
   - Train a model and generate model artifacts  

**Deadline:** March 8th

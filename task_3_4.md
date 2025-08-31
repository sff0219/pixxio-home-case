## Task 3

To deploy a binary on AWS EC2 instances in a GitLab-based environment, I would:

1. Build the binary in GitLab CI/CD and store it in an artifact repository (e.g., GitLab Package Registry or S3).

2. Use Terraform to provision EC2 instances with consistent configuration. Either launch EC2 instances directly or launch a Auto Scaling Group with a Launch Template.

3. Automate deployment with a tool like Ansible or user-data scripts to download the binary from the artifact registry and deploy it in EC2 instances.

## Task 4

### What's good

- Clear requirements: The tasks are well defined and test both modularity and infrastructure design skills.

- Realistic tasks: Splitting S3 and EC2 across regions is a realistic scenario and it requires to use multiple providers in Terraform. Tagging is also a best practice for consistent and maintainable infrastructure.

### Possible improvements

- Ambiguity in requirements: Task 1 requires a public instance IP as one of the outputs, while Task 2 requires sane security defaults for the VPC, which normally encourages private subnets. EC2 instances are usually placed in private subnets for production. This is a bit contradictory.

- Security defaults: This home case requires sane defaults for security and configuration, but it is difficult to balance between requirements and best practices. For example, for the EC2 instance, it has SSH restriction but it also opens SSH to anywhere (0.0.0.0/0), which is unsafe. With more detailed requirements, the trade-offs could be easier.

- Lack of documentation: No documentation is required in this home case. A documentation is beneficial to understand the repository and the project.

# Gremlin Zone Redundancy Test Setup on AWS

This guide walks through the setup required to deploy EC2 instances with the Gremlin agent and configure an Elastic Load Balancer (ALB) for running chaos experiments.

## Prerequisites

- A [Gremlin account](https://app.gremlin.com/signup)
- An AWS account with access to EC2
- A basic demo application (e.g., default Nginx installation)

---

## Step 1: Deploy EC2 Instances with the Gremlin Agent

1. **Download the Gremlin Agent Configuration:**
   - Log into the Gremlin web app.
   - Navigate to **Team Settings > Configuration tab**.
   - Download the `config.yaml` file (keep this file secure).

2. **Create a Launch Template:**
   - Open AWS EC2 console.
   - Go to **Launch Templates > Create launch template**.
   - Set a name (e.g., `gremlin-launch-template`).
   - Choose **Amazon Linux 2023 AMI** for x86.
   - Choose **t2.micro** as the instance type.
   - Optionally, select a key pair.
   - Under **Advanced Details > User data**, paste the following script (replace `YOUR CONFIG.YAML` with your actual YAML content):

     ```bash
     #!/bin/bash
     sudo yum install -y iproute-tc
     sudo curl https://rpm.gremlin.com/gremlin.repo -o /etc/yum.repos.d/gremlin.repo
     sudo yum install -y gremlin gremlind nginx
     cat > /etc/gremlin/config.yaml << EOF
     USE Given python server
     EOF
     sudo systemctl restart gremlind
     ```

   - Click **Create launch template**.

---

## Step 2: Deploy EC2 Instances and Create an Application Load Balancer

### Launch EC2 Instances

1. Go to **EC2 Dashboard > Launch instance from template**.
2. Select the launch template created above.
3. Choose a **subnet** in one Availability Zone (AZ) and launch the instance.
4. Repeat for a **different subnet in another AZ** to launch a second instance.

### Create a Target Group

1. Go to **EC2 > Target Groups > Create target group**.
2. Set target type to **Instances**.
3. Name it (e.g., `gremlin-nginx-group`).
4. Set protocol to **HTTP**, address type to **IPv4**.
5. Choose the VPC used by your instances.
6. Optionally adjust health check settings.
7. Click **Next**, select both instances, and click **Include as pending below**.
8. Click **Create target group**.

### Create an Application Load Balancer (ALB)

1. Go to **EC2 > Load Balancers > Create Load Balancer**.
2. Choose **Application Load Balancer**.
3. Name it (e.g., `gremlin-nginx-alb`).
4. Set scheme to **Internet-facing**, IP type to **IPv4**.
5. Under **Network Mapping**, select the same VPC and both AZs.
6. Assign the appropriate **security group(s)**.
7. Under **Listeners and routing**:
   - Set **Protocol** to HTTP (not HTTPS unless you configure TLS).
   - Set **Target group** to the one you created earlier.
8. Click **Create load balancer**.

---

## Verification

- Open the **DNS name** of the ALB in your browser.
- You should see the default **Nginx welcome page**.

---


---

## Next Steps

Once the setup is complete, proceed to configure and run chaos scenarios using the Gremlin UI. This setup ensures a highly available architecture with load balancing across multiple Availability Zones.


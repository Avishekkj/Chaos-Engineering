#  Chaos Testing Summary

This document outlines various types of **chaos attacks**, their meanings, when to use them, when not to, hypotheses for testing, and real-world use cases.

---

##  Resource Attacks

---

### 1. **Memory Attack**
- **What it Means**: Simulates high memory usage or memory leaks.
- **Where to Use**: 
  - App servers
  - Kubernetes pods with autoscaling
  - Services with proper failover mechanisms
- **Where NOT to Use**:
  - Production
  - Managed services (Kafka, RabbitMQ, RDS, DynamoDB)
  - Load balancers
  - Serverless functions (e.g., AWS Lambda)
- **Hypothesis**: The application should auto-recover, autoscale, or fail gracefully without user impact.
- **Use Cases**:
  - Test for cascading effects
  - Validate autoscaling
  - Detect memory leaks

---

### 2. **Disk Attack**
- **What it Means**: Fills up the disk to observe behavior under full storage conditions.
- **Where to Use**:
  - Web servers, App servers
  - Services writing logs
  - Kubernetes volumes
- **Where NOT to Use**:
  - Stateless services
  - Managed databases
- **Hypothesis**: System should either alert, auto-clear disk, or degrade gracefully.
- **Use Cases**:
  - Log rotation testing
  - Disk cleanup validation

---

### 3. **I/O Attack**
- **What it Means**: Simulates heavy disk or network read/write activity.
- **Where to Use**:
  - Webservers
  - Databases
  - Data pipelines, Analytics workloads
- **Where NOT to Use**:
  - Lightweight services not doing heavy I/O
- **Hypothesis**: System performance should degrade gracefully or recover.
- **Use Cases**:
  - Stress test for high-volume workloads
  - Simulate concurrent file operations

---

## 🌐 Network Attacks

---

### 4. **Blackhole Attack**
- **What it Means**: Drops traffic between services, simulating a broken communication channel.
- **Where to Use**:
  - Microservices with APIs
  - Third-party service integrations
  - API Gateways and Load Balancers
- **Where NOT to Use**:
  - Standalone systems
  - Serverless architecture
- **Hypothesis**: System should retry, use fallback logic, or alert.
- **Use Cases**:
  - Service-to-service failure simulation
  - 3rd-party unavailability testing

---

### 5. **Latency Attack**
- **What it Means**: Adds artificial delay in communication between services.
- **Where to Use**:
  - Real-time applications
  - Performance-sensitive APIs
- **Where NOT to Use**:
  - Batch processing systems
- **Hypothesis**: SLAs are still met or appropriate fallback occurs.
- **Use Cases**:
  - Test timeout strategies
  - Circuit breaker validation

---

### 6. **Packet Loss Attack**
- **What it Means**: Simulates bad network conditions by randomly dropping packets.
- **Where to Use**:
  - Real-time systems (e.g., WebRTC, VoIP)
  - Streaming services
- **Where NOT to Use**:
  - Batch processing
  - Static content delivery
- **Hypothesis**: Application should retry or degrade gracefully.
- **Use Cases**:
  - Mobile or unstable network simulation

---

### 7. **DNS Attack**
- **What it Means**: Simulates DNS resolution failure.
- **Where to Use**:
  - Apps relying on DNS-based service discovery
  - Microservices communicating via domain names
- **Where NOT to Use**:
  - Services using static IPs
- **Hypothesis**: DNS failover, caching, or retry logic should kick in.
- **Use Cases**:
  - Test DNS caching and fallback
  - Validate service discovery mechanisms

---

## 🔄 State Attacks

---

### 8. **Shutdown Attack**
- **What it Means**: Shuts down a pod or instance unexpectedly.
- **Where to Use**:
  - HA systems with failover
  - Kubernetes clusters
- **Where NOT to Use**:
  - Single-node apps or SPoF (Single Point of Failure)
- **Hypothesis**: Traffic should reroute, or systems should auto-recover.
- **Use Cases**:
  - High availability validation
  - Auto-healing and restart tests

---

### 9. **Process Killer Attack**
- **What it Means**: Terminates specific system processes (e.g., database, web server).
- **Where to Use**:
  - Services with process supervision or health checks
- **Where NOT to Use**:
  - Stateless containers with no restart policies
- **Hypothesis**: Supervisors or orchestrators restart the process.
- **Use Cases**:
  - Process monitoring checks
  - Failover script testing

---

### 10. **Time Travel Attack**
- **What it Means**: Changes system clock time to simulate issues like cert expiry or daylight savings.
- **Where to Use**:
  - Apps using scheduled jobs or certificates
- **Where NOT to Use**:
  - Time-independent stateless apps
- **Hypothesis**: Application handles expired certificates or time shifts without crashing.
- **Use Cases**:
  - SSL cert expiry handling
  - Cron job scheduling under time changes

---

## 📌 Notes

- Avoid running resource or state attacks on managed services unless explicitly supported.
- Chaos experiments should always be run in **staging or lower environments**, if required in production.
- Add monitoring and alerting to observe and measure impact.


---



# 📛 Chaos Engineering: Kubernetes Database Resiliency Experiments

Welcome to the chaos experiment suite designed to test the resilience of the **Sock Shop** microservices demo, specifically focusing on the **MongoDB (catalogue-db)** service in a Kubernetes environment.

This folder contains experiments targeting the database components to validate system behavior under failure scenarios, improve robustness, and enforce graceful degradation.

---

## 🔬 Experiment 1: Catalogue DB Pod Failure

### ✅ Objective

Simulate an abrupt shutdown of the `catalogue-db` pod and observe how the application responds, recovers, and maintains availability.

---

### 🧪 Hypothesis

> If the `catalogue-db` pod is abruptly terminated, Kubernetes will automatically restart it, and the Sock Shop application will recover without manual intervention or data loss.

---

### 🧾 Experiment Details

#### ✅ Given

- The Sock Shop application is deployed and fully functional.
- The MongoDB `catalogue-db` pod is running in the `sock-shop` namespace.
- All services dependent on the `catalogue-db` are reachable.
- Observability tools like Prometheus and Grafana are configured.
- Alerts or logs are being collected for system behavior tracking.

#### ⚙️ Configuration

| Parameter        | Value                          |
|------------------|-------------------------------|
| Target           | `catalogue-db` Deployment (MongoDB) |
| Namespace        | `sock-shop`                   |
| Type             | Infrastructure Attack (Shutdown) |
| Tool             | [Gremlin](https://www.gremlin.com/) |
| Duration         | Immediate (1s delay)          |
| Scope            | 100% of selected targets      |

---

### 🚀 Execution via Gremlin API

The following sanitized API was used to execute the experiment:

```http
POST /v1/attacks
Host: api.gremlin.com
Content-Type: application/json
Authorization: Bearer <REDACTED>

{
  "attackConfiguration": {
    "command": {
      "infraCommandType": "shutdown",
      "infraCommandArgs": {
        "type": "shutdown",
        "delay": 1,
        "cliArgs": ["shutdown", "-d", "1"]
      }
    },
    "targets": [
      {
        "targetingStrategy": {
          "type": "Kubernetes",
          "isAll": false,
          "containerSelection": {
            "selectionType": "ALL",
            "containerNames": []
          },
          "names": [
            {
              "clusterId": "<CLUSTER_ID>",
              "kind": "DEPLOYMENT",
              "namespace": "sock-shop",
              "name": "catalogue-db"
            }
          ]
        }
      }
    ],
    "sampling": {
      "type": "Even",
      "percent": 100
    }
  },
  "includeNewTargets": true
}


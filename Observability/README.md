

# Create a namespace for monitoring
minikube kubectl -- create namespace monitoring

# Add Prometheus Helm repository and update
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/prometheus -n monitoring

# Expose Prometheus server using NodePort
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext -n monitoring

# Get the Prometheus URL to access in the browser
minikube service prometheus-server-ext -n monitoring


# Add Grafana Helm repository and update
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Grafana
helm install grafana grafana/grafana -n monitoring

# Expose Grafana service using NodePort
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext -n monitoring

# Get the Grafana URL to access in the browser
minikube service grafana-ext -n monitoring

# Continuously check the status of all pods every 5 seconds
while (1) {minikube kubectl -- get pods -A; sleep 5}


Access Grafana
Username: admin
Password: (as retrieved in Step 4)





![Prometheus Architecture](../Statics/image/prometheus-architecture.gif)

![Prometheus](../Statics/diagrams/Prometheus.png)

# Chaos Resilience Testing with Python HTTP Server behind AWS ALB

This project demonstrates how to simulate real-world server failure and recovery scenarios using:
- A simple Python HTTP server running on EC2 instances
- AWS Application Load Balancer (ALB)
- Health checks
- CloudWatch alarms
- Locust for load testing
- Simulated server delays and failure detection

---

## 🔧 Application Setup – Python HTTP Server with Delay

This minimal server responds with its hostname and IP address after a 2-second delay to simulate slow processing.

### 1. Install Python

```bash
sudo yum install python3 -y

mkdir -p ~/myserver
cd ~/myserver
nano server.py


from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import socket

class SimpleHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        time.sleep(2)  # Delay response by 2 seconds
        hostname = socket.gethostname()
        local_ip = socket.gethostbyname(hostname)
        content = f"""
        <html><body>
        <h1>Served by: {hostname}</h1>
        <p>IP Address: {local_ip}</p>
        </body></html>
        """
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(content.encode('utf-8'))

if __name__ == "__main__":
    server_address = ('', 80)
    httpd = HTTPServer(server_address, SimpleHandler)
    print(f"Starting server on port 80...")
    httpd.serve_forever()


sudo python3 server.py
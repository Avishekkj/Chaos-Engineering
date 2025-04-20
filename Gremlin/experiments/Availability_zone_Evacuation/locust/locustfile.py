from locust import HttpUser, task, between

class MyUser(HttpUser):
    wait_time = between(2, 5)  # Simulated think time

    @task
    def hello_world(self):
        self.client.get("/")

##  To run execute locust -f locustfile.py --host=http://<alb-dns>

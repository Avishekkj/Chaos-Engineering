from locust import HttpUser, task, between

class TodoAppUser(HttpUser):
    wait_time = between(1, 5)  # wait between 1 and 2 seconds between tasks

    @task
    def add_task(self):
        # Define the task payload (the task description)
        task_data = {
            "description": "Task from test"
        }
        
        # Perform a POST request to add a new task
        response = self.client.post("/tasks", json=task_data)
        
        # Print the response status and text for debugging purposes
        print(f"POST /tasks Status: {response.status_code}, Response: {response.text}")


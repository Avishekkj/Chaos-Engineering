#!/bin/bash
# Blackhole attack to simulate network failure to api.gremlin.com or DB

curl -X POST "https://api.gremlin.com/v1/attacks/new?teamId=" \
-H "Content-Type: application/json" \
-H "Authorization: Key" \
-d '{
  "target": {
    "type": "Exact",
    "hosts": {
      "ids": ["YOUR_HOST_ID"]
    }
  },
  "command": {
    "type": "blackhole",
    "commandType": "blackhole",
    "args": ["--length", "120", "-h", "^mariadb", "-p", "3306"]
  }
}'


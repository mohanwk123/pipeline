Demo CI/CD Pipeline with HelloWorld Flask App
This project demonstrates a simple CI/CD pipeline setup using GitHub Actions. The pipeline deploys a basic Flask web application with a PostgreSQL database and Nginx as a reverse proxy, all running inside Docker containers. The deployment is automated to AWS EC2.

Project Overview
Flask Application serves a simple "Hello World" page.
PostgreSQL Database is used as a backend, configured via Docker.
Nginx acts as a reverse proxy to route traffic to the Flask application.
CI/CD Pipeline is set up using GitHub Actions to automate security scanning and deployment to AWS EC2.
Files and Setup
1. app.py
This is the main Python script for the Flask app.

python
Copy
Edit
from flask import Flask
import psycopg2

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, World! Deployed via CI/CD Pipeline! This is Change D"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
Comments:

The Flask app runs on port 5000 and displays a "Hello World" message when accessed via a browser.
The PostgreSQL connection logic is imported but not currently utilized. You can expand this if you plan to integrate the DB in the future.
2. docker-compose.yml
This file defines the Docker services for the Flask app, PostgreSQL database, and Nginx reverse proxy.

yaml
Copy
Edit
version: "3.8"

services:
  web:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db

  db:
    image: postgres:13
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: password
      POSTGRES_DB: helloworld
    ports:
      - "5432:5432"
    volumes:
      - pg_data:/var/lib/postgresql/data

  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - web

volumes:
  pg_data:
Comments:

web: Flask app container, exposed on port 5000.
db: PostgreSQL database container with environment variables for the database user, password, and name.
nginx: Nginx reverse proxy to route requests from port 80 to the Flask app.
pg_data: Volume for persisting database data.
3. Dockerfile
This file defines how to build the Flask app container.

dockerfile
Copy
Edit
# Use official Python image as base
FROM python:3.9

# Set working directory
WORKDIR /app

# Copy files
COPY requirements.txt requirements.txt
COPY app.py app.py

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 5000

# Run application
CMD ["python", "app.py"]
Comments:

FROM python:3.9: Using Python 3.9 as the base image.
COPY: Copies the requirements.txt and app.py files into the container.
RUN: Installs the dependencies listed in requirements.txt.
EXPOSE: Exposes port 5000 for Flask.
CMD: Starts the Flask app when the container runs.
4. nginx.conf
Nginx configuration file for the reverse proxy.

nginx
Copy
Edit
events {}

http {
    server {
        listen 80;
        server_name democicd.duckdns.org;

        location / {
            proxy_pass http://web:5000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
}
Comments:

Configures Nginx to forward requests to the Flask app (web service) on port 5000.
Includes headers to ensure correct routing and client information is passed to the Flask app.
5. requirements.txt
This file contains the Python dependencies for the Flask app.

txt
Copy
Edit
flask
psycopg2
Comments:

flask: The Flask web framework.
psycopg2: PostgreSQL adapter for Python, which can be used to interact with the database.
6. .github/workflows/deploy.yml
This file defines the CI/CD pipeline using GitHub Actions.

yaml
Copy
Edit
name: Deploy to AWS EC2

on:
  push:
    branches:
      - main

permissions:
  contents: read
  security-events: write  # Required for CodeQL to upload results
  pull-requests: write
  repository-projects: write
  actions: read
  checks: write

jobs:
  security_scan:
    name: Security Scan
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      # Run CodeQL Analysis with v3
      - name: Initialize CodeQL
        uses: github/codeql-action/init@v3
        with:
          languages: python

      - name: Perform CodeQL Analysis
        uses: github/codeql-action/analyze@v3

  deploy:
    name: Deploy to EC2
    runs-on: ubuntu-latest
    needs: security_scan  # Ensure security scan passes before deployment
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up SSH Key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.EC2_SSH_PRIVATE_KEY }}" | base64 --decode > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H ${{ secrets.EC2_PUBLIC_IP }} >> ~/.ssh/known_hosts

      - name: Deploy application
        run: |
          ssh ubuntu@${{ secrets.EC2_PUBLIC_IP }} << 'EOF'
            cd ~/pipeline
            git pull origin main
            docker-compose down
            docker-compose up --build -d
          EOF
Comments:

security_scan: Runs a security scan using CodeQL to ensure that no security vulnerabilities exist in the code.
deploy: Deploys the application to an AWS EC2 instance:
Sets up the SSH private key.
Pulls the latest code from GitHub.
Stops any running containers (docker-compose down) and rebuilds the containers (docker-compose up --build -d).
Secrets
You need to store the following secrets in your GitHub repository to deploy correctly:

EC2_SSH_PRIVATE_KEY: The private SSH key for accessing your EC2 instance.
EC2_PUBLIC_IP: The public IP address of your EC2 instance.
How to Run Locally
Clone the repository:

bash
Copy
Edit
git clone <your-repository-url>
cd <repository-folder>
Build and start the containers using Docker Compose:

bash
Copy
Edit
docker-compose up --build
Access the Flask app via http://localhost:80.

How to Deploy to AWS EC2
Push your changes to the main branch on GitHub.
GitHub Actions will automatically trigger the pipeline to run the security scan and then deploy the app to your EC2 instance.

License
This project is licensed under the MIT License - see the LICENSE file for details.


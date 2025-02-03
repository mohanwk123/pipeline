# Demo CI/CD Pipeline with HelloWorld Flask App

This project demonstrates a simple CI/CD pipeline setup using GitHub Actions. The pipeline deploys a basic **Flask** web application with a PostgreSQL database and **Nginx** as a reverse proxy, all running inside Docker containers. The deployment is automated to **AWS EC2**. 

## Project Overview

- **Flask Application** serves a simple "Hello World" page.
- **PostgreSQL Database** is used as a backend, configured via Docker.
- **Nginx** acts as a reverse proxy to route traffic to the Flask application.
- **CI/CD Pipeline** is set up using GitHub Actions to automate security scanning and deployment to AWS EC2.

## How It Works

The project follows a typical microservices architecture with Docker containers for each component:

1. **Flask App**: This is the web application that responds with a "Hello World" message.
2. **PostgreSQL Database**: A PostgreSQL database is used as the backend for the application.
3. **Nginx**: This is configured as a reverse proxy to handle incoming HTTP requests and forward them to the Flask app.
4. **CI/CD Pipeline**: GitHub Actions automates testing, security scanning (CodeQL), and deployment to an AWS EC2 instance.

## Secrets

You need to store the following secrets in your GitHub repository to deploy correctly:

- **EC2_SSH_PRIVATE_KEY**: The private SSH key for accessing your EC2 instance.
- **EC2_PUBLIC_IP**: The public IP address of your EC2 instance.

## How to Run Locally

1. Clone the repository:
    ```bash
    git clone <your-repository-url>
    cd <repository-folder>
    ```

2. Build and start the containers using Docker Compose:
    ```bash
    docker-compose up --build
    ```

3. Access the Flask app via `http://localhost:80`.

## How to Deploy to AWS EC2

1. Push your changes to the **main** branch on GitHub.
2. GitHub Actions will automatically trigger the pipeline to run the security scan and then deploy the app to your EC2 instance.

## Files Structure

- **app.py**: The Flask web application that displays a simple "Hello World" message.
- **docker-compose.yml**: Docker Compose configuration that sets up the Flask app, PostgreSQL database, and Nginx reverse proxy.
- **Dockerfile**: The Dockerfile for building the Flask app container.
- **nginx.conf**: Nginx configuration file to set up reverse proxy.
- **requirements.txt**: The Python dependencies for the Flask app.
- **.github/workflows/deploy.yml**: GitHub Actions workflow that automates security scanning and deployment to AWS EC2.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

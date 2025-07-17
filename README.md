## Test Docker CI/CD

#### Step 1: Create a basic WebApp

This is a simple HTML5 page that displays the text **"Hello, World!"** in a web browser.

```[HTML]
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World!</title>
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background: linear-gradient(120deg, #ffecd2 0%, #fcb69f 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .hello-container {
            background: rgba(255,255,255,0.95);
            padding: 60px 80px;
            border-radius: 24px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.12);
            text-align: center;
        }
        .hello-title {
            font-family: 'Pacifico', cursive;
            font-size: 3.5rem;
            color: #ff6f61;
            margin-bottom: 20px;
            letter-spacing: 2px;
        }
        .hello-subtitle {
            font-family: 'Montserrat', sans-serif;
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 10px;
        }
        .wave {
            display: inline-block;
            animation: wave 1.5s infinite linear;
            transform-origin: 70% 70%;
        }
        @keyframes wave {
            0%, 60%, 100% { transform: rotate(0deg); }
            10% { transform: rotate(14deg); }
            20% { transform: rotate(-8deg); }
            30% { transform: rotate(14deg); }
            40% { transform: rotate(-4deg); }
            50% { transform: rotate(10deg); }
        }
    </style>
</head>
<body>
    <div class="hello-container">
        <div class="hello-title"><span class="wave">👋</span> Hello World. Welcome Kiran</div>
        <div class="hello-subtitle">Welcome to your fancy HTML page. </div>
    </div>
</body>
</html>

```
#### Step 2: Create DockerFile

In this step, we'll containerize a static HTML page using Docker and run it on a Windows IIS web server. We'll use the official IIS base image for Windows Server 2022, copy our HTML content into the web root directory, and expose the necessary port to access the site.

```
# Use the official IIS image based on Windows Server 2022
FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

# Copy the static website files to the IIS web root directory
COPY index.html C:/inetpub/wwwroot/index.html

# Expose port 80 from the container
EXPOSE 80
```
Note: Port 80 refers to the port inside the container. If you want to access the container from a different port on your host machine, you’ll need to map the ports when running the container.

Running the Container
To run the container and bind a different host port (e.g., 8081) to the container's port 80, use the following command:

```
docker run -d -p 8081:80 --name hello-container my-iis-hello
```

Here:

- **8081** is the host machine's port.

- **80** is the container's internal port (exposed by IIS).

- This means requests to http://localhost:8081 on your machine will be forwarded to port **80** inside the container, where IIS is serving the web content.

#### Step 3: Create ```.github/workflows``` Folder and ```docker-hub.yaml``` File
The ```.github/workflows``` directory in a repository contains YAML files that define GitHub Actions workflows. These workflows automate tasks such as building, testing, and deploying your project.

Each YAML file describes a set of instructions that GitHub executes on a virtual environment (e.g., Linux, Windows, or macOS), depending on your configuration.

These instructions can include:
- Build commands: Compile or prepare your project (e.g., building a Docker image, compiling code, bundling assets).
- Docker operations: Push a Docker image to Docker Hub or another registry.
- Deployment commands: Use SSH to connect to a remote VPS or web server and pull the latest code, restart services, or trigger deployment scripts.

Example Use Cases:
- Automate CI/CD pipelines.
- Automatically push Docker images after a successful build.
- Deploy updated code to a web server every time new commits are pushed to the main branch.

```.github/docker-hub.yaml``` for pushing latest changes in containers to docker hub.
```
name: CI/CD for Windows IIS Container

on:
  push:
    branches: [ main ]

jobs:
  build-and-push:
    runs-on: windows-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Docker Login
        run: |
          echo $Env:DOCKER_PASSWORD | docker login -u $Env:DOCKER_USERNAME --password-stdin
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
          DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build Docker Image with version tag
        run: |
          docker build -t $Env:DOCKER_USERNAME/welcome_page:${{ github.run_number }} .
          docker tag $Env:DOCKER_USERNAME/welcome_page:${{ github.run_number }} $Env:DOCKER_USERNAME/welcome_page:latest
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}

      - name: Push Docker Images
        run: |
          docker push $Env:DOCKER_USERNAME/welcome_page:${{ github.run_number }}
          docker push $Env:DOCKER_USERNAME/welcome_page:latest
        env:
          DOCKER_USERNAME: ${{ secrets.DOCKER_USERNAME }}
```

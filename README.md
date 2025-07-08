# Welcome Page Docker Project

This project provides a simple static welcome page hosted on IIS using a Windows Server 2022 Docker container.

## Features

- Serves a custom `index.html` using IIS
- Runs on Windows Server Core 2022 base image
- Easy to build and deploy with Docker

## Prerequisites

- Docker installed and running in Windows containers mode
- Windows Server 2022 or compatible host

## Usage

### 1. Build the Docker Image

```powershell
docker build -t welcome_page .
```

### 2. Run the Docker Container

```powershell
docker run -d -p 80:80 --name welcome_page welcome_page
```

### 3. Access the Welcome Page

Open your browser and go to:  
[http://localhost](http://localhost)

## Files

- `Dockerfile` – Docker build instructions
- `index.html` – The static welcome page

## Customization

Edit `index.html` to change the welcome message or page content.

## License

This project is for demonstration and educational purposes.
# Use the official IIS image for Windows Server 2022
FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

# (Optional) Install IIS Web-Server feature (already present in this image)
# RUN powershell -Command "Install-WindowsFeature -Name Web-Server"

# Copy the static website files to the IIS web root
COPY index.html C:/inetpub/wwwroot/index.html

# Expose port 80
EXPOSE 80

# Start IIS (default entrypoint runs IIS)
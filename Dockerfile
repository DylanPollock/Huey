# Use Debian Trixie slim as the base image for a lightweight container
FROM debian:trixie-slim

# Define maintainer or author of the Dockerfile
LABEL maintainer="admin@gencore.com"

# Set environment variables to minimize issues and configure Python not to create .pyc files
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Update the package repository and install necessary packages
# Using 'apt-get install -y --no-install-recommends' to keep the installation small
# Adding '&& apt-get clean' to remove unnecessary files and free space
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    mate-desktop-environment-core \
    tightvncserver \
    # Uncomment the following lines if additional packages are needed
    # curl \
    # vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up the working directory inside the container
WORKDIR /gencore-workdir

# Copy the project's requirements file first to leverage Docker cache
COPY requirements.txt ./

# Install Python dependencies from the requirements file
# RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of the project files into the container
COPY . .

# Non-root User:
# Correcting user creation and usage
RUN useradd -m dlrp && chown -R dlrp:dlrp /gencore-workdir
USER dlrp

# Set up VNC server
RUN mkdir /root/.vnc
RUN echo "dlrp" | vncpasswd -f > /root/.vnc/passwd
RUN chmod 600 /root/.vnc/passwd

# Set up VNC session startup script
RUN echo "#!/bin/bash\nxrdb $HOME/.Xresources\nstartmate &" > /root/.vnc/xstartup
RUN chmod +x /root/.vnc/xstartup

# Expose the necessary port(s)
EXPOSE 5901

# Define the command to run when the container starts
CMD ["vncserver", "-geometry", "1280x800", "-depth", "24", "-localhost", "no", ":1"]
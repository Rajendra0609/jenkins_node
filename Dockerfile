# Use the official Jenkins agent base image
FROM jenkins/inbound-agent:latest

LABEL maintainer="rajendra.daggubati1997@gmail.com" \
      version="2.492.3" \
      description="Jenkins with Docker support" \
      org.opencontainers.image.source="https://github.com/Chowdary1997/Jenkins_jenkins_nodes_Dockerfle.git" \
      org.opencontainers.image.licenses="MIT"

# Install Docker CLI
USER root

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    maven \
    gnupg2 \
    lynis \
    colorized-logs \
    fontconfig openjdk-17-jre \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /var/jenkins_home/node

RUN curl -sO http://192.168.1.11:8080/jnlpJars/agent.jar

# Set the entrypoint to run the Jenkins agent with the specified parameters
ENTRYPOINT ["java", "-jar", "agent.jar", "-url", "http://192.168.1.11:8080/", "-secret", "02ea09f80880903a7e4f441fe8adf89b38006802196881715f02dfdfa2fa3a24", "-name", "docker", "-webSocket", "-workDir", "/var/jenkins_home/node"]

FROM ubuntu:20.04
 
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && useradd -m agentuser
 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \ 
    nodejs \
    npm
 
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

WORKDIR /azp 

RUN npm init -y
RUN npm install ronin-server ronin-mocks

#Set ENV veriable
ENV NODE_ENV=production
ENV NODE_TLS_REJECT_UNAUTHORIZED=0

# Copy the necessy packages
COPY ["package.json", "package-lock.json*","server.js", "./"]

RUN npm config set strict-ssl false
#Run the npm commands 
RUN npm install 
# Copy everything in current /app directory 
COPY . .

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ENV TARGETARCH=linux-x64
 

RUN chown -R agentuser:agentuser /azp
RUN chmod 755 /azp
 
COPY ./start.sh .
RUN chmod +x start.sh
# All subsequent commands run under this user
USER agentuser
 
ENTRYPOINT [ "./start.sh", "--once" ]
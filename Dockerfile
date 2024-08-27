# Use the official Ubuntu base image
#FROM debian:stable-slim
FROM alpine

# Set environment variables to non-interactive
#ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
#RUN apt-get update && apt-get install -y sudo curl && \
#    curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash - && \
#    apt-get install -y nodejs
RUN apk add --update nodejs npm && apk add --no-cache bash
# Install Google Chrome
#RUN sudo apt install curl gnupg -y && \
#    curl --location --silent https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
#    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
#    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
#    sudo apt update && sudo apt install -y google-chrome-stable --no-install-recommends && \
#    sudo rm -rf /var/lib/apt/lists/*

# Install Firefox
#RUN sudo apt install libgl1-mesa-dri libgbm1 -y
#RUN sudo sh -c 'echo "deb http://deb.debian.org/debian/ unstable main contrib non-free" >> /etc/apt/sources.list.d/debian.list'
#RUN sudo apt update && sudo apt install -y firefox --no-install-recommends

# Install Chromium
#RUN sudo apt update && sudo apt install chromium -y
RUN apk add --no-cache  chromium --repository=https://dl-cdn.alpinelinux.org/alpine/latest-stable/main

WORKDIR /app
#COPY package*.json scrapeAmazon.js script.sh updateHA.js ./
#COPY . .
COPY rootfs /

# Install necessary npm packages
RUN npm install puppeteer otpauth dotenv puppeteer-extra puppeteer-extra-plugin-stealth
RUN chmod a+x /app/script.sh

# Start script
CMD ["/app/script.sh"]

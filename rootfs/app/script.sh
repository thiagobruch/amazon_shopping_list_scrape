#!/bin/bash

# Define the commands to run
# interval=$pooling_interval
echo $pooling_interval
if [ "$debug_log" == "true" ]; then
        apk add mini_httpd
        mkdir /app/www
        echo port=8888  >> /etc/mini_httpd/mini_httpd.conf
        echo user=minihttpd   >> /etc/mini_httpd/mini_httpd.conf
        echo dir=/app/www  >> /etc/mini_httpd/mini_httpd.conf
        echo nochroot  >> /etc/mini_httpd/mini_httpd.conf
        apk add openrc  --no-cache
        mkdir -p /run/openrc/exclusive
        touch /run/openrc/softlevel
        rc-service mini_httpd start
fi
COMMANDS=(
    "cd /app/"
    "rm -rf tmp/"
    "/usr/bin/node /app/scrapeAmazon.js"
    "/usr/bin/node /app/updateHA.js"
)

# Infinite loop
while true; do
  # Run each command
  for cmd in "${COMMANDS[@]}"; do
    $cmd
  done

  # Sleep for 3 minutes
  sleep $pooling_interval
done

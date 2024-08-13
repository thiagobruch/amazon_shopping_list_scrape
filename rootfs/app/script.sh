#!/bin/bash
# Define the commands to run
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
  sleep 180
done

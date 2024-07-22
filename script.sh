#!/bin/bash
# Define the commands to run
COMMANDS=(
    "cd /usr/src/app/"
    "/usr/bin/node /usr/src/app/scrapeAmazon.js"
    "/usr/bin/node /usr/src/app/updateHA.js"
    "/usr/bin/date"
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

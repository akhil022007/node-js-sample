#!/bin/bash

HOST_IP=$(ip route | awk '/default/ { print $3 }')

APP_URL="http://${HOST_IP}:80"
MAX_RETRIES=15
RETRY_DELAY=5

echo "--- Starting Application Test Script ---"
echo "Attempting to connect to $APP_URL"

for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $i/$MAX_RETRIES: Checking application status..."
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")

    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "Application is up and running! (Status: $STATUS_CODE)"
        exit 0
    else
        echo "Application not yet ready. Status: $STATUS_CODE. Retrying in $RETRY_DELAY seconds..."
        sleep "$RETRY_DELAY"
    fi
done

echo "ERROR: Application did not become ready after $MAX_RETRIES attempts. Test failed!"
exit 1

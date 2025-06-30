#!/bin/bash

HOST_IP=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | head -n 1)

APP_URL="http://${HOST_IP}:80"
MAX_RETRIES=15
RETRY_DELAY=5

echo "--- Starting Application Test Script ---"
echo "Attempting to connect to $APP_URL"

for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $i/$MAX_RETRIES: Checking application status..."
    
    CURL_OUTPUT=$(curl -s -L -k -v -o /dev/null -w "%{http_code}" "$APP_URL" 2>&1)
    STATUS_CODE=$(echo "$CURL_OUTPUT" | tail -n 1)

    if [ "$STATUS_CODE" -eq 200 ]; then
        echo "Application is up and running! (Status: $STATUS_CODE)"
        exit 0
    else
        echo "Application not yet ready. Status: $STATUS_CODE. Retrying in $RETRY_DELAY seconds..."
        echo "--- Curl Verbose Output (Attempt $i) ---"
        echo "$CURL_OUTPUT" | head -n -1
        echo "--- End Curl Verbose Output ---"
        sleep "$RETRY_DELAY"
    fi
done

echo "ERROR: Application did not become ready after $MAX_RETRIES attempts. Test failed!"
exit 1

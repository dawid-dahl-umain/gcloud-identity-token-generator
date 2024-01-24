#!/bin/bash

# Source the .env.gcloud file
set -a
source .env.gcloud
set +a

# Initialize a flag to indicate success
script_success=false

# Function for cleanup only
cleanup() {
    echo "An error occurred. Cleaning up without token generation." >&2
    rm -f "$TEMP_SA_FILE"
}

# Function for cleanup and returning the token
cleanup_and_return_token() {
    rm -f "$TEMP_SA_FILE"
    echo "$token"
}

# Trap to execute cleanup function on script exit
trap cleanup EXIT

# Check if the SERVICE_ACCOUNT_JSON environment variable is set and not empty
if [ -z "$SERVICE_ACCOUNT_JSON" ]; then
    echo "Error: The environment variable 'SERVICE_ACCOUNT_JSON' is undefined or empty." >&2
    exit 1
fi

# Check if the GCLOUD_IDENTITY_TOKEN_AUDIENCE environment variable is set and not empty
if [ -z "$GCLOUD_IDENTITY_TOKEN_AUDIENCE" ]; then
    echo "Error: The environment variable 'GCLOUD_IDENTITY_TOKEN_AUDIENCE' is undefined or empty." >&2
    exit 1
fi

# Create a temporary file to hold the service account JSON
TEMP_SA_FILE=$(mktemp)
echo "${SERVICE_ACCOUNT_JSON}" > "${TEMP_SA_FILE}"

# Activate the service account
gcloud auth activate-service-account --key-file="$TEMP_SA_FILE"

# Try to capture the token
token=$(gcloud auth print-identity-token --audiences="$GCLOUD_IDENTITY_TOKEN_AUDIENCE" 2> /dev/null)

# Check if token capture was successful
if [ -n "$token" ]; then
    script_success=true
    trap cleanup_and_return_token EXIT
else
    echo "Failed to generate token." >&2
    exit 1
fi
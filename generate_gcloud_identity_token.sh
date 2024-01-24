#!/bin/bash

# Load environment variables from .env.gcloud file
set -a
[ -r ".env.gcloud" ] && source .env.gcloud || { echo ".env.gcloud file not found" >&2; exit 1; }
set +a

# Initialize a flag to indicate script success
script_success=false

# Function to clean up resources on error
cleanup() {
    echo "An error occurred. Cleaning up without token generation." >&2
    rm -f "$TEMP_SA_FILE"
}

# Function to clean up and return the token on success
cleanup_and_return_token() {
    rm -f "$TEMP_SA_FILE"
    echo "$token"
}

# Default trap for cleanup
trap cleanup EXIT

# Check and validate necessary environment variables
if [ -z "$SERVICE_ACCOUNT_JSON" ]; then
    echo "Error: SERVICE_ACCOUNT_JSON is undefined or empty." >&2
    exit 1
fi

if [ -z "$GCLOUD_IDENTITY_TOKEN_AUDIENCE" ]; then
    echo "Error: GCLOUD_IDENTITY_TOKEN_AUDIENCE is undefined or empty." >&2
    exit 1
fi

# Create a temporary file for the service account JSON
TEMP_SA_FILE=$(mktemp)
echo "${SERVICE_ACCOUNT_JSON}" > "${TEMP_SA_FILE}"

# Activate the service account
gcloud auth activate-service-account --key-file="$TEMP_SA_FILE"

# Capture the token and check for success
token=$(gcloud auth print-identity-token --audiences="$GCLOUD_IDENTITY_TOKEN_AUDIENCE" 2> /dev/null)
if [ -n "$token" ]; then
    script_success=true
    trap cleanup_and_return_token EXIT
else
    echo "Failed to generate token." >&2
    exit 1
fi
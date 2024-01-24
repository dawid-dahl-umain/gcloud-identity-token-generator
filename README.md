# Google Cloud Token Generator

## Description

This application is a local Node.js server designed to generate Google Cloud identity tokens using a bash script. It's an efficient solution for developers working with Google Cloud services who need to frequently generate new identity tokens, especially useful for services like Postman.

## Getting Started

### Dependencies

- Node.js and npm (Node Package Manager)
- Google Cloud SDK (gcloud command-line tool)
- Bash (for running the shell script)

### Installing

1. **Clone the Repository**

   ```sh
   git clone [repository-url]
   cd gcloud-token-generator
   ```

2. **Install Node Modules**
   ```sh
   npm install
   ```

## Security Considerations

### Local Use Only

- This application is intended strictly for **local use**. It is crucial that you do not deploy or expose this application to external networks or the internet. Exposing it could lead to severe security vulnerabilities, especially since it involves sensitive credentials.

### .env.gcloud File Security:

- Ensure that `.env.gcloud` is included in your `.gitignore` file to avoid accidentally committing sensitive data.
- Never expose the contents of the `.env.gcloud` file publicly. This file contains the service account JSON key, which is highly sensitive and must be kept confidential at all times.

By adhering to these security practices, you help safeguard your sensitive credentials and reduce the risk of unauthorized access to your Google Cloud resources.

---

### Generating Identity Tokens

The script `generate_gcloud_identity_token.sh` simplifies the process of generating a Google Cloud identity token.

#### Prerequisites

- Google Cloud SDK installed on your machine.
- Service account key with minimal permissions (e.g., `Cloud Run Invoker`).
- Service account key in JSON format, to be used in `.env.gcloud`. For the project `poc-erp-adapter`, the key is stored in it's Google Cloud Secret Manager.

#### Setting up the Environment

1. **Create a `.env.gcloud` File:**
   - Copy `.env.gcloud.example` to create a `.env.gcloud`.
   - Fill in `SERVICE_ACCOUNT_JSON` with your service account JSON details.
   - Set `GCLOUD_IDENTITY_TOKEN_AUDIENCE` to the URL of the Cloud Run service that should be the audience.

#### Using the Script

1. **Run the Script:**

   - Make the script executable: `chmod +x ./generate_gcloud_identity_token.sh`.
   - Execute the script: `./generate_gcloud_identity_token.sh`.
   - A new identity token will be generated and printed.

2. **Token Usage:**
   - Use this token as a bearer token for authenticated API requests.
   - Tokens are short-lived and will expire, requiring regeneration.

### Running the Application

- **Start the Server**

  ```sh
  npm start
  ```

  This command starts the local server.

- **Accessing the Token Generation Endpoint**
  - Use a tool like Postman to navigate to `http://localhost:3000/generate-gcloud-identity-token`.
  - The server will return a new Google Cloud identity token.

## Development

- **Running in Development Mode**
  ```sh
  npm run dev
  ```
  This starts the server with `nodemon`, automatically restarting on file changes.

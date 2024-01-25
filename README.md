# Google Cloud Token Generator

## Description

This application is a local Node.js server designed to generate Google Cloud identity tokens using a shell script. It's a solution for developers working with Google Cloud services who need to frequently generate new identity tokens, for services such as Postman.

Not indended to be used in production, such as CI/CD pipelines. Use it for Google Cloud _development_.

## Getting Started

### Dependencies

- Node.js and npm (Node Package Manager)
- Google Cloud SDK (gcloud command-line tool)
- Service account key with minimal permissions (e.g., `Cloud Run Invoker`), in JSON format, to be used in `.env.gcloud`. Keep this key file secret at all times, for example in Google Cloud Secret Manager.
- Bash or zsh (for running the shell script)

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

- This application is intended strictly for **local use**. Do not deploy or expose this application to external networks or the internet to avoid severe security vulnerabilities.

### .env.gcloud File Security

- You are responsible for handling the JSON key file. Keep it secret and safe at all times.
- Include `.env.gcloud` in your `.gitignore` file to prevent committing sensitive data.
- Never expose the contents of the `.env.gcloud` file publicly.

### Generating Identity Tokens

1. **Create a `.env.gcloud` File:**

   - Copy `.env.gcloud.example` to create a `.env.gcloud`.
   - Fill in `SERVICE_ACCOUNT_JSON` with your service account JSON details.
   - Set `GCLOUD_IDENTITY_TOKEN_AUDIENCE` to the URL of the Cloud Run service.

2. **Run the Script:**

   - Make the script executable: `chmod +x ./generate_gcloud_identity_token.sh`.
   - Execute the script to generate and print a new identity token.

3. **Token Usage:**
   - Use this token as a bearer token for authenticated API requests.
   - Tokens are short-lived and will expire, requiring regeneration.

### Running the Application

- **Start the Server**

  ```sh
  npm start
  ```

  Access the token generation endpoint using a tool like Postman at `http://localhost:9090/generate-gcloud-identity-token`.

  If you have set everything up correctly the app will return a short-lived identity token to you, for use as a bearer token in the Authorization header of e.g. Postman requests to your secure Cloud Run container's API.

## Development

- **Running in Development Mode**
  ```sh
  npm run dev
  ```
  Starts the server with `nodemon`, automatically restarting on file changes.

## Postman Automated Token Setup

Automate Google Cloud identity token generation in Postman using our server script for seamless API authentication.

#### Steps:

1. Create a collection variable `GCLOUD_IDENTITY_TOKEN`.

2. Add this "Before query" script to your queries:

   ```javascript
   pm.sendRequest(
     "http://localhost:9090/generate-gcloud-identity-token",
     (err, res) => {
       if (err) {
         console.log(err);
       } else {
         const token = res.json().token;

         pm.variables.set("GCLOUD_IDENTITY_TOKEN", token);
       }
     }
   );
   ```

Here we make a request to your local server to retrieve an identity token, which we can then use in step 3:

3. Use `{{GCLOUD_IDENTITY_TOKEN}}` as the bearer token in the Authorization header.

These tokens are short-lived, so it not a big risk to create many of them.

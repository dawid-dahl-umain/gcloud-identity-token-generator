import express from "express";
import { exec } from "child_process";

const app = express();
const port = 9090;

app.get("/generate-gcloud-identity-token", (req, res) => {
  exec("./generate_gcloud_identity_token.sh", (error, stdout, stderr) => {
    // Known message that is not an error
    const knownMessage = "Activated service account credentials for";

    if (error) {
      console.error(`Error executing script: ${error}`);
      return res.status(500).json({ error: error.message });
    }

    // Check if stderr contains anything other than the known message
    if (stderr && !stderr.includes(knownMessage)) {
      console.error(`Script error: ${stderr}`);
      return res.status(500).json({ error: stderr });
    }

    // Assuming the last line of stdout is the token
    const lines = stdout.trim().split("\n");
    const token = lines.pop();

    res.json({ token });
  });
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

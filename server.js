import express from "express";
import { exec } from "child_process";

const app = express();
const port = 9090;

app.get("/generate-gcloud-identity-token", (req, res) => {
  exec("./generate_gcloud_identity_token.sh", (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing script: ${error}`);
      return res.status(500).json({ error: error.message });
    }

    if (stderr) {
      console.error(`Script error: ${stderr}`);
      return res.status(500).json({ error: stderr });
    }

    const token = stdout.trim();
    res.json({ token });
  });
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

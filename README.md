# Build & push images to GitHub Container Registry (GHCR)

This repo shows how to build a Docker image and push it to GHCR using GitHub Actions.

## Quick steps

1. Push to `main` — GitHub Actions will build and push the image to:
   - `ghcr.io/<your-username>/build-push-app:latest`
   - `ghcr.io/<your-username>/build-push-app:<commit-sha>`

2. Pull & run locally:
   ```bash
   docker pull ghcr.io/<your-username>/build-push-app:latest
   docker run --rm -p 5000:5000 ghcr.io/<your-username>/build-push-app:latest


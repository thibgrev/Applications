
# API Component

## Description
This component is responsible for handling API requests to interact with the PostgreSQL database. It includes an Nginx configuration to handle requests.

## Files
- `app.py`: Main application file with route definitions for API endpoints.
- `nginx.conf`: Nginx configuration file to manage request routing for the API.
- `Dockerfile`: Dockerfile to build the API container image.
- `requirements.txt`: Python dependencies required for running the API.

## Usage
This API should be accessible on `http://localhost:8000/api` after deployment. It exposes various endpoints to interact with the backend database.

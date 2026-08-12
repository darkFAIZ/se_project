import os
from dotenv import load_dotenv

# Load environment variables from a .env file if present
load_dotenv()

# Extract Firebase credentials from environment variables
PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID", "")
CLIENT_EMAIL = os.getenv("FIREBASE_CLIENT_EMAIL", "")
# Ensure literal newline characters in the private key string are properly formatted
PRIVATE_KEY = os.getenv("FIREBASE_PRIVATE_KEY", "").replace('\\n', '\n')

# API Host and Port configurations with fallback defaults
HOST = os.getenv("FASTAPI_HOST", "0.0.0.0")
PORT = int(os.getenv("FASTAPI_PORT", "8000"))

# Consolidate Firebase credentials into a single dictionary for easy importing
FIREBASE_CONFIG = {
    "project_id": PROJECT_ID,
    "client_email": CLIENT_EMAIL,
    "private_key": PRIVATE_KEY,
}
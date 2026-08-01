import os
from dotenv import load_dotenv

load_dotenv()

PROJECT_ID = os.getenv("FIREBASE_PROJECT_ID", "")
CLIENT_EMAIL = os.getenv("FIREBASE_CLIENT_EMAIL", "")
PRIVATE_KEY = os.getenv("FIREBASE_PRIVATE_KEY", "").replace('\\n', '\n')
HOST = os.getenv("FASTAPI_HOST", "0.0.0.0")
PORT = int(os.getenv("FASTAPI_PORT", "8000"))

FIREBASE_CONFIG = {
    "project_id": PROJECT_ID,
    "client_email": CLIENT_EMAIL,
    "private_key": PRIVATE_KEY,
}

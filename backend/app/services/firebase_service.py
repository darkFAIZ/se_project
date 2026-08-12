import firebase_admin
from firebase_admin import credentials, firestore

from app.config import FIREBASE_CONFIG

# Ensure Firebase is only initialized once to prevent errors on reload
if not firebase_admin._apps:
    # Build credentials using configuration imported from config.py
    cred = credentials.Certificate({
        "type": "service_account",
        "project_id": FIREBASE_CONFIG["project_id"],
        "client_email": FIREBASE_CONFIG["client_email"],
        "private_key": FIREBASE_CONFIG["private_key"],
    })
    # Initialize the Firebase app with the defined credentials
    firebase_admin.initialize_app(cred)

# Initialize the Firestore database client
db = firestore.client()

# Getter function to provide database access to other modules
def get_db():
    return db
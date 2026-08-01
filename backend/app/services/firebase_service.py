import firebase_admin
from firebase_admin import credentials, firestore

from app.config import FIREBASE_CONFIG

if not firebase_admin._apps:
    cred = credentials.Certificate({
        "type": "service_account",
        "project_id": FIREBASE_CONFIG["project_id"],
        "client_email": FIREBASE_CONFIG["client_email"],
        "private_key": FIREBASE_CONFIG["private_key"],
    })
    firebase_admin.initialize_app(cred)


db = firestore.client()


def get_db():
    return db

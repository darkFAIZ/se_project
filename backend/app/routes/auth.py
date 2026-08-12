from datetime import datetime

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

# Initialize the router for authentication endpoints with a prefix
router = APIRouter(prefix="/api/auth", tags=["auth"])

# Get the Firestore database instance
db = get_db()


# Define the data schema for registering a new user
class RegisterRequest(BaseModel):
    name: str
    email: str
    authType: str = "email" # Defaults to "email" if not provided


# Define the data schema for logging in an existing user
class LoginRequest(BaseModel):
    email: str


@router.post("/register")
async def register_user(payload: RegisterRequest):
    # Validate that name and email are not empty
    if not payload.name.strip() or not payload.email.strip():
        raise HTTPException(status_code=400, detail="Name and email are required")

    # Normalize the email for consistent database lookups
    normalized_email = payload.email.lower().strip()
    
    # Check if a user with this email already exists in Firestore
    user_ref = db.collection("users").document(normalized_email)
    if user_ref.get().exists:
        raise HTTPException(status_code=409, detail="User already exists")

    # Create the new user document in Firestore
    user_ref.set({
        "id": normalized_email,
        "name": payload.name.strip(),
        "email": normalized_email,
        "authType": payload.authType,
        "avatarUrl": "",
        "createdAt": datetime.utcnow().isoformat(),
    })

    # Return success response with basic user details
    return {
        "success": True,
        "message": "User registered successfully",
        "user": {
            "id": normalized_email,
            "name": payload.name.strip(),
            "email": normalized_email,
        },
    }


@router.post("/login")
async def login_user(payload: LoginRequest):
    # Validate that the email is provided
    if not payload.email.strip():
        raise HTTPException(status_code=400, detail="Email is required")

    # Normalize email to match the database ID format
    normalized_email = payload.email.lower().strip()
    
    # Fetch the user document from Firestore
    user_doc = db.collection("users").document(normalized_email).get()
    
    # Check if the user exists
    if not user_doc.exists:
        raise HTTPException(status_code=404, detail="User not found")

    # Extract user data to a dictionary
    user = user_doc.to_dict()
    
    # Fetch any products associated with this user from their subcollection
    user_products = [
        product.to_dict() for product in db.collection("users").document(normalized_email).collection("products").stream()
    ]

    # Return success response containing user data and their products
    return {
        "success": True,
        "message": "Login successful",
        "user": {
            "id": user.get("id"),
            "name": user.get("name"),
            "email": user.get("email"),
            "authType": user.get("authType", "email"),
            "avatarUrl": user.get("avatarUrl", ""),
            "products": user_products,
        },
    }
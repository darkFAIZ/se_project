from datetime import datetime

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

router = APIRouter(prefix="/api/auth", tags=["auth"])

db = get_db()


class RegisterRequest(BaseModel):
    name: str
    email: str
    authType: str = "email"


class LoginRequest(BaseModel):
    email: str


@router.post("/register")
async def register_user(payload: RegisterRequest):
    if not payload.name.strip() or not payload.email.strip():
        raise HTTPException(status_code=400, detail="Name and email are required")

    normalized_email = payload.email.lower().strip()
    user_ref = db.collection("users").document(normalized_email)
    if user_ref.get().exists:
        raise HTTPException(status_code=409, detail="User already exists")

    user_ref.set({
        "id": normalized_email,
        "name": payload.name.strip(),
        "email": normalized_email,
        "authType": payload.authType,
        "avatarUrl": "",
        "createdAt": datetime.utcnow().isoformat(),
    })

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
    if not payload.email.strip():
        raise HTTPException(status_code=400, detail="Email is required")

    normalized_email = payload.email.lower().strip()
    user_doc = db.collection("users").document(normalized_email).get()
    if not user_doc.exists:
        raise HTTPException(status_code=404, detail="User not found")

    user = user_doc.to_dict()
    user_products = [
        product.to_dict() for product in db.collection("users").document(normalized_email).collection("products").stream()
    ]

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

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

    user_ref = db.collection("users").document(payload.email.lower())
    if user_ref.get().exists:
        raise HTTPException(status_code=409, detail="User already exists")

    user_ref.set({
        "id": payload.email.lower(),
        "name": payload.name,
        "email": payload.email.lower(),
        "authType": payload.authType,
        "avatarUrl": "",
        "createdAt": __import__("datetime").datetime.utcnow().isoformat(),
    })

    return {
        "success": True,
        "message": "User registered successfully",
        "user": {
            "id": payload.email.lower(),
            "name": payload.name,
            "email": payload.email.lower(),
        },
    }


@router.post("/login")
async def login_user(payload: LoginRequest):
    if not payload.email.strip():
        raise HTTPException(status_code=400, detail="Email is required")

    user_doc = db.collection("users").document(payload.email.lower()).get()
    if not user_doc.exists:
        raise HTTPException(status_code=404, detail="User not found")

    user = user_doc.to_dict()
    return {
        "success": True,
        "message": "Login successful",
        "user": {
            "id": user.get("id"),
            "name": user.get("name"),
            "email": user.get("email"),
        },
    }

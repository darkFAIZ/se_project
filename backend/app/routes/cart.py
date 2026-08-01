from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

router = APIRouter(prefix="/api/cart", tags=["cart"])
db = get_db()


class CartItemPayload(BaseModel):
    userId: str
    productId: str
    title: str
    price: float
    quantity: int = 1


@router.get("/{user_id}")
async def get_cart(user_id: str):
    cart_doc = db.collection("carts").document(user_id).get()
    if not cart_doc.exists:
        return {"success": True, "items": []}
    return {"success": True, "items": cart_doc.to_dict().get("items", [])}


@router.post("/add")
async def add_to_cart(payload: CartItemPayload):
    if not payload.userId.strip():
        raise HTTPException(status_code=400, detail="User ID is required")

    cart_ref = db.collection("carts").document(payload.userId)
    doc = cart_ref.get()
    current_items = [] if not doc.exists else doc.to_dict().get("items", [])

    existing = next((item for item in current_items if item.get("productId") == payload.productId), None)
    if existing:
        existing["quantity"] = existing.get("quantity", 1) + payload.quantity
    else:
        current_items.append({
            "productId": payload.productId,
            "title": payload.title,
            "price": payload.price,
            "quantity": payload.quantity,
        })

    cart_ref.set({"items": current_items})
    return {"success": True, "items": current_items}


@router.post("/clear")
async def clear_cart(user_id: str):
    db.collection("carts").document(user_id).set({"items": []})
    return {"success": True, "message": "Cart cleared"}

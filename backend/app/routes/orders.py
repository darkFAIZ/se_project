from datetime import datetime
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

router = APIRouter(prefix="/api/orders", tags=["orders"])
db = get_db()


class OrderItem(BaseModel):
    id: str
    title: str
    price: float
    quantity: int
    category: str | None = None


class CheckoutRequest(BaseModel):
    userId: str
    address: str
    city: str
    district: str
    postalCode: str
    paymentMethod: str
    bank: str | None = None
    items: list[OrderItem]


@router.post("/checkout")
async def checkout(payload: CheckoutRequest):
    if not payload.userId.strip():
        raise HTTPException(status_code=400, detail="User ID is required")

    if not payload.address.strip() or not payload.city.strip() or not payload.district.strip() or not payload.postalCode.strip():
        raise HTTPException(status_code=400, detail="Address information is incomplete")

    if payload.paymentMethod == "Card" and not payload.bank:
        raise HTTPException(status_code=400, detail="Please choose a bank for card payment")

    total = sum(item.price * item.quantity for item in payload.items)
    order_id = f"ORD-{datetime.utcnow().strftime('%Y%m%d%H%M%S')}"

    order = {
        "id": order_id,
        "userId": payload.userId,
        "address": payload.address,
        "city": payload.city,
        "district": payload.district,
        "postalCode": payload.postalCode,
        "paymentMethod": payload.paymentMethod,
        "bank": payload.bank or "QRIS",
        "status": "Packed",
        "total": total,
        "items": [item.model_dump() for item in payload.items],
        "createdAt": datetime.utcnow().isoformat(),
    }

    db.collection("orders").document(order_id).set(order)

    return {
        "success": True,
        "message": "Order placed successfully",
        "order": order,
    }


@router.get("/user/{user_id}")
async def get_user_orders(user_id: str):
    orders = db.collection("orders").where("userId", "==", user_id).stream()
    result = []
    for order in orders:
        result.append(order.to_dict())
    return {"success": True, "orders": result}

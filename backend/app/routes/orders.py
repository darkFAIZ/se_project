from datetime import datetime
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

# Initialize the router for order-related endpoints
router = APIRouter(prefix="/api/orders", tags=["orders"])
db = get_db()


# Define the data schema for individual items within an order
class OrderItem(BaseModel):
    id: str
    title: str
    price: float
    quantity: int
    category: str | None = None # Category is optional


# Define the data schema for the checkout payload
class CheckoutRequest(BaseModel):
    userId: str
    address: str
    city: str
    district: str
    postalCode: str
    paymentMethod: str
    bank: str | None = None # Bank is optional (mostly for non-card payments)
    items: list[OrderItem]


@router.post("/checkout")
async def checkout(payload: CheckoutRequest):
    # Validate user ID presence
    if not payload.userId.strip():
        raise HTTPException(status_code=400, detail="User ID is required")

    # Validate that all required address fields are provided
    if not payload.address.strip() or not payload.city.strip() or not payload.district.strip() or not payload.postalCode.strip():
        raise HTTPException(status_code=400, detail="Address information is incomplete")

    # Enforce bank selection if the payment method is Card
    if payload.paymentMethod == "Card" and not payload.bank:
        raise HTTPException(status_code=400, detail="Please choose a bank for card payment")

    # Calculate the total price based on item prices and quantities
    total = sum(item.price * item.quantity for item in payload.items)
    
    # Generate a unique order ID using the current UTC timestamp
    order_id = f"ORD-{datetime.utcnow().strftime('%Y%m%d%H%M%S')}"

    # Construct the order dictionary
    order = {
        "id": order_id,
        "userId": payload.userId,
        "address": payload.address,
        "city": payload.city,
        "district": payload.district,
        "postalCode": payload.postalCode,
        "paymentMethod": payload.paymentMethod,
        "bank": payload.bank or "QRIS", # Default to QRIS if no bank is provided
        "status": "Packed", # Initial order status
        "total": total,
        "items": [item.model_dump() for item in payload.items], # Serialize Pydantic objects to dicts
        "createdAt": datetime.utcnow().isoformat(),
    }

    # Save the new order to the Firestore "orders" collection
    db.collection("orders").document(order_id).set(order)

    return {
        "success": True,
        "message": "Order placed successfully",
        "order": order,
    }


@router.get("/user/{user_id}")
async def get_user_orders(user_id: str):
    # Query Firestore for all orders matching the provided user ID
    orders = db.collection("orders").where("userId", "==", user_id).stream()
    
    # Compile the query results into a list
    result = []
    for order in orders:
        result.append(order.to_dict())
        
    return {"success": True, "orders": result}
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

# Initialize the router for shopping cart endpoints
router = APIRouter(prefix="/api/cart", tags=["cart"])
db = get_db()


# Define the data schema for adding an item to the cart
class CartItemPayload(BaseModel):
    userId: str
    productId: str
    title: str
    price: float
    quantity: int = 1 # Default quantity is 1


@router.get("/{user_id}")
async def get_cart(user_id: str):
    # Retrieve the user's cart document from Firestore
    cart_doc = db.collection("carts").document(user_id).get()
    
    # Return an empty cart if the document doesn't exist
    if not cart_doc.exists:
        return {"success": True, "items": []}
        
    # Return the existing cart items
    return {"success": True, "items": cart_doc.to_dict().get("items", [])}


@router.post("/add")
async def add_to_cart(payload: CartItemPayload):
    # Validate that a user ID is provided
    if not payload.userId.strip():
        raise HTTPException(status_code=400, detail="User ID is required")

    # Fetch the current cart for the user
    cart_ref = db.collection("carts").document(payload.userId)
    doc = cart_ref.get()
    
    # Initialize an empty list if cart doesn't exist, otherwise load current items
    current_items = [] if not doc.exists else doc.to_dict().get("items", [])

    # Check if the product is already in the cart
    existing = next((item for item in current_items if item.get("productId") == payload.productId), None)
    
    if existing:
        # If it exists, increment the quantity
        existing["quantity"] = existing.get("quantity", 1) + payload.quantity
    else:
        # If it doesn't exist, append it as a new item
        current_items.append({
            "productId": payload.productId,
            "title": payload.title,
            "price": payload.price,
            "quantity": payload.quantity,
        })

    # Update the cart document in Firestore with the modified items list
    cart_ref.set({"items": current_items})
    return {"success": True, "items": current_items}


@router.post("/clear")
async def clear_cart(user_id: str):
    # Empty the cart for the specified user by setting items to an empty array
    db.collection("carts").document(user_id).set({"items": []})
    return {"success": True, "message": "Cart cleared"}
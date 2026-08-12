from datetime import datetime

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

# Initialize the router for product-related endpoints
router = APIRouter(prefix="/api/products", tags=["products"])
db = get_db()


# Define the data schema for creating a new product
class ProductPayload(BaseModel):
    userId: str
    title: str
    price: float
    category: str
    subCategory: str | None = None
    farmer: str | None = None
    origin: str | None = None
    stock: str | None = None
    description: str | None = None
    imageUrl: str | None = None


# Helper function to convert a Firestore document into a dictionary and inject its ID
def serialize_product(doc):
    data = doc.to_dict()
    data["id"] = doc.id
    return data


@router.get("")
async def get_products():
    # Fetch all products from the main "products" collection
    products = [serialize_product(doc) for doc in db.collection("products").stream()]
    return {"success": True, "products": products}


@router.get("/user/{user_id}")
async def get_user_products(user_id: str):
    # Fetch products specific to a user from their personal "products" subcollection
    user_ref = db.collection("users").document(user_id.lower())
    products = [serialize_product(doc) for doc in user_ref.collection("products").stream()]
    return {"success": True, "products": products}


@router.post("")
async def create_product(payload: ProductPayload):
    # Validate required fields
    if not payload.userId.strip():
        raise HTTPException(status_code=400, detail="User ID is required")
    if not payload.title.strip():
        raise HTTPException(status_code=400, detail="Product title is required")

    # Generate a unique product ID combining the user ID and a timestamp
    product_id = f"{payload.userId.lower()}-{int(datetime.utcnow().timestamp() * 1000)}"
    
    # Construct the product data, applying default values for optional fields
    product_data = {
        "id": product_id,
        "userId": payload.userId.lower(),
        "title": payload.title.strip(),
        "price": payload.price,
        "category": payload.category.strip(),
        "subCategory": payload.subCategory or "Fresh Harvest",
        "farmer": payload.farmer or "Pak Tani",
        "origin": (payload.origin or "BOGOR").upper(),
        "stock": payload.stock or "10.0 kg",
        "description": payload.description or "Fresh harvest directly from farm.",
        "imageUrl": payload.imageUrl or "https://images.unsplash.com/photo-1540420773420-3366772f4999?q=80&w=600",
        "createdAt": datetime.utcnow().isoformat(),
    }

    # Save the product in the global "products" collection
    db.collection("products").document(product_id).set(product_data)
    # Also save a copy of the product in the user's specific subcollection
    db.collection("users").document(payload.userId.lower()).collection("products").document(product_id).set(product_data)

    return {
        "success": True,
        "message": "Product uploaded successfully",
        "product": product_data,
    }


@router.get("/{product_id}")
async def get_product_by_id(product_id: str):
    # Fetch a specific product by its ID
    product_doc = db.collection("products").document(product_id).get()
    
    # Return an error if the product doesn't exist
    if not product_doc.exists:
        return {"success": False, "message": "Product not found"}
        
    return {"success": True, "product": serialize_product(product_doc)}
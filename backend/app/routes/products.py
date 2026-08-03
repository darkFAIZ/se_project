from datetime import datetime

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from app.services.firebase_service import get_db

router = APIRouter(prefix="/api/products", tags=["products"])
db = get_db()


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


def serialize_product(doc):
    data = doc.to_dict()
    data["id"] = doc.id
    return data


@router.get("")
async def get_products():
    products = [serialize_product(doc) for doc in db.collection("products").stream()]
    return {"success": True, "products": products}


@router.get("/user/{user_id}")
async def get_user_products(user_id: str):
    user_ref = db.collection("users").document(user_id.lower())
    products = [serialize_product(doc) for doc in user_ref.collection("products").stream()]
    return {"success": True, "products": products}


@router.post("")
async def create_product(payload: ProductPayload):
    if not payload.userId.strip():
        raise HTTPException(status_code=400, detail="User ID is required")
    if not payload.title.strip():
        raise HTTPException(status_code=400, detail="Product title is required")

    product_id = f"{payload.userId.lower()}-{int(datetime.utcnow().timestamp() * 1000)}"
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

    db.collection("products").document(product_id).set(product_data)
    db.collection("users").document(payload.userId.lower()).collection("products").document(product_id).set(product_data)

    return {
        "success": True,
        "message": "Product uploaded successfully",
        "product": product_data,
    }


@router.get("/{product_id}")
async def get_product_by_id(product_id: str):
    product_doc = db.collection("products").document(product_id).get()
    if not product_doc.exists:
        return {"success": False, "message": "Product not found"}
    return {"success": True, "product": serialize_product(product_doc)}

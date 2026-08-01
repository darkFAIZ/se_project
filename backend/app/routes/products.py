from fastapi import APIRouter

router = APIRouter(prefix="/api/products", tags=["products"])

PRODUCTS = [
    {
        "id": "p1",
        "title": "Broccoli",
        "price": 20,
        "category": "Vegetables",
        "origin": "BOGOR",
        "farmer": "Pak Tani",
        "stock": "50.0 kg",
        "description": "Freshly harvested organic broccoli.",
        "imageUrl": "https://images.unsplash.com/photo-1584270354949-c26b0d5b4a0c?q=80&w=600",
    },
    {
        "id": "p2",
        "title": "Fresh Carrots",
        "price": 12,
        "category": "Vegetables",
        "origin": "BANDUNG",
        "farmer": "Bu Sri",
        "stock": "30.0 kg",
        "description": "Sweet and crisp organic carrots.",
        "imageUrl": "https://images.unsplash.com/photo-1598170845058-12ef4a457939?q=80&w=600",
    },
    {
        "id": "p3",
        "title": "Red Fuji Apples",
        "price": 25,
        "category": "Fruits",
        "origin": "MALANG",
        "farmer": "Pak Budi",
        "stock": "45.0 kg",
        "description": "Juicy Fuji apples from Malang.",
        "imageUrl": "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?q=80&w=600",
    },
]


@router.get("")
async def get_products():
    return {
        "success": True,
        "products": PRODUCTS,
    }


@router.get("/{product_id}")
async def get_product_by_id(product_id: str):
    product = next((item for item in PRODUCTS if item["id"] == product_id), None)
    if product is None:
        return {"success": False, "message": "Product not found"}
    return {"success": True, "product": product}

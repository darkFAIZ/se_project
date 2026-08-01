from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.routes.auth import router as auth_router
from app.routes.products import router as products_router
from app.routes.cart import router as cart_router
from app.routes.orders import router as orders_router

app = FastAPI(title="Kebunku Marketplace API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(products_router)
app.include_router(cart_router)
app.include_router(orders_router)


@app.get("/")
async def root():
    return {
        "message": "Kebunku Marketplace API is running",
        "status": "ok",
        "endpoints": [
            "/api/auth/register",
            "/api/auth/login",
            "/api/products",
            "/api/cart/{user_id}",
            "/api/orders/checkout",
        ],
    }

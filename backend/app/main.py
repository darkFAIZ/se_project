from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

# Import route handlers from the app's route modules
from app.routes.auth import router as auth_router
from app.routes.products import router as products_router
from app.routes.cart import router as cart_router
from app.routes.orders import router as orders_router

# Initialize the primary FastAPI application instance
app = FastAPI(title="Kebunku Marketplace API", version="1.0.0")

# Configure Cross-Origin Resource Sharing (CORS) to allow requests from front-end applications
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],     # Allows all origins (can be restricted in production)
    allow_credentials=True,
    allow_methods=["*"],     # Allows all HTTP methods (GET, POST, etc.)
    allow_headers=["*"],     # Allows all headers
)

# Register the imported routers with the main application
app.include_router(auth_router)
app.include_router(products_router)
app.include_router(cart_router)
app.include_router(orders_router)


# Define a basic root endpoint to check if the API is running and list available endpoints
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
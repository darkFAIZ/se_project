# Kebunku Marketplace

This project contains:
- Flutter app in `lib/`
- Python FastAPI backend in `backend/`

## Backend setup

```bash
cd backend
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## Firebase setup

1. Create a Firebase project.
2. Download your service account JSON.
3. Put the relevant values into a `.env` file based on `.env.example`.
4. Make sure Firestore is enabled.

## API endpoints

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/products`
- `GET /api/products/{product_id}`
- `GET /api/cart/{user_id}`
- `POST /api/cart/add`
- `POST /api/cart/clear`
- `POST /api/orders/checkout`
- `GET /api/orders/user/{user_id}`

## Notes

This backend is configured for Firebase Firestore integration and is ready for expansion with QRIS and real payment services.

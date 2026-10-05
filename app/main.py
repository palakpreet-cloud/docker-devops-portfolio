from fastapi import FastAPI
from sqlalchemy import text

from app.database import engine


app = FastAPI(title="Docker DevOps Portfolio API")


@app.get("/")
def root():
    return {
        "message": "Docker DevOps Portfolio API is running"
    }


@app.get("/health")
def health():
    return {
        "status": "healthy"
    }


@app.get("/db-health")
def db_health():
    try:
        with engine.connect() as connection:
            connection.execute(text("SELECT 1"))

        return {
            "status": "healthy",
            "database": "connected",
        }

    except Exception as error:
        return {
            "status": "unhealthy",
            "database": "disconnected",
            "error": str(error),
        }

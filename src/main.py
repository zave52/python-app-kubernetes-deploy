import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, status, Depends
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from src.config import get_settings
from src.database import engine, get_db
from src.models import Base
from src.routes import router

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    logger.info("Database tables created successfully")
    yield


app = FastAPI(
    title="User Management API",
    version=settings.API_VERSION,
    description="Simple RESTful API for user management with PostgreSQL",
    lifespan=lifespan
)


@app.get("/health", tags=["health"])
async def health_check():
    return {"status": "healthy", "service": "user-api"}


@app.get("/ready", tags=["health"])
async def readiness_check(db: AsyncSession = Depends(get_db)):
    try:
        await db.execute(text("SELECT 1"))
        return {"status": "ready", "database": "connected"}
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database not ready"
        )


app.include_router(router, prefix=settings.API_PREFIX)

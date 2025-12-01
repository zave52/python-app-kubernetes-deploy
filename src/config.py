from functools import lru_cache

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    POSTGRES_USER: str = ""
    POSTGRES_PASSWORD: str = ""
    POSTGRES_HOST: str = ""
    POSTGRES_PORT: int = 5432
    POSTGRES_DB: str = ""
    LOG_LEVEL: str = "INFO"
    API_VERSION: str = "v1"
    API_PREFIX: str = "/api/v1"

    @property
    def DATABASE_URL(self) -> str:
        return f"postgresql+asyncpg://{self.POSTGRES_USER}:{self.POSTGRES_PASSWORD}@{self.POSTGRES_HOST}:{self.POSTGRES_PORT}/{self.POSTGRES_DB}"

    class Config:
        env_file = "../.env"


@lru_cache()
def get_settings():
    return Settings()

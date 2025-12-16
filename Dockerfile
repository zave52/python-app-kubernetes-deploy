FROM python:3.13-alpine3.22 as builder

WORKDIR /app

COPY pyproject.toml poetry.lock* ./

RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi --no-root

FROM python:3.13-alpine3.22

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

COPY src/ .

RUN addgroup -S appuser \
    && adduser -S -G appuser appuser \
    && chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

ENTRYPOINT ["uvicorn", "main:app", "--host", "0.0.0.0"]

CMD ["--port", "8000"]

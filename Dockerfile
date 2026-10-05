# ---------- Builder stage ----------
FROM python:3.12-slim AS builder

WORKDIR /build

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# ---------- Runtime stage ----------
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /install /usr/local

COPY app/ ./app/

# Create a dedicated non-root user
RUN useradd --create-home --shell /bin/bash appuser

# Give the application user ownership of the application directory
RUN chown -R appuser:appuser /app

# Switch from root to the application user
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

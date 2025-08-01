# Stage 1: Builder
FROM python:3.10-slim-buster as builder

WORKDIR /app
COPY requirements.txt .

# Install dependencies into /install directory
RUN pip install --no-cache-dir --target=/install -r requirements.txt

# Stage 2: Final image
FROM python:3.10-slim-buster

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local/lib/python3.10/site-packages

# Copy application code
COPY . .

# Expose the port for Railway
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

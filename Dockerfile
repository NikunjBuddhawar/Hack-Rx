# ---------- Stage 1: Builder ----------
FROM python:3.11-slim AS builder

WORKDIR /app

# Install pip and system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libgl1-mesa-glx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install dependencies into a temp location
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---------- Stage 2: Final Image ----------
FROM python:3.11-slim

ENV PATH="/install/bin:$PATH"
WORKDIR /app

# Copy installed packages
COPY --from=builder /install /install

# Copy application code
COPY . .

# Optional: restrict to only what's needed for runtime
RUN apt-get update && apt-get install -y \
    libglib2.0-0 \
    libgl1-mesa-glx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose the port Railway expects
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

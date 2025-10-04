# ---------- builder ----------
FROM python:3.11-slim AS builder
WORKDIR /build

COPY app/requirements.txt .
RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
 && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --upgrade pip
RUN pip wheel --no-cache-dir --wheel-dir=/wheels -r requirements.txt
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt

COPY app/ /build/app

# ---------- runtime ----------
FROM python:3.11-slim
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY --from=builder /build/app /app
RUN chown -R appuser:appgroup /app /opt/venv

USER appuser
EXPOSE 5000
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app", "--workers", "2"]


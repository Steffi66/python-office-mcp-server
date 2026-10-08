FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends git \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN pip install --no-cache-dir .

ENV MCP_WORKSPACE_ROOT=/data
ENV PYTHONUNBUFFERED=1

EXPOSE 8765

CMD ["office-mcp-server", "--host", "0.0.0.0", "--port", "8765", "--http"]

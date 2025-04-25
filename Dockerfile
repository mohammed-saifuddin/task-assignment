

# --------------------------------------------
# Stage 1: Scraper (Node.js + Puppeteer + Chromium)
# --------------------------------------------
    FROM node:18-slim AS scraper

    # Set working directory
    WORKDIR /app
    
    # Avoid downloading Chromium with Puppeteer
    ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
    
    RUN apt-get update && \
    apt-get install -y \
    chromium \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
    # Copy only package.json to leverage cache
    COPY package*.json ./
    
    # Clean and install dependencies
    RUN rm -rf /root/.npm /app/node_modules && npm install --legacy-peer-deps
    
    # Copy the rest of the scraper app
    COPY scrape.js ./
    
    # Set the scrape URL (can be passed via `--build-arg` or runtime `-e`)
    ARG SCRAPE_URL
    ENV SCRAPE_URL=${SCRAPE_URL}
    
    # Run the scraper script
    RUN node scrape.js
    
    # --------------------------------------------
    # Stage 2: Python Server (Flask)
    # --------------------------------------------
    FROM python:3.10-slim AS final
    
    WORKDIR /app
    
    # Copy server files
    COPY server.py .
    COPY requirements.txt .
    
    # Install Python dependencies
    RUN pip install --no-cache-dir -r requirements.txt
    
    # Copy scraped data from scraper stage
    COPY --from=scraper /app/scraped_data.json ./
    
    # Expose port and run server
    EXPOSE 5000
    CMD ["python", "server.py"]
    
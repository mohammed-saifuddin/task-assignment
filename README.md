# 🕷️ Web Scraper with Node.js + Puppeteer + Python Flask

This project demonstrates a multi-stage Docker build using:
- Node.js and Puppeteer to scrape a user-specified URL
- Python Flask to host the scraped result

---

## 🚀 Features

- Scrapes a given URL using Puppeteer (headless Chromium)
- Extracts `<title>` and first `<h1>` heading
- Serves the scraped JSON via Flask
- Lightweight final image using multi-stage Docker build

---

## 📦 Build the Docker Image

```bash
docker build --build-arg SCRAPE_URL="https://example.com" -t web-scraper .

▶️ Run the Container:
docker run -p 5000:5000 web-scraper

🌐 Access the Scraped Data
Open your browser and go to:
http://localhost:5000/

You will see a JSON output like:

{
  "title": "Example Domain",
  "heading": "Example Domain"
}

📁 Project Structure:

.
├── Dockerfile
├── scraper.js
├── server.py
├── package.json
├── requirements.txt
└── README.md

🛠️ Tech Stack
Node.js 18

Puppeteer + Chromium

Python 3.10

Flask

Docker (Multi-stage build)



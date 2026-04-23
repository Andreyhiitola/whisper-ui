FROM python:3.10-slim
RUN apt-get update && apt-get install -y tesseract-ocr tesseract-ocr-rus && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir flask pytesseract pillow
COPY server.py /app/
WORKDIR /app
CMD ["python", "server.py"]

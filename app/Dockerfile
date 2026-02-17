FROM python:3.11-alpine

WORKDIR /app

# Upgrade pip and wheel first
RUN pip install --upgrade pip wheel setuptools

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 8080

CMD ["python", "app.py"]

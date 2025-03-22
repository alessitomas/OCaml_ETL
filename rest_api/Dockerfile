# Use official Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Copy requirements
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app.py .
COPY data/ ./data/

# Expose port 8000
EXPOSE 8000

# Command to run the FastAPI app
# uvicorn app:app --host 0.0.0.0 --port 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

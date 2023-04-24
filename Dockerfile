FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7


# Copy your application code to the container
COPY ./app /app

COPY requirements.txt .

# Install Python dependencies
RUN pip --no-cache-dir install -r requirements.txt


FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

# Install required dependencies for Kafka
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless wget

# Download and extract Kafka binaries
RUN wget https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz && \
    tar -xzf kafka_2.13-3.4.0.tgz && \
    rm kafka_2.13-3.4.0.tgz

# Set the Kafka home directory
ENV KAFKA_HOME /kafka_2.13-3.4.0

# Copy your application code to the container
COPY ./app /app

COPY requirements.txt .

# Install Python dependencies
RUN pip --no-cache-dir install -r requirements.txt

# Expose Kafka's port for external access
EXPOSE 9092

# Start Kafka server
CMD ["./kafka_2.13-3.4.0/bin/kafka-server-start.sh", "./kafka_2.13-3.4.0/config/server.properties"]
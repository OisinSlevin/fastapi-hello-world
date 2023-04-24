FROM tiangolo/uvicorn-gunicorn-fastapi:python3.7

# Install required dependencies for Kafka and Zookeeper
RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless wget && \
    apt-get install -y zookeeperd

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

# Expose Kafka's and Zookeeper's ports for external access
EXPOSE 9092 2181

# Start Zookeeper server


CMD ["sh", "-c", "./kafka_2.13-3.4.0/bin/zookeeper-server-start.sh ./kafka_2.13-3.4.0/config/zookeeper.properties & \
    sleep 10 && \
    ./kafka_2.13-3.4.0/bin/kafka-server-start.sh ./kafka_2.13-3.4.0/config/server.properties & \
    sleep 10 && \
    ./kafka_2.13-3.4.0/bin/kafka-topics.sh --list --bootstrap-server localhost:9092 | grep -q 'view-counter' && uvicorn main:app --host 0.0.0.0 --port 80  || \
    ./kafka_2.13-3.4.0/bin/kafka-topics.sh --create --topic view-counter --bootstrap-server localhost:9092 && \
    uvicorn main:app --host 0.0.0.0 --port 80 "]


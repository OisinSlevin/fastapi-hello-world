from fastapi import FastAPI 
from kafka import KafkaProducer
from kafka import KafkaConsumer
from kafka import TopicPartition


app = FastAPI(
    title="FastAPI - Hello World",
    description="This is the Hello World of FastAPI.",
    version="1.0.0",
) 


@app.get("/")
def hello_world():
    producer =KafkaProducer(bootstrap_servers=["localhost:9092"])    
    producer.send('view-counter', key=b'foo', value=b'bar')

    consumer =KafkaConsumer(bootstrap_servers=["localhost:9092"],auto_offset_reset='earliest')
    
    topic = 'view-counter'
    tp = TopicPartition(topic,0)
    #register to the topic
    consumer.assign([tp])

    # obtain the last offset value
    consumer.seek_to_end(tp)
    lastOffset = consumer.position(tp)

    consumer.seek_to_beginning(tp)     

    kafka_msgs=""

    view_counter=0
    for msg in consumer:
        kafka_msgs+=str(msg)+"\n"
        view_counter+=1
        if msg.offset == lastOffset - 1:
            break

    with open('testing.txt', 'w') as f:
        f.write('yes the app is running')
    return {"Hello since this container has been live this page has been viewed :": str(view_counter )+" times"}
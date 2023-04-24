from fastapi import FastAPI 
from kafka import producer

app = FastAPI(
    title="FastAPI - Hello World",
    description="This is the Hello World of FastAPI.",
    version="1.0.0",
) 


@app.get("/")
def hello_world():
    return {"Hello": "OisinSlev"}
from fastapi import FastAPI
import boto3
import os
import json
from datetime import datetime

print("CI/CD Pipeline Test deploy")
#########################################################################################################################
# diese APP schreibt in Kinesis die empfangegenen Daten der Sensoren der Autos, Healthendpoint für ALB
# empfängt Daten der Sensoren und leitet sie an Kinesis weiter 

app = FastAPI()
AWS_REGION = os.getenv('AWS_REGION', 'eu-central-1')

sqs = boto3.client('sqs', region_name=os.getenv('AWS_REGION'))

queue_url = os.getenv("SQS_QUEUE_URL")

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/ingest")
async def ingest(data: dict):
    data['timestamp'] = datetime.utcnow().isoformat()

    sqs.send_message(
        QueueUrl=queue_url,
        MessageBody=json.dumps(data)
    )

    return {"status": "success", "message": "Data ingested successfully"}
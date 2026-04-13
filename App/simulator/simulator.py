import requests
import time
import random
import os

INGEST_URL = os.getenv("INGEST_URL")  #später ersetzen durch ALB URL

if not INGEST_URL:
    raise Exception("Error: INGEST_URL environment variable not set, set variable.")
    
def generate_data():
    return {
        "car_id": f"car_{random.randint(1, 100)}",
        "lat": 50.1109,
        "lon": 8.6821,
        "temperature": random.randint(-5, 20),
        "slipdetection": random.choice([True, False]),
    }

while True:
    data = generate_data()
    print("Sending:", data)

    try:
        requests.post(INGEST_URL, json=data)
    except Exception as e:
        print("Error sending data:", e)
        
    time.sleep(2)
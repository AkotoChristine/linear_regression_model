from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import List
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from joblib import load 
from datetime import datetime
import os
import pandas as pd
import numpy as np



# API setup
app = FastAPI()

# Load the trained model
file_path = os.path.join(os.path.dirname(__file__), "linearmodel.pkl")
linear_model = load(file_path)

# Add CORS middleware to allow requests from any frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace with specific origins if needed
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def read_root():
    return {"Predict": "your next period date"}


class PredictionInput(BaseModel):
    login_date: str  # Accepts date as "YYYY-MM-DD"
    cycle_length: int
    period_duration: int

@app.post("/predict")
def predict(data: PredictionInput):
    try:
        # Convert login_date to timestamp
        login_timestamp = int(pd.to_datetime(data.login_date).timestamp())

        # Prepare input for model
        input_df = pd.DataFrame([[login_timestamp, data.cycle_length, data.period_duration]],
                                columns=['login_timestamp', 'cycle_length', 'period_duration'])

        # Make prediction
        predicted_timestamp = linear_model.predict(input_df)[0]
        predicted_date = datetime.utcfromtimestamp(predicted_timestamp).strftime("%Y-%m-%d")

        return {"predicted_next_period_date": predicted_date}

    except Exception as e:
        return {"error": str(e)}

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)
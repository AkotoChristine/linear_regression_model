from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import List
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from joblib import load 
from datetime import datetime
import os



class InputData(BaseModel):
    Login_Date : datetime = Field(...,  description="the date of period start")
    Cycle_Length: int = Field(..., ge=0, le=100, description="Value must be between 10 and 500")
    Period_duration : int =  Field(..., ge=0, le=100, description="Value must be between 10 and 500")



#initializing model 
app = FastAPI()

# Add CORS middleware to allow requests from any frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace with specific origins if needed
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the trained model
linear_model = load('linear_model.pkl')  

@app.get("/")
def read_root():
    return {"message": "Welcome to the FastAPI server!"}



@app.post("/predict")
def predict(data: InputData):
    login_timestamp = data.Login_Date.timestamp()  # Convert datetime to timestamp
    input_features = [[login_timestamp, data.Cycle_Length, data.Period_duration]]
    prediction = linear_model.predict(input_features)
    return {"prediction": prediction.tolist()}  # Convert NumPy array to a list for JSON response

# Run the API using Uvicorn
#if __name__ == "__main__":
 #   port = int(os.environ.get("PORT", 8000))
  #  uvicorn.run(app, host="0.0.0.0", port=port)


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)

from fastapi import FastAPI
from pydantic import BaseModel, Field
from typing import List
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
import joblib 
from datetime import datetime

# Load the trained model
model = joblib.load("summative/linear_regression/model.pkl")  

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

class InputData(BaseModel):
    Login_Date : datetime = Field(...,  description="the date of period start")
    Cycle_Length: int = Field(..., ge=0, le=100, description="Value must be between 10 and 500")
    Period_duration : int =  Field(..., ge=0, le=100, description="Value must be between 10 and 500")


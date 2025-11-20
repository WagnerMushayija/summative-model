# main.py  ← FINAL VERSION — THIS WORKS 100%
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib
import pandas as pd
import os

# Load model
model = joblib.load("models/best_energy_model_correct.pkl")

app = FastAPI(
    title="Building Energy Consumption Predictor",
    description="Random Forest model (R² = 0.9813) — Production Ready",
    version="1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# INPUT MODEL — we use underscores here (clean JSON)
class BuildingInput(BaseModel):
    Building_Type: str = Field(..., example="Industrial")
    Square_Footage: int = Field(..., ge=500, le=100000, example=40000)
    Number_of_Occupants: int = Field(..., ge=1, le=1000, example=120)
    Appliances_Used: int = Field(..., ge=1, le=300, example=80)
    Average_Temperature: float = Field(..., ge=10.0, le=40.0, example=28.0)
    Day_of_Week: str = Field(..., example="Weekday")

@app.get("/")
def home():
    return {"message": "Energy API is LIVE! → /docs"}

@app.post("/predict")
def predict(payload: BuildingInput):
    # Convert from clean JSON keys → original column names with spaces
    input_data = {
        'Building Type': payload.Building_Type,
        'Square Footage': payload.Square_Footage,
        'Number of Occupants': payload.Number_of_Occupants,
        'Appliances Used': payload.Appliances_Used,
        'Average Temperature': payload.Average_Temperature,
        'Day of Week': payload.Day_of_Week
    }

    df = pd.DataFrame([input_data])

    prediction = model.predict(df)[0]

    return {
        "predicted_energy_kwh": round(float(prediction), 2),
        "unit": "kWh",
        "model": "Random Forest (R² = 0.9813)",
        "status": "success"
    }


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=port)
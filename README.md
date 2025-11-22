# Energy Predictor – Daily Electricity Consumption Forecast  
**Wagner Mushayija – Maths For Ml Summative**  
**Submission Date: November 22, 2025**

### Project Mission
Help Rwandan households and building owners accurately predict their daily electricity consumption (kWh/day) so they can budget their REG bills, avoid surprises, and make smarter energy-saving decisions.  
A single, easy-to-use mobile app powered by machine learning and a live public API.

### Live Public API (Ready for Assessment)
Publicly routable URL (no localhost)  
Swagger UI: https://summative-model.onrender.com/docs  
Direct endpoint: `POST https://summative-model.onrender.com/predict`
### Youtube Link: https://youtu.be/hOMrhHaapNg

Example request (works in Swagger “Try it out”):
```json
{
  "Building_Type": "Residential",
  "Square_Footage": 1500,
  "Number_of_Occupants": 6,
  "Appliances_Used": 15,
  "Average_Temperature": 25.0,
  "Day_of_Week": "Weekday"
}
Response:
JSON{
  "predicted_energy_kwh": 28.47,
  "unit": "kWh",
  "model": "Random Forest (R² = 0.9813)",
  "status": "success"
}
How to Run the Mobile App
Option 1 – Fastest (for anyone, including lecturer)

Download the APK:
https://github.com/WagnerMushayija/summative-model/releases/download/v1.0/EnergyPredictor.apk
Install on any Android phone → open → fill the 6 fields → tap PREDICT → see your daily kWh forecast.

Option 2 – Run from source (developers)
Bashgit clone https://github.com/WagnerMushayija/summative-model.git
cd summative-model/flutter_app
flutter pub get
flutter run
Works on Android, iOS, Web, Windows, macOS, Linux.
Project Structure
summative model/
├── main.py                          ← FastAPI backend (live on Render)
├── models/
│   └── best_energy_model_correct.pkl ← Trained Random Forest model
├── flutter_app/                     ← Beautiful Flutter mobile app
├── notebook/                        ← Full EDA + training notebook
└── README.md                        ← This file
Valid Input Ranges (enforced by API + app)
FieldAllowed Values / RangeBuilding TypeAny text (e.g. Residential, Industrial)Square Footage500 – 100,000Number of Occupants1 – 1,000Appliances Used1 – 300Avg Temperature °C10.0 – 40.0Day of WeekWeekday / Weekend
Tech Stack

Python + FastAPI + Scikit-learn → Model & API
Render.com → Free public hosting
Flutter (Dart) → Cross-platform mobile app
GitHub → Source code & releases

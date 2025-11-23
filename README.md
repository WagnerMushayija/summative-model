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
```
Response:
``` JSON{
  "predicted_energy_kwh": 28.47,
  "unit": "kWh",
  "model": "Random Forest (R² = 0.9813)",
  "status": "success"
}
```
How to Run the Flutter App (Step-by-Step)

### Prerequisites
1. Install Flutter[](https://flutter.dev/docs/get-started/install)
2. Android Studio / VS Code + Flutter plugin (recommended)
3. A phone or emulator

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/WagnerMushyija/summative-model.git
   cd summative-model/flutter_app```

**Install dependencies
```Bash
flutter pub get```
Open the project
VS Code: code .
Or open the flutter_app folder in Android Studio

Make sure the API URL is correct
Open lib/main.dart and verify this line points to your live Render URL:Dartfinal String apiUrl = "https://summative-model.onrender.com/predict";
Run the app
```Bash
flutter run```
### Project Structure
```summative model/
├── main.py                          ← FastAPI backend (live on Render)
├── models/
│   └── best_energy_model_correct.pkl ← Trained Random Forest model
├── flutter_app/                     ← Beautiful Flutter mobile app
├── Linear_Regression/                        ← Full EDA + training notebook
└── README.md                        ← This file
```
Valid Input Ranges (enforced by API + app)
FieldAllowed Values / RangeBuilding TypeAny text (e.g. Residential, Industrial)Square Footage500 – 100,000Number of Occupants1 – 1,000Appliances Used1 – 300Avg Temperature °C10.0 – 40.0Day of WeekWeekday / Weekend
Tech Stack

Python + FastAPI + Scikit-learn → Model & API
Render.com → Free public hosting
Flutter (Dart) → Cross-platform mobile app
GitHub → Source code & releases

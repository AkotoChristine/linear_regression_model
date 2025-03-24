# Menstrual_Cycle_Prediction

# Mission 
The mission is focused on Women Empowerment. I aim to enhance reproductive health awareness, support wellness tracking, and provide actionable insights for better menstrual health management.This initiative seeks to foster wellness, reduce uncertainty, and support individuals in managing their health with confidence and convenience.
# DATASET 
The Dataset consist of the last period date, The cycle Lengh, the duration, next period date  and the symptoms of the individual 
**The Dataset was gotten on Kaggle**
# Deployed API 
https://linear-regression-model-1-jrla.onrender.com
TO GET THE SWAGGER UI, ADD */docs*

## link to Youtube Video
https://youtu.be/ZAgzvYZXXRE

Period Predictor App
A Flutter mobile application that predicts the next period dates for girls based on:
✅ Last Period Start Date
✅ Period Duration
✅ Cycle Length

Prerequisites
Ensure you have the following installed before running the application:

Flutter SDK → Install Flutter

Dart SDK (comes with Flutter)

Android Studio (for Android emulation)

Git → Install Git

Installation
1. Clone the Repository
bash
Copy
Edit
git clone https://github.com/AkotoChristine/linear_regression_model.git
cd linear_regression_model
2. Install Dependencies
Inside the project directory, run:

bash
Copy
Edit
flutter pub get
3. Add Dependencies to pubspec.yaml
yaml
Copy
Edit
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  intl: ^0.18.0
Folder Structure
bash
Copy
Edit
period_predictor/
│
├── lib/                # Main Flutter application files  
│   └── main.dart       # Entry point of the app  
│
├── android/            # Android-specific files  
│
├── ios/                # iOS-specific files  
│
├── assets/             # Images and other assets  
│
├── pubspec.yaml        # Configuration file  
│
└── README.md           # Documentation  
Running the Application
1. Start an Emulator or Connect a Device
Use Android Studio to launch an emulator or connect a physical device.

2. Run the App
bash
Copy
Edit
flutter run
3. Hot Reload (During Development)
Make changes and save to see updates instantly.

API Integration & Model Deployment
The app integrates with a deployed API to predict period dates. Ensure the API is running and accessible via a publicly routable URL, as required for testing on Swagger UI.

For more details on the API, refer to the /API/ directory in the repository.

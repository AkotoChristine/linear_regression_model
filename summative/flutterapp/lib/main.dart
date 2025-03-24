import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(PeriodPredictorApp());
}

class PeriodPredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      home: InputScreen(),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cycleLengthController = TextEditingController();
  final TextEditingController periodDurationController = TextEditingController();

  Future<void> predictNextPeriod(BuildContext context) async {
    final url = Uri.parse("https://linear-regression-model-1-jrla.onrender.com/predict");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "login_date": dateController.text,
          "cycle_length": int.tryParse(cycleLengthController.text) ?? 0,
          "period_duration": int.tryParse(periodDurationController.text) ?? 0,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        if (result.containsKey("predicted_next_period_date")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PredictionScreen(predictedDate: result["predicted_next_period_date"]),
            ),
          );
        } else {
          throw Exception("Unexpected response format: $result");
        }
      } else {
        throw Exception("Server Error: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Period Predictor", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(dateController, "Last Period Date", "YYYY-MM-DD"),
            SizedBox(height: 20),
            _buildInputField(cycleLengthController, "Cycle Length (days)", null, isNumeric: true),
            SizedBox(height: 20),
            _buildInputField(periodDurationController, "Period Duration (days)", null, isNumeric: true),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => predictNextPeriod(context),
              child: Text("Predict", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, String? hint, {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        fillColor: Colors.pink[50],
        filled: true,
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    );
  }
}

class PredictionScreen extends StatelessWidget {
  final String predictedDate;

  PredictionScreen({required this.predictedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction Result", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today, size: 80, color: Colors.pinkAccent),
              SizedBox(height: 20),
              Text(
                "Your Next Period is Expected On",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Card(
                elevation: 6,
                color: Colors.pink[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    predictedDate,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink[900]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text("Back", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

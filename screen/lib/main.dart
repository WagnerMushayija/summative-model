import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const EnergyPredictorApp());
}

class EnergyPredictorApp extends StatelessWidget {
  const EnergyPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Predictor',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PredictionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _result;

  final String apiUrl = "https://summative-model.onrender.com/predict";

  final Map<String, TextEditingController> _controllers = {
    'Building_Type': TextEditingController(
      text: 'Industrial',
    ), // Default values for easy testing
    'Square_Footage': TextEditingController(text: '40000'),
    'Number_of_Occupants': TextEditingController(text: '120'),
    'Appliances_Used': TextEditingController(text: '80'),
    'Average_Temperature': TextEditingController(text: '28.0'),
    'Day_of_Week': TextEditingController(text: 'Weekday'),
  };

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "Building_Type": _controllers['Building_Type']!.text,
          "Square_Footage": int.parse(_controllers['Square_Footage']!.text),
          "Number_of_Occupants": int.parse(
            _controllers['Number_of_Occupants']!.text,
          ),
          "Appliances_Used": int.parse(_controllers['Appliances_Used']!.text),
          "Average_Temperature": double.parse(
            _controllers['Average_Temperature']!.text,
          ),
          "Day_of_Week": _controllers['Day_of_Week']!.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _result =
              "Predicted: ${data['predicted_energy_kwh']} kWh\n(Model: ${data['model']})";
        });
      } else {
        setState(() {
          _result = "Error: ${response.statusCode} - ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Network Error: $e\n(Check API URL and connection)";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Energy Predictor'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Prevents overlapping on small screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Building Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildField(
                  'Building Type (e.g., Industrial)',
                  _controllers['Building_Type']!,
                  isNumber: false,
                ),
                _buildField(
                  'Square Footage (500-100000)',
                  _controllers['Square_Footage']!,
                  isNumber: true,
                ),
                _buildField(
                  'Number of Occupants (1-1000)',
                  _controllers['Number_of_Occupants']!,
                  isNumber: true,
                ),
                _buildField(
                  'Appliances Used (1-300)',
                  _controllers['Appliances_Used']!,
                  isNumber: true,
                ),
                _buildField(
                  'Average Temperature (10-40)',
                  _controllers['Average_Temperature']!,
                  isNumber: true,
                ),
                _buildField(
                  'Day of Week (Weekday/Weekend)',
                  _controllers['Day_of_Week']!,
                  isNumber: false,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _predict,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'PREDICT',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_result != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _result!.contains('Error')
                          ? Colors.red[50]
                          : Colors.green[50],
                      border: Border.all(
                        color: _result!.contains('Error')
                            ? Colors.red
                            : Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _result!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    required bool isNumber,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Required field';
          if (isNumber && double.tryParse(value) == null)
            return 'Enter a number';
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

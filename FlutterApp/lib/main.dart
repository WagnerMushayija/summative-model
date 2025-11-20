import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const EnergyPredictorApp());

class EnergyPredictorApp extends StatelessWidget {
  const EnergyPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // New Calm Color Palette
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFF10B981),
          background: const Color(0xFFF8F9FA),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1F2937)),
          bodyMedium: TextStyle(color: Color(0xFF4B5563)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: Color(0xFF4B5563)),
          prefixIconColor: const Color(0xFF9CA3AF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
          ),
        ),
      ),
      home: const PredictionScreen(),
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
  String? _modelInfo;

  final String apiUrl = "https://summative-model.onrender.com/predict";

  final Map<String, TextEditingController> _controllers = {
    'Building_Type': TextEditingController(text: 'Industrial'),
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
      _result = "⚡ Charging up the model...";
      _modelInfo = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "Building_Type": _controllers['Building_Type']!.text,
              "Square_Footage": int.parse(_controllers['Square_Footage']!.text),
              "Number_of_Occupants": int.parse(
                _controllers['Number_of_Occupants']!.text,
              ),
              "Appliances_Used": int.parse(
                _controllers['Appliances_Used']!.text,
              ),
              "Average_Temperature": double.parse(
                _controllers['Average_Temperature']!.text,
              ),
              "Day_of_Week": _controllers['Day_of_Week']!.text,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predicted = data['predicted_energy_kwh'];
        setState(() {
          _result = "⚡ $predicted kWh/day ⚡";
          _modelInfo = data['model'];
        });
      } else {
        setState(() {
          _result = "Server Error: ${response.statusCode}";
          _modelInfo = "Please check the server status and try again.";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Connection Error";
        _modelInfo = "Server might be waking up. Open /docs first then retry.";
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ), // Max width for larger screens
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // New Minimalist Title
                    const Text(
                      'Energy Predictor',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Estimate Daily Building Consumption',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 40),

                    // Input Fields remain logically the same, but styled by the new theme
                    _buildIconField(
                      Icons.business_outlined,
                      'Building Type',
                      _controllers['Building_Type']!,
                      false,
                    ),
                    _buildIconField(
                      Icons.space_dashboard_outlined,
                      'Square Footage (500–100000)',
                      _controllers['Square_Footage']!,
                      true,
                    ),
                    _buildIconField(
                      Icons.groups_outlined,
                      'Number of Occupants (1–1000)',
                      _controllers['Number_of_Occupants']!,
                      true,
                    ),
                    _buildIconField(
                      Icons.electrical_services_outlined,
                      'Appliances Used (1–300)',
                      _controllers['Appliances_Used']!,
                      true,
                    ),
                    _buildIconField(
                      Icons.thermostat_outlined,
                      'Avg Temperature (°C) (10.0–40.0)',
                      _controllers['Average_Temperature']!,
                      true,
                    ),
                    _buildIconField(
                      Icons.calendar_today_outlined,
                      'Day of Week (Weekday/Weekend)',
                      _controllers['Day_of_Week']!,
                      false,
                    ),

                    const SizedBox(height: 32),

                    // New Minimalist Predict Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _predict,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0, // A flatter, more modern look
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'PREDICT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // New Minimalist Result Card
                    if (_result != null)
                      _buildResultCard(
                        context: context,
                        result: _result!,
                        modelInfo: _modelInfo,
                        isError: _result!.toLowerCase().contains('error'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builder for the new result card widget
  Widget _buildResultCard({
    required BuildContext context,
    required String result,
    String? modelInfo,
    bool isError = false,
  }) {
    final successColor = Theme.of(context).colorScheme.secondary;
    final errorColor = Colors.red[600]!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isError
            ? errorColor.withOpacity(0.05)
            : successColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isError ? errorColor : successColor,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Text(
              isError ? 'Oops!' : 'Predicted Consumption',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: isError ? errorColor : successColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              result,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isError ? errorColor : const Color(0xFF111827),
              ),
              textAlign: TextAlign.center,
            ),
            if (modelInfo != null) ...[
              const SizedBox(height: 16),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                modelInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconField(
    IconData icon,
    String label,
    TextEditingController controller,
    bool isNumber,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        validator: (v) {
          if (v == null || v.isEmpty) return 'This field is required';
          if (isNumber && double.tryParse(v) == null)
            return 'Please enter a valid number';
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

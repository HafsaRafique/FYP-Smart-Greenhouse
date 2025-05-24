import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YieldPredictionScreen extends StatefulWidget {
  @override
  _YieldPredictionScreenState createState() => _YieldPredictionScreenState();
}

class _YieldPredictionScreenState extends State<YieldPredictionScreen> {
  final _formKeyTomato = GlobalKey<FormState>();
  final _formKeyLettuce = GlobalKey<FormState>();
  final _formKeyChilli = GlobalKey<FormState>();

  final Map<String, TextEditingController> _tomatoControllers = {
    "Tair": TextEditingController(),
    "Rhair": TextEditingController(),
    "CO2air": TextEditingController(),
    "co2_dos": TextEditingController(),
    "EC_drain_PC": TextEditingController(),
    "Tot_PAR": TextEditingController(),
    "Cum_irr": TextEditingController(),
    "Stem_thick": TextEditingController(),
    "Stem_elong": TextEditingController(),
  };

  final Map<String, TextEditingController> _lettuceControllers = {
    "Temperature (°C)": TextEditingController(),
    "Humidity (%)": TextEditingController(),
    "TDS Value (ppm)": TextEditingController(),
    "pH Level": TextEditingController(),
    "Temperature (F)": TextEditingController(),
    "Humidity": TextEditingController(),
  };

  final Map<String, TextEditingController> _chilliControllers = {
    "Humidity": TextEditingController(),
    "Temperature - (Celsius)": TextEditingController(),
    "Temperature_F": TextEditingController(),
    "Rainfall - (MM)": TextEditingController(),
  };

  String? _predictedTomatoYield;
  String? _predictedLettuceYield;
  String? _predictedChilliYield;

  Future<void> _predictYield(String crop) async {
    final formKey = crop == "Tomato"
        ? _formKeyTomato
        : crop == "Lettuce"
        ? _formKeyLettuce
        : _formKeyChilli;

    final controllers = crop == "Tomato"
        ? _tomatoControllers
        : crop == "Lettuce"
        ? _lettuceControllers
        : _chilliControllers;

    if (!formKey.currentState!.validate()) return;

    final urls = {
      "Tomato": "http://tomatoyield.hdgtc5ecdtd7a2ag.centralus.azurecontainer.io:5001/predict_tomyield",
      "Lettuce": "http://lettuceyield.dwe0aadeckc2f4fq.centralus.azurecontainer.io:5001/predict_lettyield",
      "Chilli": "http://chilliyield.a7dqbdcshncreedf.centralus.azurecontainer.io:5001/predict_chilliyield",
    };

    final url = Uri.parse(urls[crop]!);

    final dynamic requestBody = crop == "Lettuce"
        ? {
      "features": controllers.values
          .map((controller) => double.tryParse(controller.text) ?? 0.0)
          .toList(),
    }
        : controllers.map(
          (key, value) => MapEntry(key, double.tryParse(value.text) ?? 0.0),
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          if (crop == "Tomato") {
            _predictedTomatoYield = result['prediction'].toStringAsFixed(4);
          } else if (crop == "Lettuce") {
            _predictedLettuceYield = result['prediction'].toStringAsFixed(4);
          } else {
            _predictedChilliYield = result['prediction'].toStringAsFixed(4);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error predicting $crop yield')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    }
  }

  void _clearPrediction(String crop) {
    setState(() {
      if (crop == "Tomato") _predictedTomatoYield = null;
      if (crop == "Lettuce") _predictedLettuceYield = null;
      if (crop == "Chilli") _predictedChilliYield = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/back.png', fit: BoxFit.cover),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 10,
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/leaf.png',
                          height: 60,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Yield Prediction',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildPredictionButton("Tomato"),
                        SizedBox(height: 12),
                        _buildPredictionButton("Lettuce"),
                        SizedBox(height: 12),
                        _buildPredictionButton("Chilli"),
                        SizedBox(height: 30),
                        if (_predictedTomatoYield != null)
                          _buildPredictionSection("Tomato", _predictedTomatoYield!),
                        if (_predictedLettuceYield != null)
                          _buildPredictionSection("Lettuce", _predictedLettuceYield!),
                        if (_predictedChilliYield != null)
                          _buildPredictionSection("Chilli", _predictedChilliYield!),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  ElevatedButton _buildPredictionButton(String crop) {
    return ElevatedButton(
      onPressed: () => _showPredictionDialog(crop),
      child: Text(
        '$crop Yield Prediction',
        style: TextStyle(color: Colors.white), // Set text color to white
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        foregroundColor: Colors.white, // Ensures the text is white
      ),
    );
  }


  Widget _buildPredictionSection(String crop, String yield) {
    return Column(
      children: [
        Text(
          'Predicted $crop Yield: $yield',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => _clearPrediction(crop),
          child: Text('Clear'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  void _showPredictionDialog(String crop) {
    final formKey = crop == "Tomato"
        ? _formKeyTomato
        : crop == "Lettuce"
        ? _formKeyLettuce
        : _formKeyChilli;

    final controllers = crop == "Tomato"
        ? _tomatoControllers
        : crop == "Lettuce"
        ? _lettuceControllers
        : _chilliControllers;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$crop Yield Prediction', style: TextStyle(
          color: Colors.green,
        ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: controllers.keys.map((key) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: controllers[key],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: key,
                      labelStyle: TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter $key';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _predictYield(crop);
            },
            child: Text('Predict', style: TextStyle(
              color: Colors.white,
            ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
          ),
        ],
      ),
    );
  }
}

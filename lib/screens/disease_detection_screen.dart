import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:app/screens/fungal.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/main.dart';


class DiseaseDetectionScreen extends StatefulWidget {
  @override
  _DiseaseDetectionScreenState createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  List<Map<String, dynamic>> userPredictions = [];
  File? _imageFile;
  Uint8List? _webImage;
  final picker = ImagePicker();
  String _diseaseLabel = '';
  bool _showDetectButton = false;
  String _selectedCrop = 'Tomato';

  final Map<String, List<String>> cropLabels = {
    'Tomato': [
      'Bacterial spot',
      'Early blight',
      'Late blight',
      'Leaf Mold',
      'Septoria leaf spot',
      'Spider mites',
      'Target Spot',
      'Yellow Leaf Curl Virus',
      'Mosaic virus',
      'Healthy',
    ],
    'Chilli': [
      'Healthy',
      'Leaf Curl',
      'Leaf Spot',
      'White Fly',
      'Yellowish',
    ],
    'Lettuce': [
      'Bacterial',
      'Fungal',
      'Healthy',
    ],
    'Others/Objects':[],
  };

  final Map<String, String> cropEndpoints = {
    'Tomato': 'http://tomdisease.dhb0bgcch6fbg3cj.centralus.azurecontainer.io:5001/predict',
    'Chilli': 'http://chillidisease.ded7dqfbdyhfhzbn.centralus.azurecontainer.io:5001/predict_chilli',
    'Lettuce': 'http://lettucedisease.ewf9hhc9e5cgedbu.centralus.azurecontainer.io:5001/predict_lettdisease',
  };

  final Map<String, String> cropFieldNames = {
    'Tomato': 'file',
    'Chilli': 'file',
    'Lettuce': 'image',
  };

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = null;
          _showDetectButton = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected successfully')),
        );
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImage = null;
          _showDetectButton = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected successfully')),
        );
      }
    }
  }

  void _showInvalidImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Image'),
          content: Text('Upload leaf images in appropriate categories. Do not upload other objects.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _uploadImage() async {

    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload or capture an image')),
      );
      return;
    }

    final endpoint = cropEndpoints[_selectedCrop];
    final fieldName = cropFieldNames[_selectedCrop] ?? 'file';

    if (_selectedCrop == 'Others/Objects') {
      _showInvalidImageDialog();
      return;
    }
    if (endpoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No endpoint configured for $_selectedCrop')),
      );
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse(endpoint));

    if (!kIsWeb && _imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(fieldName, _imageFile!.path));
    } else if (kIsWeb && _webImage != null) {
      request.files.add(http.MultipartFile.fromBytes(fieldName, _webImage!, filename: 'image.jpg'));
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final result = json.decode(responseBody);

        if (_selectedCrop == 'Chilli') {
          final predictedClass = result['predicted_class'];
          if (predictedClass != null) {
            setState(() {
              _diseaseLabel = predictedClass;
              _showDetectButton = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Prediction for Chilli: $_diseaseLabel')),
            );
            _showDiseaseDetailsDialog(_diseaseLabel);
          } else {
            throw Exception('Missing predicted_class in Chilli response');
          }
        } else if (_selectedCrop == 'Lettuce') {
          final predictedClass = result['class'];
          if (predictedClass != null) {
            setState(() {
              _diseaseLabel = predictedClass;
              _showDetectButton = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Prediction for Lettuce: $_diseaseLabel')),
            );
            _showDiseaseDetailsDialog(_diseaseLabel);
          } else {
            throw Exception('Missing class in Lettuce response');
          }
        }
        else {
          final predictions = result['predictions']?[0];

          if (predictions is List) {
            final maxValue = predictions.reduce((a, b) => a > b ? a : b);
            final maxIndex = predictions.indexOf(maxValue);

            setState(() {
              _diseaseLabel = cropLabels[_selectedCrop]?[maxIndex] ?? 'Unknown disease';
              _showDetectButton = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Prediction for Tomato: $_diseaseLabel')),
            );
            _showDiseaseDetailsDialog(_diseaseLabel);
          } else {
            throw Exception('Invalid prediction format for Tomato');
          }
        }
      } else {
        throw Exception('Status Code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Detection failed: $e')),
      );
    }



    final predictionsBox = Hive.box('predictions');
    final currentUserBox = Hive.box('currentUser');
    final userEmail = currentUserBox.get('email');
    final imageBytes = _webImage ?? await _imageFile!.readAsBytes();

    final newPredictionMap = {
      'crop': _selectedCrop,
      'disease': _diseaseLabel,
      'image': imageBytes,
      'timestamp': DateTime.now().toIso8601String(),
    };

    List userPredictions = predictionsBox.get(userEmail, defaultValue: []);
    userPredictions.add(newPredictionMap);
    await predictionsBox.put(userEmail, userPredictions);

  }


  Widget _imagePreview() {
    if (_webImage != null) {
      return Image.memory(_webImage!, height: 200);
    } else if (_imageFile != null) {
      return Image.file(_imageFile!, height: 200);
    } else {
      return Container(
        height: 200,
        color: Colors.grey[200],
        child: Center(child: Text('No image selected')),
      );
    }
  }

  void _showDiseaseDetailsDialog(String disease) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'assets/place.png',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Disease Prediction',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          disease,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Would you like to know more about this disease?',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DiseaseInfoScreen(diseaseName: disease),
                                  ),
                                );
                              },
                              icon: Icon(Icons.check_circle_outline, color: Colors.white),
                              label: Text('Yes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.close),
                              label: Text('No'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )

              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Disease Detection',
            style: TextStyle(color: Colors.green, fontSize: 24),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'),
            fit: BoxFit.cover,
          ),
        ),


  child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add an image above the dropdown
                  Image.asset(
                    'assets/leaf.png', // Your image path
                    height: 50, // Set the size of the image
                  ),
                  const SizedBox(height: 20), // Add spacing between the image and dropdown

                  // Dropdown for selecting crop type
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: DropdownButton<String>(
                      value: _selectedCrop,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.green),
                      iconSize: 30,
                      isExpanded: true,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      underline: SizedBox(),
                      items: cropLabels.keys
                          .map((crop) => DropdownMenuItem(
                        value: crop,
                        child: Text(crop),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCrop = value!;
                          _diseaseLabel = '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  _imagePreview(),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: Icon(
                          Icons.photo,
                          color: Colors.green, // Set icon color to green
                        ),
                        label: Text(
                          'Gallery',
                          style: TextStyle(
                            color: Colors.green, // Set text color to green
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.green, // Set icon color to green
                        ),
                        label: Text(
                          'Camera',
                          style: TextStyle(
                            color: Colors.green, // Set text color to green
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_showDetectButton)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: _uploadImage,
                        child: Text('Detect Disease'),
                      ),
                    ),

                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.green),
                    title: const Text(
                      'Learn about all diseases',
                      style: TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DiseaseInfoPage()),
                      );
                    },
                  ),
                  if (_diseaseLabel.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Align items to the start
                      children: [
                        Text(
                          'Prediction: $_diseaseLabel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // ✅ Green text
                          ),
                        ),
                        SizedBox(height: 5), // Add space between prediction and button
                        TextButton(
                          onPressed: () {
                            // Clear the prediction when the button is pressed
                            setState(() {
                              _diseaseLabel = ''; // Reset the prediction
                              _showDetectButton = true; // Enable the detect button again
                            });
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class DiseaseInfoPage extends StatelessWidget {
  const DiseaseInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Information'),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionHeader('Tomato Diseases'),
              _diseaseCardList([
                _diseaseEntry('Bacterial Spot',
                    'Caused by Xanthomonas bacteria. Appears as small, dark, water-soaked spots.\nRemedy: Use copper-based fungicides, avoid overhead watering, and choose resistant varieties.'),
                _diseaseEntry('Early Blight',
                    'Fungal disease with concentric ring spots on older leaves.\nRemedy: Use fungicides like chlorothalonil, rotate crops, and remove infected leaves.'),
                _diseaseEntry('Late Blight',
                    'Causes large, dark blotches and white mold on leaves.\nRemedy: Use certified seeds, apply fungicides (e.g., mancozeb), and destroy infected plants.'),
                _diseaseEntry('Leaf Mold',
                    'Yellow spots on top, mold underneath.\nRemedy: Improve air circulation, use sulfur-based sprays, and avoid moisture on leaves.'),
                _diseaseEntry('Septoria Leaf Spot',
                    'Gray-centered black spots on leaves.\nRemedy: Apply fungicides, use drip irrigation, and practice crop rotation.'),
                _diseaseEntry('Spider Mites',
                    'Tiny pests causing stippling and bronzing of leaves.\nRemedy: Use insecticidal soap, neem oil, or introduce natural predators.'),
                _diseaseEntry('Target Spot',
                    'Concentric dark spots that enlarge.\nRemedy: Use resistant varieties and apply fungicides.'),
                _diseaseEntry('Yellow Leaf Curl Virus',
                    'Leads to yellowing and curling of leaves.\nRemedy: Control whiteflies, use reflective mulches, and plant virus-free seedlings.'),
                _diseaseEntry('Mosaic Virus',
                    'Causes mottled yellow/green patches.\nRemedy: Remove infected plants, control aphids, and sanitize tools.'),
                _diseaseEntry('Healthy',
                    'Plant is disease-free.\nMaintain by using clean tools, good soil, and balanced nutrients.'),
              ]),

              const SizedBox(height: 24),
              _sectionHeader('Chilli Diseases'),
              _diseaseCardList([
                _diseaseEntry('Healthy',
                    'No signs of disease.\nMaintain by watering properly and applying organic compost.'),
                _diseaseEntry('Leaf Curl',
                    'Leads to curling and distortion of leaves.\nRemedy: Control whiteflies/aphids, and use insecticides like imidacloprid.'),
                _diseaseEntry('Leaf Spot',
                    'Brown or black spots due to fungus/bacteria.\nRemedy: Use copper-based sprays, and avoid wetting foliage.'),
                _diseaseEntry('White Fly',
                    'Tiny insects feeding on sap.\nRemedy: Yellow sticky traps, neem oil spray, or insecticidal soap.'),
                _diseaseEntry('Yellowish',
                    'Yellowing due to stress or pests.\nRemedy: Check nutrients, improve drainage, and inspect for pests.'),
              ]),

              const SizedBox(height: 24),
              _sectionHeader('Lettuce Diseases'),
              _diseaseCardList([
                _diseaseEntry('Bacterial',
                    'Common types include soft rot and bacterial leaf spot.\nRemedy: Ensure proper drainage and avoid overhead irrigation.'),
                _diseaseEntry('Fungal',
                    'Includes downy and powdery mildew.\nRemedy: Use fungicides like mancozeb and rotate crops.'),
                _diseaseEntry('Healthy',
                    'Disease-free and vibrant growth.\nMaintain with proper spacing, watering, and pest control.'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

// ------------------- Helper Widgets -------------------
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: Colors.green.shade800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _diseaseCardList(List<Widget> entries) {
    return Column(children: entries);
  }

  Widget _diseaseEntry(String title, String description) {
    final parts = description.split('Remedy:');
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black),
            children: [
              TextSpan(text: parts[0]),
              if (parts.length > 1) ...[
                const TextSpan(
                  text: 'Remedy:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: parts[1]),
              ]
            ],
          ),
        ),
      ),
    );
  }
}




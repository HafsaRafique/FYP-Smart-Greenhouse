import 'package:flutter/material.dart';
import 'package:app/screens/disease_detection_screen.dart';

class DiseaseInfoPage extends StatelessWidget {
  final Map<String, List<String>> diseases = {
    'Tomato': [
      'Bacterial Spot',
      'Early Blight',
      'Late Blight',
      'Leaf Mold',
      'Septoria Leaf Spot',
      'Spider Mites',
      'Target Spot',
      'Yellow Leaf Curl Virus',
      'Mosaic Virus',
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
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Disease Information'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Tomato Diseases'),
            onTap: () => _showDiseaseDetails(context, 'Tomato'),
          ),
          ListTile(
            title: Text('Chilli Diseases'),
            onTap: () => _showDiseaseDetails(context, 'Chilli'),
          ),
          ListTile(
            title: Text('Lettuce Diseases'),
            onTap: () => _showDiseaseDetails(context, 'Lettuce'),
          ),
        ],
      ),
    );
  }

  void _showDiseaseDetails(BuildContext context, String crop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseDetailPage(crop: crop, diseases: diseases[crop]!),
      ),
    );
  }
}

class DiseaseDetailPage extends StatelessWidget {
  final String crop;
  final List<String> diseases;

  DiseaseDetailPage({required this.crop, required this.diseases});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$crop Diseases'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(diseases[index]),
            onTap: () => _showDiseaseInfo(context, diseases[index]),
          );
        },
      ),
    );
  }

  void _showDiseaseInfo(BuildContext context, String disease) {
    // Here you would usually provide more details about each disease
    // For now, we'll just show a basic description.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseInfoDetailPage(disease: disease),
      ),
    );
  }
}

class DiseaseInfoDetailPage extends StatelessWidget {
  final String disease;

  DiseaseInfoDetailPage({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disease),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Details about $disease:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'This is where you will display information about $disease.',
              style: TextStyle(fontSize: 16),
            ),
            // You can add more details here, like symptoms, prevention, treatment, etc.
          ],
        ),
      ),
    );
  }
}

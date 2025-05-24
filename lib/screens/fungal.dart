import 'package:flutter/material.dart';

class DiseaseInfoScreen extends StatelessWidget {
  final String diseaseName;

  DiseaseInfoScreen({required this.diseaseName});

  String getDiseaseImagePath(String disease) {
    switch (disease.toLowerCase()) {
      case 'fungal':
        return 'assets/fungal.jpg';
      case 'bacterial spot':
        return 'assets/bacterial-spot.jpg';
      case 'early blight':
        return 'assets/early-blight.jpg';
      case 'late blight':
        return 'assets/late-blight.jpg';
      case 'leaf mold':
        return 'assets/leaf-mold.jpg';
      case 'yellow leaf curl virus':
        return 'assets/yellow-leaf-curl.jpg';
      case 'septoria leaf spot':
        return 'assets/septoria.jpg';
      case 'spider mites':
        return 'assets/spidermites.jpg';
      case 'target spot':
        return 'assets/targetspot.jpg';
      case 'mosaic virus':
        return 'assets/mosaicvirus.jpg';
      case 'leaf curl':
        return 'assets/leaf-curl.jpg';
      case 'white fly':
        return 'assets/white-fly.jpg';
      case 'leaf spot':
        return 'assets/leaf-spot.jpg';
      case 'healthy':
        return 'assets/healthy.jpg';
      default:
        return 'assets/placeholder.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    String diseaseExplanation = '';
    String diseaseRemedies = '';

    switch (diseaseName.toLowerCase()) {
    // Lettuce
      case 'fungal':
        diseaseExplanation = '''
Fungal diseases in lettuce, such as downy mildew and powdery mildew, are caused by fungi thriving in damp and humid environments. Symptoms include yellowing or browning of leaves, moldy patches on the underside of the leaf, and overall plant wilting. They usually appear when plants are overcrowded or overwatered.
''';
        diseaseRemedies = '''
- Improve air circulation by spacing out plants properly.
- Water plants at the base in the early morning to allow drying.
- Remove and destroy infected leaves or plants.
- Apply organic or chemical fungicides recommended for lettuce.
- Avoid excessive nitrogen fertilizers.
- Rotate crops to prevent buildup of fungal spores in the soil.
''';
        break;

      case 'bacterial spot':
        diseaseExplanation = '''
Caused by the bacterium *Xanthomonas campestris*, this disease results in small, dark, water-soaked spots on leaves that may enlarge and merge. The disease spreads through water splashes, contaminated tools, and infected seeds. It thrives in warm, humid environments.
''';
        diseaseRemedies = '''
- Use certified disease-free seeds.
- Avoid overhead irrigation that can spread bacteria.
- Remove and dispose of infected plant debris.
- Disinfect tools regularly.
- Use copper-based bactericides as a preventive measure.
- Practice proper crop rotation and field sanitation.
''';
        break;

    // Tomato
      case 'early blight':
        diseaseExplanation = '''
Early blight is caused by *Alternaria solani*, a fungus that affects tomato leaves, stems, and fruits. It starts with concentric dark spots on lower leaves, which then turn yellow and fall off. This weakens the plant and reduces yield.
''';
        diseaseRemedies = '''
- Remove infected lower leaves early in the season.
- Apply fungicides like chlorothalonil or mancozeb.
- Use drip irrigation to keep leaves dry.
- Mulch soil to prevent fungal spores from splashing up.
- Practice crop rotation and proper spacing for airflow.
''';
        break;

      case 'late blight':
        diseaseExplanation = '''
Late blight, caused by *Phytophthora infestans*, spreads rapidly in cool, wet weather. It appears as large, dark, greasy-looking spots on leaves and stems, and can destroy an entire tomato crop in a matter of days.
''';
        diseaseRemedies = '''
- Remove and burn infected plants immediately.
- Apply copper-based or systemic fungicides before rain.
- Avoid watering at night to reduce moisture.
- Ensure proper spacing for ventilation and quick drying.
- Use resistant tomato varieties.
''';
        break;

      case 'leaf mold':
        diseaseExplanation = '''
Leaf mold, caused by *Fulvia fulva*, primarily affects older tomato leaves. It presents as yellow spots on the upper surface and grayish-white to olive mold on the underside, especially in high humidity or poorly ventilated greenhouses.
''';
        diseaseRemedies = '''
- Ensure good air circulation inside greenhouses.
- Water in the early morning and avoid leaf wetting.
- Remove affected foliage and improve air exchange.
- Apply recommended fungicides such as mancozeb.
- Sterilize greenhouse structures regularly.
''';
        break;

      case 'yellow leaf curl virus':
        diseaseExplanation = '''
This virus is transmitted by whiteflies and causes symptoms like yellowing, upward curling of leaves, stunted plant growth, and flower drop, leading to poor fruit development.
''';
        diseaseRemedies = '''
- Install yellow sticky traps to reduce whitefly population.
- Spray neem oil or insecticides to manage whiteflies.
- Remove and destroy infected plants early.
- Use virus-resistant tomato varieties.
- Use row covers in early stages to prevent infection.
''';
        break;

      case 'septoria leaf spot':
        diseaseExplanation = '''
Septoria leaf spot is a fungal disease caused by *Septoria lycopersici*. It appears as numerous small, round spots with dark brown borders and grayish centers on lower, older leaves. As the disease progresses, leaves turn yellow, wither, and fall off, reducing photosynthesis and fruit quality.
''';
        diseaseRemedies = '''
- Remove and destroy infected leaves early.
- Avoid overhead watering to keep foliage dry.
- Apply fungicides such as copper-based products or chlorothalonil.
- Provide good air circulation with proper spacing and pruning.
- Rotate crops and avoid planting tomatoes in the same spot each year.
''';
        break;

      case 'spider mites':
        diseaseExplanation = '''
Spider mites are tiny arachnids that feed on plant sap, commonly attacking the undersides of tomato leaves. Infestations cause yellow speckling, webbing, and eventual leaf drop. Severe damage can weaken the plant and reduce fruit production.
''';
        diseaseRemedies = '''
- Spray plants with a strong stream of water to dislodge mites.
- Use insecticidal soap or neem oil to control populations.
- Introduce natural predators like ladybugs or predatory mites.
- Remove heavily infested leaves to slow spread.
- Avoid excess nitrogen fertilization, which promotes tender growth that attracts mites.
''';
        break;

      case 'target spot':
        diseaseExplanation = '''
Target spot is caused by the fungus *Corynespora cassiicola*. It produces circular, brown lesions with concentric rings on tomato leaves, stems, and fruits. Infected leaves turn yellow and drop prematurely, reducing plant vigor and yield.
''';
        diseaseRemedies = '''
- Remove and destroy infected plant parts.
- Apply fungicides such as chlorothalonil or mancozeb.
- Ensure proper plant spacing and pruning to increase air circulation.
- Use drip irrigation to avoid wetting the foliage.
- Practice crop rotation and clean up plant debris at season end.
''';
        break;
      case 'mosaic virus':
        diseaseExplanation = '''
Mosaic virus is a viral disease that causes mottled light and dark green or yellow patterns on tomato leaves. Infected plants may show stunted growth, leaf curling, and reduced fruit yield and quality. It spreads through contaminated tools, insect vectors (like aphids), and infected seeds.
''';
        diseaseRemedies = '''
- Remove and destroy infected plants immediately.
- Control aphids and other insect vectors using insecticidal soap or neem oil.
- Disinfect tools and hands regularly when working with plants.
- Avoid using seeds from infected plants.
- Choose resistant tomato varieties and maintain good garden hygiene.
''';
        break;


    // Chilli
      case 'leaf curl':
        diseaseExplanation = '''
Leaf curl in chilli is caused by viruses spread by whiteflies or thrips. Infected plants show distorted and curled leaves, stunted growth, and decreased fruit yield.
''';
        diseaseRemedies = '''
- Spray insecticides or neem oil to control vector insects.
- Remove and destroy infected plants immediately.
- Use virus-resistant chilli cultivars.
- Implement crop rotation and field sanitation.
''';
        break;

      case 'white fly':
        diseaseExplanation = '''
Whiteflies are small, flying insects that feed on plant sap and secrete honeydew, leading to sooty mold. They are vectors for several plant viruses, making them dangerous pests in chilli farming.
''';
        diseaseRemedies = '''
- Use yellow sticky traps to monitor and control population.
- Spray neem oil or insecticidal soap regularly.
- Encourage natural predators like ladybugs and lacewings.
- Apply systemic insecticides if infestation is high.
''';
        break;

      case 'leaf spot':
        diseaseExplanation = '''
Leaf spot in chilli can be caused by both fungi and bacteria, resulting in circular, dark brown or black lesions on leaves. Severe infections lead to leaf drop and yield loss.
''';
        diseaseRemedies = '''
- Avoid overhead watering to reduce moisture on leaves.
- Remove infected leaves and avoid handling wet plants.
- Apply copper-based or other recommended fungicides.
- Ensure proper plant spacing to increase air movement.
''';
        break;

      case 'healthy':
        diseaseExplanation = 'The plant appears healthy with no signs of disease or pest infestation.';
        diseaseRemedies = 'No action is required. Maintain regular monitoring and proper care.';
        break;

      default:
        diseaseExplanation = 'No specific data available for the selected disease.';
        diseaseRemedies = 'Consult an expert or local extension service for guidance.';
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Info'),
        backgroundColor: Colors.green.shade700,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100), // For shadow shape consistency
                ),
                child: ClipOval(
                  child: Image.asset(
                    getDiseaseImagePath(diseaseName),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Text(
                diseaseName.toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  color: Colors.green.shade800,
                  fontFamily: 'Montserrat', // Optional: Add a stylish font

                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Explanation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(diseaseExplanation, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 16),
                    Text(
                      "🌿 Remedies",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(diseaseRemedies, style: TextStyle(fontSize: 16)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

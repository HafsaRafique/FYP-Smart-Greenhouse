import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/screens/welcome_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/disease_detection_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/screens/sign_up_screen.dart';
import 'package:app/screens/splash_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  // Register the adapter

  // Initialize Hive for local storage
  await Hive.initFlutter();

  await Hive.openBox('users'); // User authentication box
  await Hive.openBox('currentUser'); // Store logged-in user info
  await Hive.openBox('predictions');
  final predictionsBox = Hive.box('predictions');
  final currentUserBox = Hive.box('currentUser');
  final userEmail = currentUserBox.get('email');


  runApp(PlantDiseaseDetectionApp());
}

class PlantDiseaseDetectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Disease Detection',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF2E7D32, {
          50: Color(0xFFE8F5E9),
          100: Color(0xFFC8E6C9),
          200: Color(0xFFA5D6A7),
          300: Color(0xFF81C784),
          400: Color(0xFF66BB6A),
          500: Color(0xFF2E7D32),
          600: Color(0xFF43A047),
          700: Color(0xFF388E3C),
          800: Color(0xFF2E7D32),
          900: Color(0xFF1B5E20),
        }),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeScreen(),
        '/disease-detection': (context) => DiseaseDetectionScreen(),
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) => SignUpScreen(),
      },
    );
  }
}

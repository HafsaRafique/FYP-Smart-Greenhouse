import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E9),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Text(
                'Grow better plants today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 20), // Space between text and image
              Image.asset(
                'assets/plant.png', // Ensure this file exists in your assets folder
                height: 100, // Adjust as needed
              ),
              SizedBox(height: 40), // Space between image and buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/sign-in'),
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Color(0xFFFFFFFF)), // Set the text color to green
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Color(0xFF2E7D32), // Set the background color to white
                        foregroundColor: Color(0xFF2E7D32), // Set the text color to green
                        side: BorderSide(color: Color(0xFF2E7D32), width: 1), // Optional: Set border color to green
                      ),
                    ),
                    SizedBox(height: 15),
                    OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/sign-up'),
                      child: Text(
                        'Create An Account',
                        style: TextStyle(color: Color(0xFF2E7D32)),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        side: BorderSide(color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

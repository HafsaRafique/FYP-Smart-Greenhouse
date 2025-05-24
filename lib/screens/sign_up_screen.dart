import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  static const String _userBoxName = 'users';

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final userBox = await Hive.openBox(_userBoxName);

    // Basic validations
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      throw Exception('All fields are required.');
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      throw Exception('Invalid email format.');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }

    // Check if email already exists - fixed implementation
    bool userExists = false;
    for (var key in userBox.keys) {
      dynamic userData = userBox.get(key);
      if (userData is Map && userData['email'] == email) {
        userExists = true;
        break;
      }
    }

    if (userExists) {
      return false;
    }

    // Hash and save
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    final newUser = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': hashedPassword,
    };

    await userBox.put(newUser['id'], newUser);
    return true;
  }

  // You might want to add a sign-in method too
  Future<Map<String, dynamic>?> signIn({
    required String email,
    required String password,
  }) async {
    final userBox = await Hive.openBox(_userBoxName);
    final hashedPassword = sha256.convert(utf8.encode(password)).toString();

    for (var key in userBox.keys) {
      dynamic userData = userBox.get(key);
      if (userData is Map &&
          userData['email'] == email &&
          userData['password'] == hashedPassword) {
        return Map<String, dynamic>.from(userData);
      }
    }

    return null;
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  void _handleSignUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      // Just redirect to the sign-in page if the fields are empty (No error message)
      Navigator.pushReplacementNamed(context, '/sign-in');
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      // Just redirect to the sign-in page if the email is invalid (No error message)
      Navigator.pushReplacementNamed(context, '/sign-in');
      return;
    }

    if (password.length < 6) {
      // Just redirect to the sign-in page if the password is too short (No error message)
      Navigator.pushReplacementNamed(context, '/sign-in');
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Directly redirect to the sign-in page if the email already exists
        Navigator.pushReplacementNamed(context, '/sign-in');
      }
    } catch (e) {
      setState(() => _isLoading = false);

      // Just redirect to the sign-in page on error (No error message)
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E7D32),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Sign Up',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person, color: Color(
                            0xFF2E7D32)),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF2E7D32)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, color: Color(0xFF2E7D32)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF2E7D32),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: Color(0xFF2E7D32),
                        ),
                        Text('Remember me'),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Sign Up', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/sign-in'),
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: Color(0xFF2E7D32)),
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
      ),
    );
  }
}

// Initialize Hive in main.dart
void initializeHive() async {
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox('currentUser');
}

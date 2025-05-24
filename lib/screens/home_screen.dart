import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:app/screens/yield_prediction_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // No longer switching to profile drawer via bottom nav
    setState(() {
      _selectedIndex = index;
    });
  }
  List<Map> _predictions = [];

  @override
  void initState() {
    super.initState();
    _loadPredictions();
  }

  void _loadPredictions() {
    final box = Hive.box('predictions');
    final currentUserBox = Hive.box('currentUser');
    final userEmail = currentUserBox.get('email');
    final items = box.get(userEmail, defaultValue: []);
    setState(() {
      _predictions = List<Map>.from(items);
    });
  }


  @override
  Widget build(BuildContext context) {
    var currentUserBox = Hive.box('currentUser');
    final username = currentUserBox.get('name', defaultValue: 'User');
    final email = currentUserBox.get('email', defaultValue: 'user@example.com');

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF2E7D32),
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: DrawerHeader(
                padding: EdgeInsets.zero,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40, color: Color(0xFF2E7D32)),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              username,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await Hive.box('currentUser').clear();
                Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (_) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title: Text('Clear All Predictions', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final predictionsBox = Hive.box('predictions');
                final currentUserBox = Hive.box('currentUser');
                final userEmail = currentUserBox.get('email');
                await predictionsBox.put(userEmail, []);
                _loadPredictions();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Predictions cleared.')),
                );
              },
            ),
            Expanded(
              child: _predictions.isEmpty
                  ? Center(child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('No predictions yet.'),
              ))
                  : ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _predictions.length,
                itemBuilder: (_, index) {
                  final item = _predictions[_predictions.length - 1 - index]; // latest first
                  final imageBytes = item['image'] as Uint8List;
                  final crop = item['crop'] ?? 'Unknown';
                  final disease = item['disease'] ?? 'Unknown';
                  final rawTimestamp = item['timestamp'] as String;
                  final formattedTimestamp = DateFormat('MMMM d, y – h:mm a')
                      .format(DateTime.parse(rawTimestamp));

                  return ListTile(
                    leading: Image.memory(imageBytes, width: 40, height: 40, fit: BoxFit.cover),
                    title: Text('$crop: $disease', style: TextStyle(fontSize: 14)),
                    subtitle: Text(formattedTimestamp, style: TextStyle(fontSize: 12)),
                    dense: true,
                  );
                },
              ),
            )

          ],
        ),

      ),

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.png'), // Your image path here
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'What do you want to do today?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/leaf.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 30),
                OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/disease-detection'),
                  child: Text(
                    'Disease Detection',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF2E7D32)),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YieldPredictionScreen()),
                  ),
                  child: Text(
                    'Yield Estimation',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF2E7D32)),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

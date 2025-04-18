import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class GarageDashboard extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Garage Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Garage Dashboard',
              style: TextStyle(fontSize: 24),
            ),
            // Add more garage-specific widgets here
          ],
        ),
      ),
    );
  }
}

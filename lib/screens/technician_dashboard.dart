import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class TechnicianDashboard extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technician Dashboard'),
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
              'Welcome to Technician Dashboard',
              style: TextStyle(fontSize: 24),
            ),
            // Add more technician-specific widgets here
          ],
        ),
      ),
    );
  }
}

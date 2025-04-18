import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Information Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('John Doe'),
                        subtitle: Text('Name'),
                      ),
                      ListTile(
                        leading: Icon(Icons.directions_car),
                        title: Text('Mercedes Benz'),
                        subtitle: Text('Car Name'),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('123, Downtown Avenue, NY'),
                        subtitle: Text('Address'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('+1234567890'),
                        subtitle: Text('Mobile No.'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Booking History Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking History',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Booking Detail 1
                      Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/car_photo.jpg', // Replace with your image asset
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'WashWise Car Wash',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Date: 19/09/2023'),
                                  const Text('Time: 20:00'),
                                  const Text('Location: Nearby Wash Service'),
                                  const SizedBox(height: 16),
                                  // Booking image or related information
                                  Center(
                                    child: Image.asset(
                                      'assets/car_photo.jpg', // Replace with another image asset
                                      height: 60,
                                      width: 60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Add more booking details as needed.
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

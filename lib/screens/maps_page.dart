import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LatLng? userLocation; // Variable to hold user's real-time location

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearest Car Washers'),
        backgroundColor: Colors.blueAccent,
      ),
      body: userLocation == null
          ? const Center(
              child: CircularProgressIndicator()) // Show loader until location is fetched
          : FlutterMap(
              options: MapOptions(
                center: userLocation ??
                    LatLng(19.1602,
                        77.3149), // Default center Nanded, if location isn't available
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _buildMarkers(context),
                ),
              ],
            ),
    );
  }

  List<Marker> _buildMarkers(BuildContext context) {
    return [
      Marker(
        width: 50.0,
        height: 50.0,
        point: userLocation ??
            LatLng(19.1602, 77.3149), // User's location or default Nanded
        builder: (ctx) => const Icon(
          Icons.my_location,
          color: Colors.red,
          size: 30.0,
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(19.1565, 77.3057),
        builder: (ctx) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MarkerDetailsPage(
                  name: "Sparkle Car Wash",
                  address: "Near Gandhi Chowk, Nanded",
                  price: 300,
                  services: ["Foam Wash", "Interior Cleaning", "Polishing"],
                  offers: "10% off for first-time customers!",
                  contact: "9876543210",
                ),
              ),
            );
          },
          child: const Icon(
            Icons.local_car_wash,
            color: Colors.blue,
            size: 40.0,
          ),
        ),
      ),
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(19.1677, 77.3204),
        builder: (ctx) => GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MarkerDetailsPage(
                  name: "Shiny Wheels Service",
                  address: "Opposite Railway Station, Nanded",
                  price: 350,
                  services: ["Vacuum Cleaning", "Underbody Wash", "Engine Detailing"],
                  offers: "Free polishing with full wash package!",
                  contact: "9123456789",
                ),
              ),
            );
          },
          child: const Icon(
            Icons.local_car_wash,
            color: Colors.blue,
            size: 40.0,
          ),
        ),
      ),
    ];
  }
}

class MarkerDetailsPage extends StatelessWidget {
  final String name;
  final String address;
  final int price;
  final List<String> services;
  final String offers;
  final String contact;

  const MarkerDetailsPage({
    Key? key,
    required this.name,
    required this.address,
    required this.price,
    required this.services,
    required this.offers,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Address: $address",
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Foam-Based Car Wash Price: ₹$price",
                        style: const TextStyle(fontSize: 18.0, color: Colors.green),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Services Offered:",
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      ...services.map((service) => Text(
                          "- $service",
                          style: const TextStyle(fontSize: 16.0))),
                      const SizedBox(height: 10.0),
                      Text(
                        "Current Offers: $offers",
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.blue),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        "Contact: $contact",
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Booking Confirmed"),
                        content: Text(
                            "You have booked $name for a foam-based car wash."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Book Now"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 15.0),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

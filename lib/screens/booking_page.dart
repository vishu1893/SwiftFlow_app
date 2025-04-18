import 'package:flutter/material.dart';
import 'maps_page.dart'; // Import the MapsPage

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends State<BookingPage> {
  String selectedService = 'Deluxe Wash'; // Default selected service
  DateTime? selectedDate;
  String selectedTimeSlot = '';
  List<String> selectedAdditionalServices = [];
  String selectedPaymentMethod = 'Credit Card';
  int totalCost = 250;

  final services = {
    'Basic Wash': 100,
    'Deluxe Wash': 200,
    'Premium Wash': 300,
  };

  final additionalServices = {
    'Interior Cleaning': 250,
    'Tire Shine': 30,
    'Underbody Wash': 70,
  };

  void updateTotalCost() {
    int baseCost = services[selectedService] ?? 0;
    int additionalCost = selectedAdditionalServices.fold(
      0,
      (sum, service) => sum + (additionalServices[service] ?? 0),
    );
    setState(() {
      totalCost = baseCost + additionalCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Car Wash Service
            const Text(
              'Select Car Wash Service',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: services.keys.map((service) {
                return RadioListTile(
                  title: Text('$service - ${services[service]}rs'),
                  value: service,
                  groupValue: selectedService,
                  onChanged: (value) {
                    setState(() {
                      selectedService = value.toString();
                      updateTotalCost();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Select Date
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2025),
                );
                setState(() {
                  selectedDate = pickedDate;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  selectedDate == null
                      ? 'YYYY-MM-DD'
                      : '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Select Time Slot
            const Text(
              'Select Time Slot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 10,
              children: [
                '10:00 AM',
                '11:00 AM',
                '12:00 PM',
                '01:00 PM',
                '03:00 PM'
              ].map((timeSlot) {
                return ChoiceChip(
                  label: Text(timeSlot),
                  selected: selectedTimeSlot == timeSlot,
                  onSelected: (selected) {
                    setState(() {
                      selectedTimeSlot = selected ? timeSlot : '';
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Additional Services
            const Text(
              'Additional Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: additionalServices.keys.map((service) {
                return CheckboxListTile(
                  title: Text('$service - ${additionalServices[service]}rs'),
                  value: selectedAdditionalServices.contains(service),
                  onChanged: (selected) {
                    setState(() {
                      if (selected!) {
                        selectedAdditionalServices.add(service);
                      } else {
                        selectedAdditionalServices.remove(service);
                      }
                      updateTotalCost();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Payment Method
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: ['Credit Card', 'PayPal', 'Cash'].map((paymentMethod) {
                return RadioListTile(
                  title: Text(paymentMethod),
                  value: paymentMethod,
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value.toString();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Booking Summary
            const Text(
              'Booking Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service: $selectedService'),
                  Text(
                      'Date: ${selectedDate != null ? selectedDate!.toString().split(' ')[0] : 'Not selected'}'),
                  Text('Time: $selectedTimeSlot'),
                  Text(
                      'Additional Services: ${selectedAdditionalServices.isNotEmpty ? selectedAdditionalServices.join(', ') : 'None'}'),
                  Text('Payment Method: $selectedPaymentMethod'),
                  const SizedBox(height: 8),
                  Text('Total: $totalCost rs'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Booking Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Button background color
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                onPressed: () {
                  // Navigate to MapsPage on button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapsPage()),
                  );
                },
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

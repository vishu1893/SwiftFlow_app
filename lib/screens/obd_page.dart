import 'package:flutter/material.dart';
import 'package:lagguu/screens/obd_scanner_page.dart'; // OBDScannerPage is used from here

class ObdReportPage extends StatelessWidget {
  const ObdReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD Report'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OBD-II Diagnostic Analysis Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Detailed diagnostics of your vehicle are shown below. Review the error codes, system status, and recommended actions.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Vehicle Information
            _buildReportSection(
              title: 'Vehicle Information',
              content: [
                'Make/Model: Toyota Corolla',
                'Year: 2024',
                'Engine Type: 1.8L 4-cylinder',
                'VIN: JTNBK3DE8K0123456',
                'Mileage: 72,500 miles',
              ],
            ),

            // Scan Summary
            _buildReportSection(
              title: 'Scan Summary',
              content: [
                'Total DTCs (Diagnostic Trouble Codes): 2',
                'Emission Readiness Status: Not Ready',
                'Freeze Frame Data: Captured for P0420',
              ],
            ),

            // Diagnostic Trouble Codes
            _buildReportSection(
              title: 'Diagnostic Trouble Codes (DTCs)',
              content: [
                '1. P0420 - Catalyst System Efficiency Below Threshold (Bank 1):',
                '   - Description: The catalytic converter is not performing as efficiently as expected.',
                '   - Potential Causes:',
                '     • Faulty catalytic converter',
                '     • Oxygen sensor failure',
                '     • Exhaust leak',
                '     • Engine misfire or fuel mixture issues',
                '2. P0302 - Cylinder 2 Misfire Detected:',
                '   - Description: Misfire detected in cylinder 2.',
                '   - Potential Causes:',
                '     • Faulty spark plug or ignition coil',
                '     • Vacuum leak near cylinder 2',
                '     • Fuel injector issues',
                '     • Compression loss',
              ],
            ),

            // Live Sensor Data
            _buildReportSection(
              title: 'Live Sensor Data',
              content: [
                'Engine RPM: 720 rpm (Idle)',
                'Engine Coolant Temperature: 88°C (190°F)',
                'Vehicle Speed: 0 mph (Idle)',
                'Throttle Position Sensor: 9.8%',
                'Fuel System Status: Closed Loop',
                'Short Term Fuel Trim (STFT): 4.2%',
                'Long Term Fuel Trim (LTFT): 6.5%',
                'Intake Air Temperature: 32°C (89.6°F)',
                'Mass Air Flow Rate: 2.8 g/s',
                'Oxygen Sensor Voltage (O2): 0.75 V (Bank 1)',
              ],
            ),

            // Emission Readiness Monitor
            _buildReportSection(
              title: 'Emission Readiness Monitor',
              content: [
                'Misfire: Complete',
                'Fuel System: Complete',
                'Comprehensive Components: Complete',
                'Catalyst: Incomplete',
                'Heated Catalyst: N/A',
                'Evaporative System: Complete',
                'Secondary Air System: N/A',
                'Oxygen Sensor: Complete',
                'Oxygen Sensor Heater: Complete',
                'EGR System: N/A',
              ],
            ),

            // Freeze Frame Data
            _buildReportSection(
              title: 'Freeze Frame Data (P0420)',
              content: [
                'Engine RPM: 2450 rpm',
                'Vehicle Speed: 45 mph',
                'Short Term Fuel Trim: 3.8%',
                'Long Term Fuel Trim: 5.1%',
                'Oxygen Sensor Voltage (B1S1): 0.68 V',
                'Catalyst Temperature: 590°C (1094°F)',
              ],
            ),

            const SizedBox(height: 20), // Space before the button

            // Start OBD Scanning Button
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bluetooth_searching),
                label: const Text('Start OBD Scanning'),
                onPressed: () {
                  // Navigate to OBDScannerPage when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OBDScannerPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build sections with title and list of contents
  Widget _buildReportSection(
      {required String title, required List<String> content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...content
              .map((item) => Text(item, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

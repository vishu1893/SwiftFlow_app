import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // FlutterBluePlus for BLE
import 'dart:convert'; // Import this for utf8
import 'package:permission_handler/permission_handler.dart'; // Permissions

class OBDScannerPage extends StatefulWidget {
  const OBDScannerPage({super.key});

  @override
  _OBDScannerPageState createState() => _OBDScannerPageState();
}

class _OBDScannerPageState extends State<OBDScannerPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResultList = [];
  bool _isScanning = false;
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    initBle();
  }

  // Request necessary permissions
  Future<void> requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  // Initialize Bluetooth scanning
  void initBle() {
    FlutterBluePlus.isScanning.listen((isScanning) {
      setState(() {
        _isScanning = isScanning;
      });
    });
  }

  // Scan for BLE devices
  void scanForDevices() async {
    if (!_isScanning) {
      setState(() {
        scanResultList.clear(); // Clear the list before starting a new scan
      });

      try {
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
        FlutterBluePlus.scanResults.listen((results) {
          setState(() {
            if (results.isEmpty) {
              print("No devices found");
            } else {
              scanResultList = results; // Update UI with results
            }
          });
        });
      } catch (e) {
        print("Error starting BLE scan: $e");
      }
    } else {
      await FlutterBluePlus.stopScan();
    }
  }

  // Connect to the selected Bluetooth device
  void connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      setState(() {
        connectedDevice = device;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OBDScreen(device: device),
        ),
      );
    } catch (e) {
      print("Error connecting to device: $e");
    }
  }

  // Widget to build each list item for a scanned BLE device
  Widget listItem(ScanResult result) {
    return ListTile(
      title: Text(result.device.name.isNotEmpty
          ? result.device.name
          : 'Unknown Device'),
      subtitle: Text(result.device.id.toString()),
      trailing: Text(result.rssi.toString()), // RSSI (signal strength)
      onTap: () {
        connectToDevice(result.device);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OBD-II Scanner'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bluetooth Device Scanning Section
          Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Bluetooth Devices',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(_isScanning ? Icons.stop : Icons.search),
                  label:
                      Text(_isScanning ? 'Stop Scanning' : 'Scan for Devices'),
                  onPressed: scanForDevices,
                ),
                scanResultList.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('No Devices Found'),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: scanResultList.length,
                        itemBuilder: (context, index) {
                          return listItem(scanResultList[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OBDScreen extends StatefulWidget {
  final BluetoothDevice device;

  const OBDScreen({required this.device, super.key});

  @override
  _OBDScreenState createState() => _OBDScreenState();
}

class _OBDScreenState extends State<OBDScreen> {
  BluetoothCharacteristic? obdCharacteristic;
  String vehicleSpeed = 'N/A';
  String rpm = 'N/A';

  @override
  void initState() {
    super.initState();
    connectToOBD();
  }

  // Discover services and characteristics from the connected device
  Future<void> connectToOBD() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write &&
            characteristic.properties.notify) {
          obdCharacteristic = characteristic;
          await characteristic.setNotifyValue(true);

          // Using the stream API to listen for characteristic updates
          characteristic.lastValueStream.listen((value) {
            processOBDResponse(value);
          });
          break;
        }
      }
    }
  }

  // Send OBD command to the vehicle
  void sendOBDCommand(String command) async {
    if (obdCharacteristic != null) {
      List<int> commandBytes = utf8.encode('$command\r'); // Uses utf8 encoding
      await obdCharacteristic!.write(commandBytes);
    }
  }

  // Process OBD response and update data
  void processOBDResponse(List<int> response) {
    String hexString =
        response.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

    // Processing vehicle speed (PID 010D)
    if (hexString.contains('41') && hexString.contains('0D')) {
      int speed = int.parse(hexString.substring(6, 8), radix: 16);
      setState(() {
        vehicleSpeed = '$speed km/h';
      });
    }

    // Processing RPM (PID 010C)
    if (hexString.contains('41') && hexString.contains('0C')) {
      int rpmValue = (int.parse(hexString.substring(6, 8), radix: 16) * 256 +
              int.parse(hexString.substring(8, 10), radix: 16)) ~/
          4;
      setState(() {
        rpm = '$rpmValue RPM';
      });
    }
  }

  void getVehicleSpeed() {
    sendOBDCommand('010D'); // OBD-II command for vehicle speed
  }

  void getRPM() {
    sendOBDCommand('010C'); // OBD-II command for RPM
  }

  Widget obdDataSection(
      String title, String value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OBD-II: ${widget.device.name}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          obdDataSection(
              'Vehicle Speed', vehicleSpeed, Icons.speed, Colors.blue),
          obdDataSection('RPM', rpm, Icons.dialpad, Colors.green),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: getVehicleSpeed,
            child: const Text('Get Vehicle Speed'),
          ),
          ElevatedButton(
            onPressed: getRPM,
            child: const Text('Get RPM'),
          ),
        ],
      ),
    );
  }
}

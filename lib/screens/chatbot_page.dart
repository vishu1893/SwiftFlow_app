import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

void main() => runApp(const ChatBotApp());

class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatBotScreen(),
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final List<types.Message> _messages = [];
  final types.User _user = const types.User(id: 'user');
  final types.User _bot = const types.User(id: 'bot');
  final _uuid = const Uuid();
  bool _isCollectingDetails = false;
  Map<String, String> userDetails = {};

  // Predefined Question-Answer Set
  final Map<String, String> _qaSet = {
    // General Maintenance
    'oil change': 'Oil changes are recommended every 5,000 kilometers or 3 months. You can book an appointment in the "Services" section.',
    'engine check': 'Engine diagnostics are essential for performance. Please visit the "Diagnostics" section to book a check-up.',
    'tire replacement': 'Tire replacement should be done every 40,000 kilometers or when the tread is worn. Check the "Tire Services" section for options.',
    'brake issues': 'Brake problems can be serious! 🛑 Visit the "Diagnostics" section to book a brake inspection.',
    'battery issue': 'Battery issues? 🔋 Check out our battery testing and replacement services in the "Battery Services" section.',
    'car servicing': 'General servicing ensures your car runs smoothly. Book an appointment under the "Service Booking" section.',
    'air filter replacement': 'It is recommended to replace your air filter every 12,000 kilometers for clean airflow in the engine.',
    'wheel alignment': 'Wheel alignment improves handling and prevents uneven tire wear. Book an alignment in the "Tire Services" section.',

    // Emergency Assistance
    'flat tire': 'For flat tires, check the "Roadside Assistance" option or visit the nearest service center.',
    'engine warning light': 'An engine warning light indicates a potential issue. Please visit the "Diagnostics" section immediately.',
    'car won\'t start': 'If your car won’t start, check the battery and ignition system. Need help? Contact "Roadside Assistance".',
    'overheating engine': 'An overheating engine is often caused by coolant issues. Let the engine cool and check the coolant level.',
    'low fuel efficiency': 'Low fuel efficiency can be caused by dirty air filters, old spark plugs, or incorrect tire pressure. Check our maintenance tips in the app.',

    // Car Systems
    'air conditioning issue': 'Air conditioning not working? Visit our "AC Services" for inspection and repairs.',
    'headlights not working': 'Headlights or taillights not working? Book a bulb replacement or electrical diagnostics in the app.',
    'strange noise': 'Hearing strange noises? It could be brakes, suspension, or engine issues. Visit the "Diagnostics" section for help.',
    'suspension problem': 'Suspension issues can affect driving comfort and safety. Book a suspension inspection today.',

    // Tips and Advice
    'service reminder': 'You can enable service reminders in the "Settings" to ensure your car is always maintained on time.',
    'winter tires': 'Winter tires improve grip and handling in snowy conditions. Check our "Tire Services" for winter tire options.',
    'summer car care': 'For summer, ensure your AC works well, fluids are topped up, and tires are properly inflated.',
    'fuel saving tips': 'Fuel-saving tips: Maintain correct tire pressure, avoid sudden acceleration, and schedule regular car maintenance.',
    'car cleaning': 'For car cleaning, visit the "Car Wash" section or try our premium detailing services.',

    // Help and Assistance
    'contact support': 'For further assistance, please contact our customer support through the "Contact Us" section.',
    'roadside assistance': 'Need immediate help? Use the "Roadside Assistance" option for flat tires, battery jump-starts, or towing services.',
    'booking service': 'To book any car service, go to the "Service Booking" section in the app.',
    'nearest service center': 'Find the nearest service center in the "Locations" section of the app.',
    'help': 'I can help you with:\n1. Oil Change\n2. Brake Issues\n3. Battery Problems\n4. Flat Tires\n5. Engine Diagnostics\n6. Car Cleaning\nType any of these for more details.',
  };

  @override
  void initState() {
    super.initState();
    _addBotMessage('Welcome to Car Services Bot! 🚗\nHow can I assist you today?');
  }

  void _addMessage(String text, types.User author) {
    final message = types.TextMessage(
      author: author,
      id: _uuid.v4(),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: text,
    );

    setState(() {
      _messages.insert(0, message);
    });
  }

  void _addBotMessage(String text) {
    _addMessage(text, _bot);
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    _addMessage(message.text, _user);
    await Future.delayed(const Duration(seconds: 1)); // Simulate processing delay

    // Check if bot should collect user details or provide an answer
    if (_isCollectingDetails) {
      await _collectUserDetails(message.text);
    } else {
      // Search for a response in the predefined Q&A set
      final response = _getBotResponse(message.text);
      _addBotMessage(response);
    }
  }

  Future<void> _collectUserDetails(String userResponse) async {
    if (userDetails.isEmpty) {
      setState(() {
        userDetails['address'] = userResponse;
      });
      _addBotMessage('Please provide the preferred date and time for the car wash appointment.');
    } else if (userDetails.length == 1) {
      setState(() {
        userDetails['date_time'] = userResponse;
      });
      _addBotMessage('Please select the type of service (e.g., steam car wash, OBD analysis).');
    } else if (userDetails.length == 2) {
      setState(() {
        userDetails['service_type'] = userResponse;
      });
      _addBotMessage('Please provide the payment mode (e.g., Credit, Debit, Cash).');
    } else if (userDetails.length == 3) {
      setState(() {
        userDetails['payment_mode'] = userResponse;
      });
      _addBotMessage('Your details have been saved. Your car wash appointment is scheduled! 🚗');
      _isCollectingDetails = false;
    }
  }

  String _getBotResponse(String userMessage) {
    String response = "I'm sorry, I didn't understand that. 🤔 Please try again or type 'help' for options.";

    // Check if user input matches a key in the Q&A set
    _qaSet.forEach((key, value) {
      if (userMessage.toLowerCase().contains(key)) {
        response = value;
      }
    });

    // Start the process of collecting details if the message is related to scheduling
    if (userMessage.toLowerCase().contains('book') || userMessage.toLowerCase().contains('schedule')) {
      _isCollectingDetails = true;
      response = 'I can help you schedule a car wash! Let me collect some details first.';
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Services Chatbot'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}

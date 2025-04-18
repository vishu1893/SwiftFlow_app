import 'package:flutter/material.dart';
import 'package:lagguu/main.dart';
import '../services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String email = '';
  String password = '';
  String name = '';
  String phoneNumber = '';
  String selectedRole = 'User';
  Map<String, String> additionalFields = {};
  bool isLoading = false;
  String error = '';

  final List<String> roles = ['User', 'Garage', 'Special Agent'];

  List<Widget> _buildAdditionalFields() {
    List<Widget> fields = [];

    if (selectedRole == 'Garage') {
      fields.addAll([
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Garage Name',
            border: OutlineInputBorder(),
          ),
          validator: (val) => val!.isEmpty ? 'Enter garage name' : null,
          onChanged: (val) => additionalFields['garageName'] = val,
        ),
        SizedBox(height: 20.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
          ),
          validator: (val) => val!.isEmpty ? 'Enter address' : null,
          onChanged: (val) => additionalFields['address'] = val,
        ),
        SizedBox(height: 20.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Services Offered',
            border: OutlineInputBorder(),
          ),
          validator: (val) => val!.isEmpty ? 'Enter services offered' : null,
          onChanged: (val) => additionalFields['services'] = val,
        ),
      ]);
    } else if (selectedRole == 'Special Agent') {
      fields.addAll([
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Experience (years)',
            border: OutlineInputBorder(),
          ),
          validator: (val) => val!.isEmpty ? 'Enter experience' : null,
          onChanged: (val) => additionalFields['experience'] = val,
        ),
        SizedBox(height: 20.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Certifications',
            border: OutlineInputBorder(),
          ),
          validator: (val) => val!.isEmpty ? 'Enter certifications' : null,
          onChanged: (val) => additionalFields['certifications'] = val,
        ),
        SizedBox(height: 20.0),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Skills',
            border: OutlineInputBorder(),
          ),
          validator: (val) => val!.isEmpty ? 'Enter skills' : null,
          onChanged: (val) => additionalFields['skills'] = val,
        ),
      ]);
    }

    return fields;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                value: selectedRole,
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value.toString();
                    additionalFields.clear();
                  });
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Enter your name' : null,
                onChanged: (val) {
                  setState(() => name = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Enter phone number' : null,
                onChanged: (val) {
                  setState(() => phoneNumber = val);
                },
              ),
              SizedBox(height: 20.0),
              ..._buildAdditionalFields(),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Register'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() => isLoading = true);
                    try {
                      Map<String, dynamic> userData = {
                        'name': name,
                        'phoneNumber': phoneNumber,
                        ...additionalFields,
                      };

                      final result = await _auth.registerWithEmailAndPassword(
                          email, password, selectedRole, userData);
                      if (result != null) {
                        Navigator.pushReplacementNamed(context,
                            '/${selectedRole.toLowerCase()}_dashboard');
                      }
                    } catch (e) {
                      setState(() {
                        error = e.toString();
                        isLoading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              TextButton(
                child: Text('Already have an account? Login'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

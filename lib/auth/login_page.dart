import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:health_care_app/services/permit_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      String userId;
      Map<String, dynamic> userAttributes;

      // Define different user profiles with appropriate attributes
      if (_usernameController.text.toLowerCase() == 'doctor') {
        userId = 'doctor-123';
        userAttributes = {
          'role': 'Doctor',
          'department': 'Cardiology',
          'hasSpecialAccess': true,
          'id': 'doctor-123',
        };
      } else if (_usernameController.text.toLowerCase() == 'nurse') {
        userId = 'nurse-456';
        userAttributes = {
          'role': 'Nurse',
          'department': 'Emergency',
          'hasSpecialAccess': false,
          'id': 'nurse-456',
        };
      } else if (_usernameController.text.toLowerCase() == 'patient') {
        userId = 'patient-789';
        userAttributes = {
          'role': 'Patient',
          'id': 'patient-789',
          'hasSpecialAccess': false,
          'department': null,
        };
      } else {
        userId = 'admin-101';
        userAttributes = {
          'role': 'Admin',
          'department': 'IT',
          'hasSpecialAccess': true,
          'id': 'admin-101',
        };
      }

      // Sync user with Permit.io
      final success = await PermitService.syncUser(userId, userAttributes);

      if (success) {
        // Store user info locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('userAttributes', json.encode(userAttributes));

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) =>
                    HomePage(userId: userId, userAttributes: userAttributes),
          ),
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('userAttributes', json.encode(userAttributes));

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) =>
                    HomePage(userId: userId, userAttributes: userAttributes),
          ),
        );
        setState(() {
          _errorMessage = 'Failed to sync user with Permit.io';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HealthSecure ABAC Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Login to HealthSecure Portal',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Try: doctor, nurse, patient, or admin',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Any password will work for demo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('LOGIN'),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'This demo showcases ABAC with Permit.io\n'
                  'Try different users to see different permissions',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

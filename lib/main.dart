import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:health_care_app/auth/auth_wrapper.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const PermitApp());
}

class PermitApp extends StatelessWidget {
  const PermitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthSecure ABAC Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthWrapper(),
    );
  }
}

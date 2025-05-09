import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:health_care_app/auth/login_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/home_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false;
  bool isLoading = true;
  String? userId;
  Map<String, dynamic>? userAttributes;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('userId');
    final storedAttributes = prefs.getString('userAttributes');

    if (storedUserId != null && storedAttributes != null) {
      setState(() {
        isLoggedIn = true;
        userId = storedUserId;
        userAttributes = json.decode(storedAttributes);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }
    return isLoggedIn
        ? HomePage(userId: userId!, userAttributes: userAttributes!)
        : const LoginPage();
  }
}

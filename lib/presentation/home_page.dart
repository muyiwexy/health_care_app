import 'package:flutter/material.dart';
import 'package:health_care_app/auth/login_page.dart';
import 'package:health_care_app/models/medical_record.dart';
import 'package:health_care_app/services/permit_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/medical_record_service.dart';
import 'widget/medical_record_list.dart';
import 'widget/user_profile_card.dart';

/// Main home page of the application showing user info and medical records
/// with attribute-based access control (ABAC)
class HomePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userAttributes;

  const HomePage({
    super.key,
    required this.userId,
    required this.userAttributes,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  List<MedicalRecord> _medicalRecords = [];

  @override
  void initState() {
    super.initState();
    _loadMedicalRecords();
  }

  /// Load and check permissions for all medical records
  Future<void> _loadMedicalRecords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get mock records from MedicalRecordService
      final allRecords = await MedicalRecordService.getMockRecords();
      print(allRecords.length);
      // For each record, check if current user has permission to access it
      List<MedicalRecord> accessibleRecords = [];

      for (var record in allRecords) {
        final hasAccess = await PermitService.checkMedicalRecordAccess(
          widget.userId,
          'read',
          'medicalRecord',
          record,
          widget.userAttributes,
        );

        // Mark record with access status
        record.hasAccess = hasAccess;
        accessibleRecords.add(record);
      }

      setState(() {
        _medicalRecords = accessibleRecords;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading records: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Handle user sign out
  Future<void> _signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  /// Display a dialog showing all user attributes
  void _showUserAttributes() {
    showDialog(
      context: context,
      builder:
          (context) =>
              UserAttributesDialog(userAttributes: widget.userAttributes),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthSecure ABAC Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showUserAttributes,
            tooltip: 'View User Attributes',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User profile info card
                    UserProfileCard(
                      userId: widget.userId,
                      userAttributes: widget.userAttributes,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Medical Records (ABAC Protected)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Access based on: User role, department, record sensitivity, patient ownership, and more',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    // List of medical records with access controls
                    Expanded(
                      child: MedicalRecordsList(
                        records: _medicalRecords,
                        userId: widget.userId,
                        userAttributes: widget.userAttributes,
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}

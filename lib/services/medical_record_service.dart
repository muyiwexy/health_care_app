import 'package:flutter/material.dart';
import 'package:health_care_app/models/medical_record.dart';

/// Service class to handle fetching and managing medical records
class MedicalRecordService {
  /// Get a list of mock medical records
  /// In a real app, this would fetch from an API or database
  static Future<List<MedicalRecord>> getMockRecords() async {
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock list of medical records with varying sensitivity levels
    return [
      MedicalRecord(
        id: 'rec-001',
        patientId: 'patient-789',
        department: 'Cardiology',
        sensitivity: 'normal',
        title: 'Annual Checkup',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      MedicalRecord(
        id: 'rec-002',
        patientId: 'patient-456',
        department: 'Cardiology',
        sensitivity: 'sensitive',
        title: 'Heart Surgery Follow-up',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      MedicalRecord(
        id: 'rec-003',
        patientId: 'patient-123',
        department: 'Emergency',
        sensitivity: 'highly-sensitive',
        title: 'Emergency Treatment',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      MedicalRecord(
        id: 'rec-004',
        patientId: 'patient-123',
        department: 'Emergency',
        sensitivity: 'sensitive',
        title: 'Emergency Treatment',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      MedicalRecord(
        id: 'rec-005',
        patientId: 'patient-123',
        department: 'Emergency',
        sensitivity: 'normal',
        title: 'Emergency Treatment',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      MedicalRecord(
        id: 'rec-005',
        patientId: 'patient-789',
        department: 'Psychiatry',
        sensitivity: 'highly-sensitive',
        title: 'Therapy Session Notes',
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
      ),
    ];
  }

  /// Determine if a record is considered "old" and requires special access
  /// Currently defined as older than 1 year
  static bool isOldRecord(MedicalRecord record) {
    return record.createdAt.isBefore(
      DateTime.now().subtract(const Duration(days: 365)),
    );
  }

  /// Get appropriate color for the sensitivity level of a record
  static Color getSensitivityColor(String sensitivity) {
    switch (sensitivity) {
      case 'normal':
        return Colors.green;
      case 'sensitive':
        return Colors.orange;
      case 'highly-sensitive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:health_care_app/models/medical_record.dart';
import 'package:health_care_app/services/medical_record_service.dart';
import 'package:intl/intl.dart';

import 'record_detail_dialog.dart';

/// Widget for displaying a list of medical records with access controls
class MedicalRecordsList extends StatelessWidget {
  final List<MedicalRecord> records;
  final String userId;
  final Map<String, dynamic> userAttributes;

  const MedicalRecordsList({
    super.key,
    required this.records,
    required this.userId,
    required this.userAttributes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];

        // Determine access status display information
        AccessStatus accessStatus;
        if (!record.hasAccess) {
          accessStatus = AccessStatus(
            color: Colors.red,
            icon: Icons.lock,
            text: 'Access Denied',
          );
        } else {
          accessStatus = AccessStatus(
            color: Colors.green,
            icon: Icons.check_circle,
            text: 'Access Granted',
          );
        }

        return Card(
          elevation: 2,
          child: ListTile(
            leading: Icon(
              Icons.folder,
              color: MedicalRecordService.getSensitivityColor(
                record.sensitivity,
              ),
            ),
            title: Text(record.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Department: ${record.department}'),
                Text('Sensitivity: ${record.sensitivity}'),
                Text(
                  'Created: ${DateFormat('MMM d, yyyy').format(record.createdAt)}',
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      accessStatus.icon,
                      size: 14,
                      color: accessStatus.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      accessStatus.text,
                      style: TextStyle(color: accessStatus.color, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () => _handleRecordTap(context, record),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  /// Handle tapping on a medical record
  /// Shows details if user has access, or handles special access for old records
  void _handleRecordTap(BuildContext context, MedicalRecord record) {
    // Show record details (or access denied message)
    _showRecordDetails(context, record);
  }

  /// Show record details if user has access
  void _showRecordDetails(BuildContext context, MedicalRecord record) {
    if (!record.hasAccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Access denied: You do not have permission to view this record',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => RecordDetailDialog(record: record),
    );
  }
}

/// Helper class to store access status information
class AccessStatus {
  final Color color;
  final IconData icon;
  final String text;

  AccessStatus({required this.color, required this.icon, required this.text});
}

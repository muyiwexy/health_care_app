import 'package:flutter/material.dart';
import 'package:health_care_app/models/medical_record.dart';
import 'package:intl/intl.dart';

/// Dialog that displays detailed information about a medical record
class RecordDetailDialog extends StatelessWidget {
  final MedicalRecord record;

  const RecordDetailDialog({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(record.title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Record ID: ${record.id}'),
            const SizedBox(height: 8),
            Text('Patient ID: ${record.patientId}'),
            const SizedBox(height: 8),
            Text('Department: ${record.department}'),
            const SizedBox(height: 8),
            Text('Sensitivity: ${record.sensitivity}'),
            const SizedBox(height: 8),
            Text(
              'Created: ${DateFormat('MMM d, yyyy').format(record.createdAt)}',
            ),
            const SizedBox(height: 16),
            const Text(
              'Sample medical record content. In a real application, this would contain actual medical data.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CLOSE'),
        ),
      ],
    );
  }
}

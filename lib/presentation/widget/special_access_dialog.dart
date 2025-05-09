import 'package:flutter/material.dart';
import 'package:health_care_app/models/medical_record.dart';
import 'package:health_care_app/services/permit_service.dart';

/// Dialog for requesting special access to old medical records
/// Requires user to enter a reason for accessing records older than 1 year
class SpecialAccessDialog extends StatefulWidget {
  final MedicalRecord record;
  final String userId;
  final Map<String, dynamic> userAttributes;
  final VoidCallback onAccessGranted;

  const SpecialAccessDialog({
    super.key,
    required this.record,
    required this.userId,
    required this.userAttributes,
    required this.onAccessGranted,
  });

  @override
  State<SpecialAccessDialog> createState() => _SpecialAccessDialogState();
}

class _SpecialAccessDialogState extends State<SpecialAccessDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isRequestingAccess = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  /// Request special access with the provided reason
  Future<void> _requestAccess() async {
    final reason = _reasonController.text;

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reason is required for special access'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isRequestingAccess = true;
    });

    try {
      // Check access with the provided reason
      final hasAccess = await PermitService.checkMedicalRecordAccess(
        widget.userId,
        'read',
        'medicalRecord',
        widget.record,
        widget.userAttributes,
        {'accessReason': reason},
      );

      if (hasAccess) {
        widget.record.hasAccess = true;
        widget.onAccessGranted();
      } else {
        if (!mounted) return;

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Special access denied'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRequestingAccess = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Request Special Access'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'This record is older than 1 year and requires special access approval.',
            style: TextStyle(color: Colors.orange),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: 'Access Reason',
              hintText: 'Enter reason for accessing this old record',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
            enabled: !_isRequestingAccess,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed:
              _isRequestingAccess ? null : () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: _isRequestingAccess ? null : _requestAccess,
          child:
              _isRequestingAccess
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('REQUEST ACCESS'),
        ),
      ],
    );
  }
}

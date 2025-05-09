import 'package:flutter/material.dart';

/// Widget that displays the user's profile information
class UserProfileCard extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> userAttributes;

  const UserProfileCard({
    super.key,
    required this.userId,
    required this.userAttributes,
  });

  @override
  Widget build(BuildContext context) {
    final roleName = userAttributes['role'] as String;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roleName == 'Doctor'
                  ? 'Welcome, Dr. ${userAttributes['department']}!'
                  : 'Welcome, $roleName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'User ID: $userId',
              style: const TextStyle(color: Colors.grey),
            ),
            if (userAttributes['department'] != null) ...[
              const SizedBox(height: 4),
              Text(
                'Department: ${userAttributes['department']}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Dialog that displays all user attributes
class UserAttributesDialog extends StatelessWidget {
  final Map<String, dynamic> userAttributes;

  const UserAttributesDialog({super.key, required this.userAttributes});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('User Attributes'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children:
              userAttributes.entries.map((entry) {
                return ListTile(
                  title: Text('${entry.key}:'),
                  subtitle: Text('${entry.value}'),
                );
              }).toList(),
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

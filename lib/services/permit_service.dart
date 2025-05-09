import 'dart:convert';
import 'package:health_care_app/models/medical_record.dart';
import 'package:http/http.dart' as http;

class PermitService {
  static const String apiKey =
      'permit_key_evWaCnIsRIpOarPQzfO9D06iz7EZSsKKUtqyCebDkU0VfSVFRsJNCk5fJ4xqE960ErMePTcnSdpHt9tuF2LJj4';

  static const String baseUrl = 'http://172.20.10.2:7766';

  static Map<String, String> _getHeaders() {
    return {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }

  // Sync user with Permit.io
  static Future<bool> syncUser(
    String userId,
    Map<String, dynamic> attributes,
  ) async {
    try {
      final url = '$baseUrl/facts/users';

      final userData = {
        'key': userId,
        'email': '$userId@example.com',
        'first_name': attributes['role'],
        'last_name': 'User',
        'attributes': attributes,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: json.encode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to sync user: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error syncing user: $e');
      return false;
    }
  }

  // Advanced permission check for medical records with ABAC attributes
  static Future<bool> checkMedicalRecordAccess(
    String userId,
    String action,
    String resourceType,
    MedicalRecord record,
    Map<String, dynamic> userAttributes,
    Map<String, dynamic> contextAttributes,
  ) async {
    try {
      final url = '$baseUrl/allowed';

      // Build check data with all ABAC attributes
      final checkData = {
        'user': {'key': userId},
        'action': action,
        'resource': {'type': resourceType, 'attributes': record.toAttributes()},
      };
      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: json.encode(checkData),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        return data['allow'] == true;
      } else {
        print('Medical record access check failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error checking medical record access: $e');
      return false;
    }
  }
}

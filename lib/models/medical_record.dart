class MedicalRecord {
  final String id;
  final String patientId;
  final String department;
  final String sensitivity;
  final String title;
  final DateTime createdAt;
  bool hasAccess;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.department,
    required this.sensitivity,
    required this.title,
    required this.createdAt,
    this.hasAccess = false,
  });

  Map<String, dynamic> toAttributes() {
    return {
      'patientId': patientId,
      'department': department,
      'sensitivity': sensitivity,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

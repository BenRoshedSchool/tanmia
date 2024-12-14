import 'package:floor/floor.dart';

class UserInfo {
  final dynamic? id1;
  final dynamic? id2;
  final dynamic? name1;
  final dynamic? name2;
  final dynamic? notes;
  final dynamic? numberOfFamily;
  final dynamic? originalResidence;
  final dynamic? primery_key;
  final dynamic? residenceStatus;
  dynamic receiving_status;
  final dynamic? shelter;
  final dynamic? status;
  final dynamic? mobile;

  UserInfo({
    required this.id1,
    required this.id2,
    required this.name1,
    required this.name2,
    required this.notes,
    required this.numberOfFamily,
    required this.originalResidence,
    required this.primery_key,
    required this.residenceStatus,
    required this.shelter,
    required this.status,
    required this.mobile,
    this.receiving_status = ""
  });

  // Factory method to create a UserInfo instance from a JSON map
  factory UserInfo.fromJson(Map<dynamic, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return UserInfo(
      id1: parseInt(json['id1']) ?? 0, // Parse and default to 0 if null or invalid
      id2: parseInt(json['id2']) ?? 0,
      name1: json['name1'] ?? '', // Default to empty string if null
      name2: json['name2'] ?? '',
      notes: json['notes'] ?? '',
      numberOfFamily: parseInt(json['number_of_family']) ?? 0,
      originalResidence: json['original_residence'] ?? '',
      primery_key: json['primery_key'] ?? '',
      residenceStatus: json['residence_status']?.trim() ?? '',
      shelter: json['shelter'] ?? '',
      status: json['status'] ?? '',
      mobile: parseInt(json['mobile']) ?? 0,
      receiving_status: json["receiving_status"] ?? ""
    );
  }

  // Method to convert UserInfo instance to a JSON map
  Map<dynamic, dynamic> toJson() {
    return {
      'id1': id1,
      'id2': id2,
      'name1': name1,
      'name2': name2,
      'notes': notes,
      'number_of_family': numberOfFamily,
      'original_residence': originalResidence,
      'primery_key': primery_key,
      'residence_status': residenceStatus,
      'shelter': shelter,
      'status': status,
      'mobile': mobile,
      "receiving_status" : receiving_status
    };
  }
}

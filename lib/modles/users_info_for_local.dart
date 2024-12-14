import 'package:floor/floor.dart';

@entity
class UserInfoForlocal {
  @PrimaryKey(autoGenerate: true)
  final int? i;
  final int? id1;
  final int? id2;
  final String? name1;
  final String? name2;
  final String? notes;
  final int? numberOfFamily;
  final String? originalResidence;
  final String? primery_key;
  final String? residenceStatus;
  final String? receiving_status;
  final String? shelter;
  final String? status;
  final int? mobile;

  UserInfoForlocal({
    this.i,
    this.id1,
    this.id2,
    this.name1,
    this.name2,
    this.notes,
    this.numberOfFamily,
    this.originalResidence,
    this.primery_key,
    this.residenceStatus,
    this.shelter,
    this.status,
    this.mobile,
    this.receiving_status = "",
  });

  // Factory method to create a UserInfo instance from a JSON map
  factory UserInfoForlocal.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return UserInfoForlocal(
        id1: parseInt(json['id1']) ?? 0,
        id2: parseInt(json['id2']) ?? 0,
        name1: json['name1'] ?? '',
        name2: json['name2'] ?? '',
        notes: json['notes'] ?? '',
        numberOfFamily: parseInt(json['number_of_family']) ?? 0,
        originalResidence: json['original_residence'] ?? '',
        primery_key: json['primery_key'] ?? '',
        residenceStatus: json['residence_status']?.trim() ?? '',
        shelter: json['shelter'] ?? '',
        status: json['status'] ?? '',
        mobile: parseInt(json['mobile']) ?? 0,
    );
  }

  // Method to convert UserInfo instance to a JSON map
  Map<String, dynamic> toJson() {
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
    };
  }
}

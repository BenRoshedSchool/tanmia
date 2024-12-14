import 'package:floor/floor.dart';

class ChildrenInfo {
  final dynamic? parentId;
  final dynamic? parentName;
  final dynamic? numberOfChildren;
  final dynamic? primery_key;
  final dynamic? shelter;
  final List<Children>? listChildren;


  ChildrenInfo({
    required this.parentId,
    required this.parentName,
    required this.numberOfChildren,
    required this.primery_key,
    required this.shelter,
    required this.listChildren,

  });

  // Factory method to create a UserInfo instance from a JSON map
  factory ChildrenInfo.fromJson(Map<dynamic, dynamic> json) {
    int? parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return ChildrenInfo(
      parentId: parseInt(json['parentId']) ?? 0,
      parentName: json['parentName'] ?? '',
      primery_key: json['primery_key'] ?? '',
      shelter: json['shelter'] ?? '',
      listChildren: (json['listChildren'] as List<dynamic>?)
          ?.map((childJson) => Children.fromJson(childJson))
          .toList(),
      numberOfChildren: parseInt(json['numberOfChildren']) ?? 0,
    );
  }

  // Method to convert UserInfo instance to a JSON map
  Map<dynamic, dynamic> toJson() {
    return {
      'parentId': parentId,
      'parentName': parentName,
      'numberOfChildren': numberOfChildren,
      'primery_key': primery_key,
      'shelter': shelter,
      'listChildren': listChildren?.map((child) => child.toJson()).toList(),
    };
  }

}


class Children {
  final String name;
  final String id;
  final String primeryKey;
  final String bdate;
  final String eage;

  Children({required this.name, required this.id, required this.primeryKey , required this.bdate , required this.eage});

  // Convert a Children instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'bdate': bdate,
      'primeryKey': primeryKey,
      'eage': eage,
    };
  }

  // Create a Children instance from a JSON map
  factory Children.fromJson(Map<String, dynamic> json) {
    return Children(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      bdate: json['bdate'] ?? '',
      primeryKey: json['primeryKey'] ?? '',
      eage: json['eage'] ?? '',
    );
  }
}


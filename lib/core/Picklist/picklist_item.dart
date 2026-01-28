
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
class PicklistType {
  static const gender = 'GENDER';
  static const bloodGroup = 'BLOOD_GROUP';
  static const maritalStatus = 'MARITAL_STATUS';
}
class PicklistItem {
  final String id;
  final String name;
  final String typeId;
  final bool isActive;
  final int order;

  PicklistItem({
    required this.id,
    required this.name,
    required this.typeId,
    this.isActive = true,
    this.order = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'typeId': typeId,
      'isActive': isActive,
      'order': order,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory PicklistItem.fromJSON(Map<String, dynamic> json) {
    return PicklistItem(
      id: parseString(data: json['id'], defaultValue: ""),
      name: parseString(data: json['name'], defaultValue: ""),
      typeId: parseString(data: json['typeId'], defaultValue: ""),
      order: parseInt(data: json['order'], defaultInt: 0),
      isActive: parseBool(data: json['isActive'], defaultValue: true),
    );
  }
}
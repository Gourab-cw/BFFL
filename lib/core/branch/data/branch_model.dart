import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utility/helper.dart';

class BranchModel {
  final String id;
  final String companyId;
  final String name;
  final String mail;
  final String mobile;
  final String activeFrom;
  final String inactiveFrom;
  final String lunchStart;
  final String lunchEnd;
  final bool isActive;

  BranchModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.mail,
    required this.mobile,
    required this.activeFrom,
    required this.inactiveFrom,
    required this.lunchStart,
    required this.lunchEnd,
    required this.isActive,
  });

  /// -------------------- FROM FIRESTORE --------------------
  factory BranchModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return BranchModel(
      id: parseString(data: data['id'], defaultValue: ''),
      companyId: parseString(data: data['companyId'], defaultValue: ''),
      name: parseString(data: data['name'], defaultValue: ''),
      mail: parseString(data: data['mail'], defaultValue: ''),
      mobile: parseString(data: data['mobile'], defaultValue: ''),
      lunchStart: parseString(data: data['lunchStart'], defaultValue: ''),
      lunchEnd: parseString(data: data['lunchEnd'], defaultValue: ''),
      activeFrom: parseString(data: data['activeFrom'], defaultValue: ''),
      inactiveFrom: parseString(data: data['inactiveFrom'], defaultValue: ''),
      isActive: parseBool(data: data['isActive'], defaultValue: false),
    );
  }

  /// -------------------- TO JSON --------------------
  Map<String, dynamic> toJson() {
    return makeMapSerialize({
      'id': id,
      'companyId': companyId,
      'name': name,
      'mail': mail,
      'mobile': mobile,
      'activeFrom': activeFrom,
      'lunchStart': lunchStart,
      'lunchEnd': lunchEnd,
      'inactiveFrom': inactiveFrom,
      'isActive': isActive,
    });
  }

  /// -------------------- COPY WITH --------------------
  BranchModel copyWith({
    String? id,
    String? companyId,
    String? name,
    String? mail,
    String? mobile,
    String? activeFrom,
    String? lunchStart,
    String? lunchEnd,
    String? inactiveFrom,
    bool? isActive,
  }) {
    return BranchModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      mail: mail ?? this.mail,
      mobile: mobile ?? this.mobile,
      lunchStart: lunchStart ?? this.lunchStart,
      lunchEnd: lunchEnd ?? this.lunchEnd,
      activeFrom: activeFrom ?? this.activeFrom,
      inactiveFrom: inactiveFrom ?? this.inactiveFrom,
      isActive: isActive ?? this.isActive,
    );
  }
}

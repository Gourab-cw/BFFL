import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';

class AttendanceModel {
  final String id;
  final String userId;
  final UserType userType;
  final String userName;
  final String date;
  final String branchId;
  final String branchName;
  final String companyId;
  final String createdById;
  final Timestamp createdAt;

  final double lat;
  final double long;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.userType,
    required this.userName,
    required this.date,
    required this.branchId,
    required this.branchName,
    required this.companyId,
    required this.createdById,
    required this.createdAt,
    required this.lat,
    required this.long,
  });

  /// Firestore → Model
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? "",
      userId: json['userId'] ?? "",
      userType: userTypeMap[parseString(data: json['userType'], defaultValue: "")] ?? UserType.member,
      userName: json['userName'] ?? '',
      date: json['date'] ?? '',
      branchId: json['branchId'] ?? '',
      branchName: json['branchName'] ?? '',
      companyId: json['companyId'] ?? '',
      createdById: json['createdById'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      lat: parseDouble(data: json['lat'], defaultValue: 0.0),
      long: parseDouble(data: json['long'], defaultValue: 0.0),
    );
  }

  /// Model → Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userType': userTypeMap2[userType],
      'userName': userName,
      'date': date,
      'branchId': branchId,
      'branchName': branchName,
      'companyId': companyId,
      'createdById': createdById,
      'createdAt': createdAt,
      'lat': lat,
      'long': long,
    };
  }

  AttendanceModel copyWith({
    String? id,
    String? userId,
    UserType? userType,
    String? userName,
    String? date,
    String? branchId,
    String? branchName,
    String? companyId,
    String? createdById,
    Timestamp? createdAt,
    double? lat,
    double? long,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userType: userType ?? this.userType,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      companyId: companyId ?? this.companyId,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';

import '../../../core/utility/helper.dart';
import '../../login/data/user.dart';

class UserSubscription {
  final String id;
  final String userId;
  UserG? user;
  final String name;
  final String branchId;
  final String subscriptionId;

  final String startDate; // "2026-02-01"
  final String endDate; // "2026-03-01"

  final int totalSessions;
  final int usedSessions;
  final int remainingSessions;

  // final double price;

  final bool isActive;

  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final UserSubscriptionType type;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.subscriptionId,
    required this.startDate,
    required this.endDate,
    required this.totalSessions,
    required this.usedSessions,
    required this.remainingSessions,
    this.paidAt,
    this.user,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

  /// ✅ FROM FIREBASE
  factory UserSubscription.fromJSON(Map<String, dynamic> data) {
    return UserSubscription(
      id: parseString(data: data["id"], defaultValue: ""),
      name: parseString(data: data["name"], defaultValue: ""),
      userId: parseString(data: data["userId"], defaultValue: ""),
      branchId: parseString(data: data["branchId"], defaultValue: ""),
      subscriptionId: parseString(data: data["subscriptionId"], defaultValue: ""),

      startDate: parseString(data: data["startDate"], defaultValue: ""),
      endDate: parseString(data: data["endDate"], defaultValue: ""),

      totalSessions: parseInt(data: data["totalSessions"], defaultInt: 0),
      usedSessions: parseInt(data: data["usedSessions"], defaultInt: 0),
      remainingSessions: parseInt(data: data["remainingSessions"], defaultInt: 0),

      // price: parseDouble(data: data["price"], defaultValue: 0.0),
      isActive: parseBool(data: data["isActive"], defaultValue: false),

      paidAt: data['paidAt'] == null ? null : (data['paidAt'] as Timestamp).toDate(),
      type: data['type'] == '' ? UserSubscriptionType.trial : UserSubscriptionType.values.byName(data['type']),
      createdAt: data["createdAt"] == null ? DateTime.now() : (data["createdAt"] as Timestamp).toDate(),
      updatedAt: data["updatedAt"] == null ? DateTime.now() : (data["updatedAt"] as Timestamp).toDate(),
    );
  }

  /// ✅ TO JSON
  Map<String, dynamic> toJSON() {
    return makeMapSerialize({
      "id": id,
      "name": name,
      "userId": userId,
      "branchId": branchId,
      "subscriptionId": subscriptionId,
      "startDate": startDate,
      "endDate": endDate,
      "totalSessions": totalSessions,
      "usedSessions": usedSessions,
      "remainingSessions": remainingSessions,
      "paidAt": paidAt,
      "isActive": isActive,
      'type': type.name,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    });
  }

  /// ✅ COPY WITH
  UserSubscription copyWith({
    String? id,
    String? userId,
    String? branchId,
    String? name,
    String? subscriptionId,
    String? startDate,
    String? endDate,
    int? totalSessions,
    int? usedSessions,
    int? remainingSessions,
    double? price,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt,
    UserSubscriptionType? type,
    UserG? user,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalSessions: totalSessions ?? this.totalSessions,
      usedSessions: usedSessions ?? this.usedSessions,
      remainingSessions: remainingSessions ?? this.remainingSessions,
      paidAt: paidAt ?? this.paidAt,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}

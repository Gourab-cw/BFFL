import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';

import '../../../core/utility/helper.dart';
import '../../login/data/user.dart';

class MultiSubscription {
  final String id;
  final String voucherTypeId;
  final String voucherTypeName;
  final String userId;
  UserG? user;
  final String name;
  final String userName;
  final String branchId;
  final double discAmount;
  final double discPer;
  final double totalAmount;
  final double grossAmount;
  final double taxAmount;
  final double netAmount;
  final double dueAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  final List<UserSubscription> subscriptions;

  MultiSubscription({
    required this.id,
    required this.voucherTypeId,
    required this.voucherTypeName,
    required this.userId,
    required this.userName,
    required this.branchId,
    this.user,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.discAmount,
    required this.discPer,
    required this.totalAmount,
    required this.grossAmount,
    required this.taxAmount,
    required this.netAmount,
    required this.dueAmount,
    required this.subscriptions,
  });

  /// ✅ FROM FIREBASE
  factory MultiSubscription.fromJSON(Map<String, dynamic> data) {
    return MultiSubscription(
      id: parseString(data: data["id"], defaultValue: ""),
      voucherTypeId: parseString(data: data["voucherTypeId"], defaultValue: ""),
      voucherTypeName: parseString(data: data["voucherTypeName"], defaultValue: ""),
      name: parseString(data: data["name"], defaultValue: ""),
      userId: parseString(data: data["userId"], defaultValue: ""),
      userName: parseString(data: data["userName"], defaultValue: ""),
      branchId: parseString(data: data["branchId"], defaultValue: ""),

      createdAt: data["createdAt"] == null ? DateTime.now() : (data["createdAt"] as Timestamp).toDate(),
      updatedAt: data["updatedAt"] == null ? DateTime.now() : (data["updatedAt"] as Timestamp).toDate(),

      discAmount: parseDouble(data: data["discAmount"], defaultValue: 0.0),
      discPer: parseDouble(data: data["discPer"], defaultValue: 0.0),
      totalAmount: parseDouble(data: data["totalAmount"], defaultValue: 0.0),
      grossAmount: parseDouble(data: data["grossAmount"], defaultValue: 0.0),
      taxAmount: parseDouble(data: data["taxAmount"], defaultValue: 0.0),
      netAmount: parseDouble(data: data["netAmount"], defaultValue: 0.0),
      dueAmount: parseDouble(data: data["dueAmount"], defaultValue: 0.0),
      subscriptions: makeListSerialize(data['subscriptions']).map((m) => UserSubscription.fromJSON(m)).toList(),
    );
  }

  /// ✅ TO JSON
  Map<String, dynamic> toJSON() {
    return makeMapSerialize({
      "id": id,
      "voucherTypeId": voucherTypeId,
      "voucherTypeName": voucherTypeName,
      "name": name,
      "userId": userId,
      "userName": userName,
      "branchId": branchId,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
      "discAmount": discAmount,
      "discPer": discPer,
      "totalAmount": totalAmount,
      "grossAmount": grossAmount,
      "taxAmount": taxAmount,
      "netAmount": netAmount,
      "dueAmount": dueAmount,
      "subscriptions": subscriptions.map((m) => m.toJSON()).toList(),
    });
  }

  /// ✅ COPY WITH
  MultiSubscription copyWith({
    String? id,
    String? voucherTypeId,
    String? voucherTypeName,
    String? userId,
    String? userName,
    String? branchId,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt,
    UserSubscriptionType? type,
    UserG? user,
    double? discAmount,
    double? discPer,
    double? totalAmount,
    double? grossAmount,
    double? taxAmount,
    double? netAmount,
    double? dueAmount,
    List<UserSubscription>? subscriptions,
  }) {
    return MultiSubscription(
      id: id ?? this.id,
      voucherTypeId: voucherTypeId ?? this.voucherTypeId,
      voucherTypeName: voucherTypeName ?? this.voucherTypeName,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      discAmount: discAmount ?? this.discAmount,
      discPer: discPer ?? this.discPer,
      totalAmount: totalAmount ?? this.totalAmount,
      grossAmount: grossAmount ?? this.grossAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      netAmount: netAmount ?? this.netAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }
}

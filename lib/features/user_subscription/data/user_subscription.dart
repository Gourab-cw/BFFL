import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';

import '../../../core/utility/helper.dart';
import '../../login/data/user.dart';

class UserSubscription {
  final String id;
  final String voucherTypeId;
  final String voucherTypeName;
  final String userId;
  UserG? user;
  final String name;
  final String userName;
  final String branchId;
  final String subscriptionId;
  final String subscriptionName;
  final int subscriptionTotalDays;
  final double subscriptionTotalAmount;
  final double subscriptionAmount;
  final String startDate; // "2026-02-01"
  final String endDate; // "2026-03-01"
  final int totalSessions;
  final int usedSessions;
  final int remainingSessions;

  // final double price;
  final bool isActive;
  final bool isPosted;
  final bool isPaidSubscription;
  final bool isFullPackage;
  final bool discountWithGST;
  final double discAmount;
  final double discPer;
  final double totalAmount;
  final double grossAmount;
  final double taxAmount;
  final double netAmount;
  final double dueAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserSubscription({
    required this.id,
    required this.voucherTypeId,
    required this.voucherTypeName,
    required this.userId,
    required this.userName,
    required this.branchId,
    required this.subscriptionId,
    required this.startDate,
    required this.endDate,
    required this.totalSessions,
    required this.usedSessions,
    required this.remainingSessions,
    this.user,
    required this.name,
    required this.isActive,
    required this.isPosted,
    required this.createdAt,
    required this.updatedAt,
    required this.subscriptionName,
    required this.subscriptionTotalDays,
    required this.subscriptionTotalAmount,
    required this.subscriptionAmount,
    required this.isPaidSubscription,
    required this.isFullPackage,
    required this.discAmount,
    required this.discPer,
    required this.totalAmount,
    required this.grossAmount,
    required this.taxAmount,
    required this.netAmount,
    required this.dueAmount,
    required this.discountWithGST,
  });

  /// ✅ FROM FIREBASE
  factory UserSubscription.fromJSON(Map<String, dynamic> data) {
    return UserSubscription(
      id: parseString(data: data["id"], defaultValue: ""),
      voucherTypeId: parseString(data: data["voucherTypeId"], defaultValue: ""),
      voucherTypeName: parseString(data: data["voucherTypeName"], defaultValue: ""),
      name: parseString(data: data["name"], defaultValue: ""),
      userId: parseString(data: data["userId"], defaultValue: ""),
      userName: parseString(data: data["userName"], defaultValue: ""),
      branchId: parseString(data: data["branchId"], defaultValue: ""),
      subscriptionId: parseString(data: data["subscriptionId"], defaultValue: ""),

      startDate: parseString(data: data["startDate"], defaultValue: ""),
      endDate: parseString(data: data["endDate"], defaultValue: ""),

      totalSessions: parseInt(data: data["totalSessions"], defaultInt: 0),
      usedSessions: parseInt(data: data["usedSessions"], defaultInt: 0),
      remainingSessions: parseInt(data: data["remainingSessions"], defaultInt: 0),

      // price: parseDouble(data: data["price"], defaultValue: 0.0),
      isActive: parseBool(data: data["isActive"], defaultValue: false),
      isPosted: parseBool(data: data["isPosted"], defaultValue: false),

      createdAt: data["createdAt"] == null ? DateTime.now() : (data["createdAt"] as Timestamp).toDate(),
      updatedAt: data["updatedAt"] == null ? DateTime.now() : (data["updatedAt"] as Timestamp).toDate(),

      subscriptionName: parseString(data: data["subscriptionName"], defaultValue: ""),
      subscriptionTotalDays: parseInt(data: data["subscriptionTotalDays"], defaultInt: 0),
      subscriptionTotalAmount: parseDouble(data: data["subscriptionTotalAmount"], defaultValue: 0),
      subscriptionAmount: parseDouble(data: data["subscriptionAmount"], defaultValue: 0),
      isPaidSubscription: parseBool(data: data["isPaidSubscription"], defaultValue: false),
      isFullPackage: parseBool(data: data["isFullPackage"], defaultValue: false),
      discountWithGST: parseBool(data: data["discountWithGST"], defaultValue: false),
      discAmount: parseDouble(data: data["discAmount"], defaultValue: 0.0),
      discPer: parseDouble(data: data["discPer"], defaultValue: 0.0),
      totalAmount: parseDouble(data: data["totalAmount"], defaultValue: 0.0),
      grossAmount: parseDouble(data: data["grossAmount"], defaultValue: 0.0),
      taxAmount: parseDouble(data: data["taxAmount"], defaultValue: 0.0),
      netAmount: parseDouble(data: data["netAmount"], defaultValue: 0.0),
      dueAmount: parseDouble(data: data["dueAmount"], defaultValue: 0.0),
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
      "subscriptionId": subscriptionId,
      "startDate": startDate,
      "endDate": endDate,
      "totalSessions": totalSessions,
      "usedSessions": usedSessions,
      "remainingSessions": remainingSessions,
      "isActive": isActive,
      "isPosted": isPosted,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
      "subscriptionName": subscriptionName,
      "subscriptionTotalDays": subscriptionTotalDays,
      "subscriptionTotalAmount": subscriptionTotalAmount,
      "subscriptionAmount": subscriptionAmount,
      "isPaidSubscription": isPaidSubscription,
      "isFullPackage": isFullPackage,
      "discAmount": discAmount,
      "discPer": discPer,
      "totalAmount": totalAmount,
      "grossAmount": grossAmount,
      "taxAmount": taxAmount,
      "netAmount": netAmount,
      "dueAmount": dueAmount,
      "discountWithGST": discountWithGST,
    });
  }

  /// ✅ COPY WITH
  UserSubscription copyWith({
    String? id,
    String? voucherTypeId,
    String? voucherTypeName,
    String? userId,
    String? userName,
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
    bool? isPosted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt,
    UserSubscriptionType? type,
    UserG? user,
    String? subscriptionName,
    int? subscriptionTotalDays,
    double? subscriptionTotalAmount,
    double? subscriptionAmount,
    bool? isPaidSubscription,
    bool? isFullPackage,
    bool? discountWithGST,
    double? discAmount,
    double? discPer,
    double? totalAmount,
    double? grossAmount,
    double? taxAmount,
    double? netAmount,
    double? dueAmount,
  }) {
    return UserSubscription(
      id: id ?? this.id,
      voucherTypeId: voucherTypeId ?? this.voucherTypeId,
      voucherTypeName: voucherTypeName ?? this.voucherTypeName,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalSessions: totalSessions ?? this.totalSessions,
      usedSessions: usedSessions ?? this.usedSessions,
      remainingSessions: remainingSessions ?? this.remainingSessions,
      isActive: isActive ?? this.isActive,
      isPosted: isPosted ?? this.isPosted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      subscriptionName: subscriptionName ?? this.subscriptionName,
      subscriptionTotalDays: subscriptionTotalDays ?? this.subscriptionTotalDays,
      subscriptionTotalAmount: subscriptionTotalAmount ?? this.subscriptionTotalAmount,
      subscriptionAmount: subscriptionAmount ?? this.subscriptionAmount,
      isPaidSubscription: isPaidSubscription ?? this.isPaidSubscription,
      isFullPackage: isFullPackage ?? this.isFullPackage,
      discAmount: discAmount ?? this.discAmount,
      discPer: discPer ?? this.discPer,
      totalAmount: totalAmount ?? this.totalAmount,
      grossAmount: grossAmount ?? this.grossAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      netAmount: netAmount ?? this.netAmount,
      dueAmount: dueAmount ?? this.dueAmount,
      discountWithGST: discountWithGST ?? this.discountWithGST,
    );
  }
}

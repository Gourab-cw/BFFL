import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:intl/intl.dart';

class SlotModel {
  final String id;
  final String serviceId;
  final String branchId;
  final String companyId;
  final String date; // yyyy-MM-dd
  final String month; // yyyy-MM
  final String startTime; // HH:mm
  final String endTime; // HH:mm
  final String trainerId;
  final String? trainerName;
  final int bookingCount;
  final int totalAttend;
  final bool isActive;
  final bool hasComplete;
  final Timestamp? completeAt;
  final Timestamp createdAt;
  final Timestamp? trainerStartTime;

  const SlotModel({
    required this.id,
    required this.serviceId,
    required this.branchId,
    required this.companyId,
    required this.date,
    required this.month,
    required this.startTime,
    required this.endTime,
    required this.trainerId,
    this.trainerName,
    required this.bookingCount,
    required this.totalAttend,
    required this.isActive,
    required this.hasComplete,
    required this.completeAt,
    required this.createdAt,
    this.trainerStartTime,
  });

  /// 🔹 From Firestore
  factory SlotModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SlotModel(
      id: data['id'] ?? doc.id,
      serviceId: parseString(data: data['serviceId'], defaultValue: ""),
      branchId: data['branchId'] ?? '',
      companyId: data['companyId'] ?? '',
      date: data['date'] ?? '',
      month: data['month'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      bookingCount: parseInt(data: data["bookingCount"], defaultInt: 0),
      totalAttend: parseInt(data: data["totalAttend"], defaultInt: 0),
      completeAt: data['completeAt'],
      hasComplete: parseBool(data: data['hasComplete'], defaultValue: false),
      trainerId: parseString(data: data['trainerId'], defaultValue: ''),
      trainerName: parseString(data: data['trainerName'], defaultValue: ''),
      isActive: data['isActive'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      trainerStartTime: data['trainerStartTime'] ?? Timestamp.now(),
    );
  }

  factory SlotModel.fromJSON(Map<String, dynamic> data) {
    return SlotModel(
      id: parseString(data: data['id'], defaultValue: ""),
      serviceId: parseString(data: data['serviceId'], defaultValue: ""),
      branchId: parseString(data: data['branchId'], defaultValue: ""),
      companyId: parseString(data: data['companyId'], defaultValue: ""),
      date: parseString(data: data['date'], defaultValue: ""),
      month: parseString(data: data['month'], defaultValue: ""),
      startTime: parseString(data: data['startTime'], defaultValue: ""),
      endTime: parseString(data: data['endTime'], defaultValue: ""),
      trainerId: parseString(data: data['trainerId'], defaultValue: ""),
      trainerName: parseString(data: data['trainerName'], defaultValue: ""),
      bookingCount: parseInt(data: data["bookingCount"], defaultInt: 0),
      totalAttend: parseInt(data: data["totalAttend"], defaultInt: 0),
      isActive: parseBool(data: data['isActive'], defaultValue: false),
      completeAt: data['completeAt'],
      hasComplete: parseBool(data: data['hasComplete'], defaultValue: false),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      trainerStartTime: data['trainerStartTime'],
    );
  }

  SlotModel copyWith({
    String? id,
    String? serviceId,
    String? branchId,
    String? companyId,
    DateTime? date,
    DateTime? month,
    String? startTime,
    String? endTime,
    String? trainerId,
    String? trainerName,
    int? bookingCount,
    int? totalAttend,
    bool? isActive,
    bool? hasComplete,
    DateTime? completeAt,
    DateTime? createdAt,
    DateTime? trainerStartTime,
  }) {
    return SlotModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      branchId: branchId ?? this.branchId,
      companyId: companyId ?? this.companyId,
      date: date == null ? this.date : DateFormat('yyyy-MM-dd').format(date),
      month: month == null ? this.month : DateFormat('yyyy-MM').format(month),
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      trainerId: trainerId ?? this.trainerId,
      trainerName: trainerName ?? this.trainerName,
      bookingCount: bookingCount ?? this.bookingCount,
      totalAttend: totalAttend ?? this.totalAttend,
      isActive: isActive ?? this.isActive,
      hasComplete: hasComplete ?? this.hasComplete,
      completeAt: completeAt == null ? this.completeAt : Timestamp.fromDate(completeAt),
      trainerStartTime: trainerStartTime == null ? this.trainerStartTime : Timestamp.fromDate(trainerStartTime!),
      createdAt: createdAt == null ? this.createdAt : Timestamp.fromDate(createdAt),
    );
  }

  /// 🔹 To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'branchId': branchId,
      'companyId': companyId,
      'serviceId': serviceId,
      'date': date,
      'month': month,
      'startTime': startTime,
      'endTime': endTime,
      'trainerId': trainerId,
      'trainerName': trainerName,
      'bookingCount': bookingCount,
      'totalAttend': totalAttend,
      'hasComplete': hasComplete,
      'completeAt': completeAt,
      'isActive': isActive,
      'createdAt': createdAt,
      'trainerStartTime': trainerStartTime,
    };
  }
}

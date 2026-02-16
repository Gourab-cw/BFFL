import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/core/utility/helper.dart';

class SessionModel {
  final String id;
  final String memberId;
  final String? memberName;
  final String serviceId;
  final String subscriptionId;
  final String? serviceName;
  final String? serviceDetails;
  final String trainerId;
  final String? trainerName;
  final String slotId;

  final String date; // yyyy-MM-dd
  final bool hasAttend;
  final bool isActive;

  final String feedback;
  final String trainerFeedback;
  final String startTime;
  final String endTime;
  final bool isTrail;

  final DateTime createdAt;
  final Timestamp? completeAt;
  final DateTime? attendedAt;

  SessionModel({
    required this.id,
    required this.memberId,
    this.memberName,
    required this.serviceId,
    this.serviceName,
    this.serviceDetails,
    required this.slotId,
    required this.trainerId,
    required this.subscriptionId,
    this.trainerName,
    required this.date,
    required this.hasAttend,
    required this.isActive,
    required this.feedback,
    required this.trainerFeedback,
    required this.createdAt,
    required this.startTime,
    required this.endTime,
    required this.isTrail,
    this.attendedAt,
    this.completeAt,
  });

  /// 🔹 From Firestore
  factory SessionModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SessionModel(
      id: data['id'] ?? doc.id,
      memberId: data['memberId'] ?? '',
      memberName: data['memberName'] ?? '',
      serviceId: data['serviceId'] ?? '',
      slotId: data['slotId'] ?? '',
      subscriptionId: data['subscriptionId'] ?? '',
      trainerId: data['trainerId'] is List ? data['trainerId'][0] ?? "" : data['trainerId'] ?? "",
      date: data['date'] ?? '',
      hasAttend: data['hasAttend'] ?? false,
      isActive: data['isActive'] ?? true,
      feedback: data['feedback'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      isTrail: parseBool(data: data['isTrail'], defaultValue: false),
      trainerFeedback: data['trainerFeedback'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      attendedAt: data['attendedAt'] != null ? (data['attendedAt'] as Timestamp).toDate() : null,
      completeAt: data['completeAt'],
    );
  }

  /// 🔹 To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'memberId': memberId,
      'memberName': memberName,
      'serviceId': serviceId,
      'slotId': slotId,
      'trainerId': trainerId,
      'subscriptionId': subscriptionId,
      'date': date,
      'hasAttend': hasAttend,
      'isActive': isActive,
      'feedback': feedback,
      'startTime': startTime,
      'endTime': endTime,
      'isTrail': isTrail,
      'trainerFeedback': trainerFeedback,
      'createdAt': Timestamp.fromDate(createdAt),
      'attendedAt': attendedAt != null ? Timestamp.fromDate(attendedAt!) : null,
      'completeAt': completeAt,
    };
  }

  /// 🔹 CopyWith
  SessionModel copyWith({
    String? id,
    String? memberId,
    String? memberName,
    String? serviceId,
    String? subscriptionId,
    String? serviceName,
    String? serviceDetails,
    String? slotId,
    String? trainerId,
    String? trainerName,
    String? date,
    bool? hasAttend,
    bool? isActive,
    String? feedback,
    String? trainerFeedback,
    String? startTime,
    String? endTime,
    bool? isTrail,
    DateTime? createdAt,
    DateTime? attendedAt,
    Timestamp? completeAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceDetails: serviceDetails ?? this.serviceDetails,
      slotId: slotId ?? this.slotId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      trainerId: trainerId ?? this.trainerId,
      trainerName: trainerName ?? this.trainerName,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isTrail: isTrail ?? this.isTrail,
      hasAttend: hasAttend ?? this.hasAttend,
      isActive: isActive ?? this.isActive,
      feedback: feedback ?? this.feedback,
      trainerFeedback: trainerFeedback ?? this.trainerFeedback,
      createdAt: createdAt ?? this.createdAt,
      attendedAt: attendedAt ?? this.attendedAt,
      completeAt: completeAt ?? this.completeAt,
    );
  }
}

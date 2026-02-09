import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthandwellness/core/utility/helper.dart';

class SessionModel {
  final String id;
  final String memberId;
  final String? memberName;
  final String serviceId;
  final String trainerId;
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
  final DateTime? attendedAt;

  SessionModel({
    required this.id,
    required this.memberId,
    this.memberName,
    required this.serviceId,
    required this.slotId,
    required this.trainerId,
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
      trainerId: data['trainerId'] ?? "",
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
    };
  }

  /// 🔹 CopyWith
  SessionModel copyWith({
    String? id,
    String? memberId,
    String? memberName,
    String? serviceId,
    String? slotId,
    String? trainerId,
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
  }) {
    return SessionModel(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      serviceId: serviceId ?? this.serviceId,
      slotId: slotId ?? this.slotId,
      trainerId: trainerId ?? this.trainerId,
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
    );
  }
}

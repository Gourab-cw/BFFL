import 'package:healthandwellness/core/utility/helper.dart';

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final bool isTrial;
  final String image;
  final int maxBooking;
  final int amount;
  final double totalAmount;
  final int totalDays;
  final List<String> trainerId;

  final bool? isNewSlot;
  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isTrial,
    required this.image,
    required this.maxBooking,
    required this.trainerId,
    required this.totalDays,
    required this.amount,
    this.isNewSlot,
    required this.totalAmount,
  });

  /// Create from Firestore / JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: parseString(data: json["id"], defaultValue: ""),
      name: parseString(data: json['name'], defaultValue: ""),
      description: parseString(data: json['description'], defaultValue: ""),
      isTrial: parseBool(data: json['isTrial'], defaultValue: false),
      image: parseString(data: json['image'], defaultValue: ""),
      maxBooking: parseInt(data: json['maxBooking'], defaultInt: 0),
      trainerId: List<String>.from(json['trainerId'] ?? []),
      amount: parseInt(data: json['amount'], defaultInt: 0),
      totalDays: parseInt(data: json['totalDays'], defaultInt: 0),
      totalAmount: parseDouble(data: json['totalAmount'], defaultValue: 0),
    );
  }

  /// Convert to Firestore / JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'isTrial': isTrial,
      'image': image,
      'maxBooking': maxBooking,
      'trainerId': trainerId,
      'amount': amount,
      'totalDays': totalDays,
      'totalAmount': totalAmount,
    };
  }

  /// Optional: copyWith (very useful)
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isTrial,
    String? image,
    int? maxBooking,
    List<String>? trainerId,
    int? totalDays,
    int? amount,
    double? totalAmount,
    bool? isNewSlot,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isTrial: isTrial ?? this.isTrial,
      image: image ?? this.image,
      maxBooking: maxBooking ?? this.maxBooking,
      trainerId: trainerId ?? this.trainerId,
      totalDays: totalDays ?? this.totalDays,
      amount: amount ?? this.amount,
      totalAmount: totalAmount ?? this.totalAmount,
      isNewSlot: isNewSlot ?? this.isNewSlot,
    );
  }
}

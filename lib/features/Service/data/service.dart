import 'package:healthandwellness/core/utility/helper.dart';

import '../../login/data/user.dart';

class ServiceModel {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String description;
  final bool isTrial;
  final String image;
  final int maxBooking;
  final int amount;
  final double totalAmount;
  final double gstPer;
  final double discountPer;
  final double registrationCharge;
  final bool withGST;
  final int totalDays;
  final List<String> trainerId;
  final List<UserG>? trainersData;

  final bool? isNewSlot;
  final bool fullPackageBookingOnly;
  final bool isActive;
  final bool isPosted;
  final String companyId;

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
    required this.gstPer,
    required this.withGST,
    this.isNewSlot,
    this.trainersData,
    required this.totalAmount,
    this.discountPer = 0,
    this.fullPackageBookingOnly = false,
    required this.registrationCharge,
    required this.categoryId,
    required this.categoryName,
    this.isActive = true,
    this.isPosted = false,
    this.companyId = '',
  });

  /// Create from Firestore / JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: parseString(data: json["id"], defaultValue: ""),
      name: parseString(data: json['name'], defaultValue: ""),
      description: parseString(data: json['description'], defaultValue: ""),
      isTrial: parseBool(data: json['isTrial'], defaultValue: false),
      withGST: parseBool(data: json['withGST'], defaultValue: false),
      image: parseString(data: json['image'], defaultValue: ""),
      maxBooking: parseInt(data: json['maxBooking'], defaultInt: 0),
      trainerId: List<String>.from(json['trainerId'] ?? []),
      amount: parseInt(data: json['amount'], defaultInt: 0),
      totalDays: parseInt(data: json['totalDays'], defaultInt: 0),
      totalAmount: parseDouble(data: json['totalAmount'], defaultValue: 0),
      gstPer: parseDouble(data: json['gstPer'], defaultValue: 0),
      categoryId: parseString(data: json['categoryId'], defaultValue: ""),
      categoryName: parseString(data: json['categoryName'], defaultValue: ""),
      discountPer: parseDouble(data: json['discountPer'], defaultValue: 0),
      registrationCharge: parseDouble(data: json['registrationCharge'], defaultValue: 0),
      fullPackageBookingOnly: parseBool(data: json['fullPackageBookingOnly'], defaultValue: false),
      isActive: parseBool(data: json['isActive'], defaultValue: true),
      isPosted: parseBool(data: json['isPosted'], defaultValue: false),
      companyId: parseString(data: json['companyId'], defaultValue: ""),
    );
  }

  /// Convert to Firestore / JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isTrial': isTrial,
      'image': image,
      'maxBooking': maxBooking,
      'trainerId': trainerId,
      'amount': amount,
      'totalDays': totalDays,
      'totalAmount': totalAmount,
      'withGST': withGST,
      'gstPer': gstPer,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'discountPer': discountPer,
      'registrationCharge': registrationCharge,
      'fullPackageBookingOnly': fullPackageBookingOnly,
      'isActive': isActive,
      'isPosted': isPosted,
      'companyId': companyId,
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
    double? gstPer,
    bool? isNewSlot,
    bool? withGST,
    List<UserG>? trainersData,
    String? categoryId,
    String? categoryName,
    double? discountPer,
    double? registrationCharge,
    bool? fullPackageBookingOnly,
    bool? isActive,
    bool? isPosted,
    String? companyId,
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
      gstPer: gstPer ?? this.gstPer,
      withGST: withGST ?? this.withGST,
      trainersData: trainersData ?? this.trainersData,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      discountPer: discountPer ?? this.discountPer,
      registrationCharge: registrationCharge ?? this.registrationCharge,
      fullPackageBookingOnly: fullPackageBookingOnly ?? this.fullPackageBookingOnly,
      isActive: isActive ?? this.isActive,
      isPosted: isPosted ?? this.isPosted,
      companyId: companyId ?? this.companyId,
    );
  }
}

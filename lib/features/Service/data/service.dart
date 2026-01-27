import 'package:healthandwellness/core/utility/helper.dart';

class ServiceModel {
  final String id;
  final String name;
  final String description;
  final bool isTrial;
  final String image;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isTrial,
    required this.image,
  });

  /// Create from Firestore / JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: parseString(data: json["id"], defaultValue: ""),
      name: parseString(data: json['name'], defaultValue: ""),
      description:  parseString(data: json['description'], defaultValue: ""),
      isTrial: parseBool(data: json['isTrial'], defaultValue: false),
      image: parseString(data: json['image'], defaultValue: ""),
    );
  }

  /// Convert to Firestore / JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'isTrial': isTrial,
      'image': image,
    };
  }

  /// Optional: copyWith (very useful)
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isTrial,
    String? image,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isTrial: isTrial ?? this.isTrial,
      image: image ?? this.image,
    );
  }
}
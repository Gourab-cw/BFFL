import 'package:healthandwellness/core/utility/helper.dart';

class CategoryModel {
  final String id;
  final String name;
  final String branchId;
  final String companyId;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.branchId,
    required this.companyId,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: parseString(data: json['id'], defaultValue: ''),
      name: parseString(data: json['name'], defaultValue: ''),
      branchId: parseString(data: json['branchId'], defaultValue: ''),
      companyId: parseString(data: json['companyId'], defaultValue: ''),
      isActive: parseBool(data: json['isActive'], defaultValue: true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branchId': branchId,
      'companyId': companyId,
      'isActive': isActive,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? branchId,
    String? companyId,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      branchId: branchId ?? this.branchId,
      companyId: companyId ?? this.companyId,
      isActive: isActive ?? this.isActive,
    );
  }
}

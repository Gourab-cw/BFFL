// To parse this JSON data, do
//
//     final userType = userTypeFromJson(jsonString);
import 'dart:convert';

UserTypeModel userTypeFromJson(String str) => UserTypeModel.fromJson(json.decode(str));

String userTypeToJson(UserTypeModel data) => json.encode(data.toJson());

class UserTypeModel {
  final String id;
  final String name;
  final bool isActive;
  final int userTypeId;

  UserTypeModel({required this.id, required this.name, required this.isActive, required this.userTypeId});

  UserTypeModel copyWith({String? id, String? name, bool? isActive, int? userTypeId}) =>
      UserTypeModel(id: id ?? this.id, name: name ?? this.name, isActive: isActive ?? this.isActive, userTypeId: userTypeId ?? this.userTypeId);

  factory UserTypeModel.fromJson(Map<String, dynamic> json) =>
      UserTypeModel(id: json["id"], name: json["name"], isActive: json["isActive"], userTypeId: json["userTypeId"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "isActive": isActive, "userTypeId": userTypeId};
}

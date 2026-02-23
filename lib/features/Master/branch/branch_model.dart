import 'package:healthandwellness/core/utility/helper.dart';

class BranchModel {
  String id;
  String name;
  String mail;
  String mobile;
  String companyId;
  String activeFrom;
  bool isActive;

  BranchModel({
    required this.id,
    required this.name,
    required this.mail,
    required this.mobile,
    required this.companyId,
    required this.activeFrom,
    required this.isActive,
  });

  factory BranchModel.fromJSON(Map<String, dynamic> data) => BranchModel(
    id: parseString(data: data["id"], defaultValue: ""),
    name: parseString(data: data["name"], defaultValue: ""),
    mail: parseString(data: data["mail"], defaultValue: ""),
    mobile: parseString(data: data["mobile"], defaultValue: ""),
    companyId: parseString(data: data["companyId"], defaultValue: ""),
    activeFrom: parseString(data: data["activeFrom"], defaultValue: ""),
    isActive: parseBool(data: data["isActive"], defaultValue: false),
  );

  Map<String, dynamic> toJSON() {
    return {'id': id, 'name': name, 'mail': mail, 'mobile': mobile, 'companyId': companyId, 'activeFrom': activeFrom, 'isActive': isActive};
  }
}

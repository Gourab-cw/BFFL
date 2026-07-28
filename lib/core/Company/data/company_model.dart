import 'package:healthandwellness/core/utility/helper.dart';

class CompanyModel {
  String? activeFrom;
  String? groupCompanyId;
  String? id;
  String? inactiveFrom;
  bool? isActive;
  bool? memberCreationMailSent;
  String? memberCreationMailTo;
  String? name;
  String address;
  String city;
  String email;
  String gstin;
  String website;
  String state;
  String pincode;
  String mobile;

  CompanyModel({
    this.activeFrom,
    this.groupCompanyId,
    this.id,
    this.inactiveFrom,
    this.isActive,
    this.memberCreationMailSent,
    this.memberCreationMailTo,
    this.name,
    this.state = "",
    this.mobile = "",
    this.pincode = "",
    this.email = "",
    this.address = "",
    this.city = "",
    this.gstin = "",
    this.website = "",
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      activeFrom: json['activeFrom'],
      groupCompanyId: json['groupCompanyId'],
      id: json['id'],
      inactiveFrom: json['inactiveFrom'],
      isActive: json['isActive'],
      memberCreationMailSent: json['memberCreationMailSent'],
      memberCreationMailTo: json['memberCreationMailTo'],
      name: json['name'],
      address: parseString(data: json["address"], defaultValue: ""),
      city: parseString(data: json["city"], defaultValue: ""),
      email: parseString(data: json["email"], defaultValue: ""),
      gstin: parseString(data: json["gstin"], defaultValue: ""),
      mobile: parseString(data: json["mobile"], defaultValue: ""),
      pincode: parseString(data: json["pincode"], defaultValue: ""),
      state: parseString(data: json["state"], defaultValue: ""),
      website: parseString(data: json["website"], defaultValue: ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeFrom': activeFrom,
      'groupCompanyId': groupCompanyId,
      'id': id,
      'inactiveFrom': inactiveFrom,
      'isActive': isActive,
      'memberCreationMailSent': memberCreationMailSent,
      'memberCreationMailTo': memberCreationMailTo,
      'name': name,
    };
  }
}

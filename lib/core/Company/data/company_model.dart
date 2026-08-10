import 'package:healthandwellness/core/utility/helper.dart';
import 'package:intl/intl.dart';

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

  DateTime dayStart;
  DateTime dayEnd;
  int slotTimeInMin;

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
    required this.slotTimeInMin,
    required this.dayEnd,
    required this.dayStart,
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
      dayEnd: parseStringToDate(
        data: json['dayEnd'],
        predefinedDateFormat: "HH:mm",
        defaultValue: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ),
      dayStart: parseStringToDate(
        data: json['dayStart'],
        predefinedDateFormat: "HH:mm",
        defaultValue: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      ),
      slotTimeInMin: parseInt(data: json['slotTimeInMin']),
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
      'dayEnd': DateFormat('HH:mm').format(dayEnd),
      'dayStart': DateFormat('HH:mm').format(dayStart),
      'slotTimeInMin': slotTimeInMin.toString(),
    };
  }
}

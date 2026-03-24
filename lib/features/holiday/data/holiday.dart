import '../../../core/utility/helper.dart';

class HolidayModel {
  String id;
  String branchId;
  String companyId;
  String holidayName;
  String holidayDate;
  bool isActive;

  HolidayModel({this.id = '', this.branchId = '', this.companyId = '', this.holidayName = '', this.holidayDate = '', this.isActive = true});

  factory HolidayModel.fromFirebase(Map<String, dynamic> json, String id) {
    return HolidayModel(
      id: id,
      branchId: parseString(data: json['branchId'], defaultValue: ''),
      companyId: parseString(data: json['companyId'], defaultValue: ''),
      holidayName: parseString(data: json['holidayName'], defaultValue: ''),
      holidayDate: parseString(data: json['holidayDate'], defaultValue: ''),
      isActive: parseBool(data: json['isActive'], defaultValue: true),
    );
  }

  Map<String, dynamic> toJson() {
    return makeMapSerialize({'branchId': branchId, 'companyId': companyId, 'holidayName': holidayName, 'holidayDate': holidayDate, 'isActive': isActive});
  }
}

import 'package:healthandwellness/core/utility/helper.dart';


enum UserType {cwAdmin,admin,branchManager,receptionist,trainer,accountant,member}
final _userTypeMap = {
  'eVfqVJWwHnLnKZPQr4tC': UserType.cwAdmin,
  'Fj3WvG9DjgG6ve0Xw3SF': UserType.admin,
  'qeTcMMfWb1zzLwsNZDZW': UserType.branchManager,
  '79L1x0XoqV7XSsQjOImp': UserType.receptionist,
  'JoVVKfIcwkccunAFqIdy': UserType.trainer,
  'nFgfN9g1CV401w0L2OiS': UserType.accountant,
  'Sl9TlKFGMLCGWGFyTQpd': UserType.member,
};

class UserG {
  String id;
  String name;
  String mail;
  DateTime? activeFrom;
  DateTime? activeTill;
  String branchId;
  String companyId;
  String mobile;
  UserType userType;

  UserG({required this.id, required this.name, required this.mail,required this.activeFrom, required this.activeTill, required this.branchId,required this.companyId,required this.mobile,required this.userType});


  factory UserG.fromJSON(Map<String,dynamic> data)=>UserG(
      id: parseString(data: data["id"], defaultValue: ""),
      name: parseString(data: data["name"], defaultValue: ""),
      mail: parseString(data: data["mail"], defaultValue: ""),
      branchId: parseString(data: data["branchId"], defaultValue: ""),
      companyId: parseString(data: data["companyId"], defaultValue: ""),
      mobile: parseString(data: data["mobile"], defaultValue: ""),
      userType: _userTypeMap[parseString(data: data["userTypeId"], defaultValue: "")] ?? UserType.member,
      activeFrom: parseStringToEmptyDate(data: data["activeFrom"], predefinedDateFormat: "yyyy-MM-dd", defaultValue: null),
      activeTill: parseStringToEmptyDate(data: data["activeFrom"], predefinedDateFormat: "yyyy-MM-dd", defaultValue: null),
  );

}

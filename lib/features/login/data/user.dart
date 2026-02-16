import 'package:healthandwellness/core/utility/helper.dart';
import 'package:intl/intl.dart';

enum UserType { cwAdmin, admin, branchManager, receptionist, trainer, accountant, member }

enum MemberType { paid, trial }

final Map<String, UserType> userTypeMap = {
  'eVfqVJWwHnLnKZPQr4tC': UserType.cwAdmin,
  'Fj3WvG9DjgG6ve0Xw3SF': UserType.admin,
  'qeTcMMfWb1zzLwsNZDZW': UserType.branchManager,
  '79L1x0XoqV7XSsQjOImp': UserType.receptionist,
  'JoVVKfIcwkccunAFqIdy': UserType.trainer,
  'nFgfN9g1CV401w0L2OiS': UserType.accountant,
  'Sl9TlKFGMLCGWGFyTQpd': UserType.member,
};

final Map<UserType, String> userTypeMap2 = {
  UserType.cwAdmin: 'eVfqVJWwHnLnKZPQr4tC',
  UserType.admin: 'Fj3WvG9DjgG6ve0Xw3SF',
  UserType.branchManager: 'qeTcMMfWb1zzLwsNZDZW',
  UserType.receptionist: '79L1x0XoqV7XSsQjOImp',
  UserType.trainer: 'JoVVKfIcwkccunAFqIdy',
  UserType.accountant: 'nFgfN9g1CV401w0L2OiS',
  UserType.member: 'Sl9TlKFGMLCGWGFyTQpd',
};

class UserG {
  String id;

  bool isApproved;
  bool isActive;
  String name;
  String mail;
  DateTime? activeFrom;
  DateTime? activeTill;
  String branchId;
  String companyId;
  String mobile;
  String profileImage;
  MemberType memberType;
  UserType userType;

  // 🔹 New fields
  String dob;
  String age;
  String genderId;
  String bgId;
  String height;
  String bodyWeight;
  String mobile1;
  String address;
  String pincode;
  String city;
  String state;
  String nationality;
  String country;
  String profession;
  String maritalStatusId;
  List<String> services;
  String medicalCondition;
  String medication;
  String physicalExercise;
  String diet;
  String referredById;
  String referredByName;

  UserG({
    required this.id,
    required this.isApproved,
    required this.isActive,
    required this.name,
    required this.mail,
    required this.activeFrom,
    required this.activeTill,
    required this.branchId,
    required this.companyId,
    required this.mobile,
    required this.userType,
    required this.memberType,

    // new
    required this.dob,
    required this.age,
    required this.genderId,
    required this.bgId,
    required this.height,
    required this.bodyWeight,
    required this.mobile1,
    required this.address,
    required this.pincode,
    required this.city,
    required this.state,
    required this.nationality,
    required this.country,
    required this.profession,
    required this.maritalStatusId,
    required this.services,
    required this.medicalCondition,
    required this.medication,
    required this.physicalExercise,
    required this.diet,
    required this.referredById,
    required this.referredByName,
    required this.profileImage,
  });

  factory UserG.fromJSON(Map<String, dynamic> data) {
    return UserG(
      id: parseString(data: data["id"], defaultValue: ""),
      isApproved: parseBool(data: data["isApproved"], defaultValue: false),
      isActive: parseBool(data: data["isActive"], defaultValue: false),
      name: parseString(data: data["name"], defaultValue: ""),
      mail: parseString(data: data["mail"], defaultValue: ""),
      branchId: parseString(data: data["branchId"], defaultValue: ""),
      companyId: parseString(data: data["companyId"], defaultValue: ""),
      mobile: parseString(data: data["mobile"], defaultValue: ""),
      userType: userTypeMap[parseString(data: data["userType"], defaultValue: "")] ?? UserType.member,
      memberType: parseString(data: data["memberType"], defaultValue: "") == "paid" ? MemberType.paid : MemberType.trial,

      activeFrom: parseStringToEmptyDate(data: data["activeFrom"], predefinedDateFormat: "yyyy-MM-dd", defaultValue: null),
      activeTill: parseStringToEmptyDate(data: data["activeTill"], predefinedDateFormat: "yyyy-MM-dd", defaultValue: null),

      // 🔹 new mappings
      dob: parseString(data: data["dob"], defaultValue: ""),
      age: parseString(data: data["age"], defaultValue: ""),
      genderId: parseString(data: data["genderId"], defaultValue: ""),
      bgId: parseString(data: data["bgId"], defaultValue: ""),
      height: parseString(data: data["height"], defaultValue: ""),
      bodyWeight: parseString(data: data["bodyWeight"], defaultValue: ""),
      mobile1: parseString(data: data["mobile1"], defaultValue: ""),
      address: parseString(data: data["address"], defaultValue: ""),
      pincode: parseString(data: data["pincode"], defaultValue: ""),
      city: parseString(data: data["city"], defaultValue: ""),
      state: parseString(data: data["state"], defaultValue: ""),
      nationality: parseString(data: data["nationality"], defaultValue: ""),
      country: parseString(data: data["country"], defaultValue: ""),
      profession: parseString(data: data["profession"], defaultValue: ""),
      maritalStatusId: parseString(data: data["maritialStatus"], defaultValue: ""),
      services: (data["services"] as List?)?.map((e) => e.toString()).toList() ?? [],
      medicalCondition: parseString(data: data["medicalCondition"], defaultValue: ""),
      medication: parseString(data: data["medication"], defaultValue: ""),
      physicalExercise: parseString(data: data["physicalExercise"], defaultValue: ""),
      diet: parseString(data: data["diet"], defaultValue: ""),
      referredById: parseString(data: data["referredBy"], defaultValue: ""),
      referredByName: parseString(data: data["referredByname"], defaultValue: ""),
      profileImage: parseString(data: data["profileImage"], defaultValue: ""),
    );
  }

  Map<String, dynamic> toJSON() => {
    "id": id,
    "isApproved": isApproved,
    "isActive": isActive,
    "name": name,
    "mail": mail,
    "branchId": branchId,
    "companyId": companyId,
    "mobile": mobile,
    "userType": userTypeMap2[userType], // enum → string
    "memberType": memberType == MemberType.paid ? "paid" : "trial",

    "activeFrom": activeFrom != null ? DateFormat("yyyy-MM-dd").format(activeFrom!) : null,
    "activeTill": activeTill != null ? DateFormat("yyyy-MM-dd").format(activeTill!) : null,

    // 🔹 new mappings
    "dob": dob,
    "age": age,
    "gender": genderId,
    "bg": bgId,
    "height": height,
    "bodyWeight": bodyWeight,
    "mobile1": mobile1,
    "address": address,
    "pincode": pincode,
    "city": city,
    "state": state,
    "nationality": nationality,
    "country": country,
    "profession": profession,
    "maritialStatus": maritalStatusId,
    "services": services,
    "medicalCondition": medicalCondition,
    "medication": medication,
    "physicalExercise": physicalExercise,
    "diet": diet,
    "referredBy": referredById,
    "referredByname": referredByName,
    "profileImage": profileImage,
  };

  // ✅ copyWith
  UserG copyWith({
    String? id,
    bool? isApproved,
    bool? isActive,
    String? name,
    String? mail,
    DateTime? activeFrom,
    DateTime? activeTill,
    String? branchId,
    String? companyId,
    String? mobile,
    UserType? userType,
    MemberType? memberType,
    String? dob,
    String? age,
    String? genderId,
    String? bgId,
    String? height,
    String? bodyWeight,
    String? mobile1,
    String? address,
    String? pincode,
    String? city,
    String? state,
    String? nationality,
    String? country,
    String? profession,
    String? maritalStatusId,
    List<String>? services,
    String? medicalCondition,
    String? medication,
    String? physicalExercise,
    String? diet,
    String? referredById,
    String? referredByName,
    String? profileImage,
  }) {
    return UserG(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      isApproved: isApproved ?? this.isApproved,
      name: name ?? this.name,
      mail: mail ?? this.mail,
      activeFrom: activeFrom ?? this.activeFrom,
      activeTill: activeTill ?? this.activeTill,
      branchId: branchId ?? this.branchId,
      companyId: companyId ?? this.companyId,
      mobile: mobile ?? this.mobile,
      userType: userType ?? this.userType,
      memberType: memberType ?? this.memberType,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      genderId: genderId ?? this.genderId,
      bgId: bgId ?? this.bgId,
      height: height ?? this.height,
      bodyWeight: bodyWeight ?? this.bodyWeight,
      mobile1: mobile1 ?? this.mobile1,
      address: address ?? this.address,
      pincode: pincode ?? this.pincode,
      city: city ?? this.city,
      state: state ?? this.state,
      nationality: nationality ?? this.nationality,
      country: country ?? this.country,
      profession: profession ?? this.profession,
      maritalStatusId: maritalStatusId ?? this.maritalStatusId,
      services: services ?? this.services,
      medicalCondition: medicalCondition ?? this.medicalCondition,
      medication: medication ?? this.medication,
      physicalExercise: physicalExercise ?? this.physicalExercise,
      diet: diet ?? this.diet,
      referredById: referredById ?? this.referredById,
      referredByName: referredByName ?? this.referredByName,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

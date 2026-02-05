import 'package:healthandwellness/core/utility/helper.dart';

enum UserType { cwAdmin, admin, branchManager, receptionist, trainer, accountant, member }

final userTypeMap = {
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

  factory UserG.fromJSON(Map<String, dynamic> data) => UserG(
    id: parseString(data: data["id"], defaultValue: ""),
    isApproved: parseBool(data: data["isApproved"], defaultValue: false),
    isActive: parseBool(data: data["isActive"], defaultValue: false),
    name: parseString(data: data["name"], defaultValue: ""),
    mail: parseString(data: data["mail"], defaultValue: ""),
    branchId: parseString(data: data["branchId"], defaultValue: ""),
    companyId: parseString(data: data["companyId"], defaultValue: ""),
    mobile: parseString(data: data["mobile"], defaultValue: ""),
    userType: userTypeMap[parseString(data: data["userTypeId"], defaultValue: "")] ?? UserType.member,

    activeFrom: parseStringToEmptyDate(data: data["activeFrom"], predefinedDateFormat: "yyyy-MM-dd", defaultValue: null),
    activeTill: parseStringToEmptyDate(data: data["activeTill"], predefinedDateFormat: "yyyy-MM-dd", defaultValue: null),

    // 🔹 new mappings
    dob: parseString(data: data["dob"], defaultValue: ""),
    age: parseString(data: data["age"], defaultValue: ""),
    genderId: parseString(data: data["gender"], defaultValue: ""),
    bgId: parseString(data: data["bg"], defaultValue: ""),
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

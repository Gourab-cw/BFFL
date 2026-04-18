class CompanyModel {
  String? activeFrom;
  String? groupCompanyId;
  String? id;
  String? inactiveFrom;
  bool? isActive;
  bool? memberCreationMailSent;
  String? memberCreationMailTo;
  String? name;

  CompanyModel({
    this.activeFrom,
    this.groupCompanyId,
    this.id,
    this.inactiveFrom,
    this.isActive,
    this.memberCreationMailSent,
    this.memberCreationMailTo,
    this.name,
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

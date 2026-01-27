import 'package:healthandwellness/core/utility/helper.dart';

class UserG {
  String uid;
  String name;
  String mail;
  UserG({required this.uid, required this.name, required this.mail});

  factory UserG.fromJSON(Map<String,dynamic> data)=>UserG(uid: parseString(data: data["uid"], defaultValue: ""), name: parseString(data: data["displayName"], defaultValue: ""), mail: parseString(data: data["mail"], defaultValue: ""));

}

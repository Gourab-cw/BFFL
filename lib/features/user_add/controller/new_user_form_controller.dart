import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/core/utility/welcome_email_template.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/utility/firebase_service.dart';
import '../../login/data/user.dart';

// class NewUserFormControllerBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut(() => NewUserFormController(), fenix: true);
//     // TODO: implement dependencies
//   }
// }

class NewUserFormController extends GetxController {
  dynamic image;
  String id = '';
  final TextEditingController name = TextEditingController();
  String nameWithCode = '';
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  String dob = '';
  final TextEditingController mobile = TextEditingController();
  final TextEditingController mobile1 = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController city = TextEditingController(text: "Kolkata");
  final TextEditingController state = TextEditingController(text: "West Bengal");
  final TextEditingController nationality = TextEditingController(text: "Indian");
  final TextEditingController country = TextEditingController(text: "India");
  final TextEditingController profession = TextEditingController();
  final TextEditingController medicalCondition = TextEditingController();
  final TextEditingController medication = TextEditingController();
  final TextEditingController physicalExercise = TextEditingController();
  final TextEditingController diet = TextEditingController();
  final TextEditingController referredByName = TextEditingController();
  final TextEditingController referredByContact = TextEditingController();
  final TextEditingController referredByMail = TextEditingController();

  List<dynamic> documents = [];

  // picklist related (store ID or code as string)
  Map<String, dynamic> genderId = {};
  Map<String, dynamic> maritalStatusId = {};
  Map<String, dynamic> bloodGroupId = {};
  List<String> services = [];
  Map<String, dynamic> referredById = {};
  Future<void> saveNewMember() async {
    // try {
    final Authenticator userState = Get.find<Authenticator>();
    final FB fb = Get.find<FB>();
    final db = await fb.getDB();
    final auth = await fb.getAuth();

    if (email.text.isEmpty || !GetUtils.isEmail(email.text)) {
      throw Exception("Give a valid mail!");
    }
    if (name.text.isEmpty || name.text.length < 3) {
      throw Exception("Give a valid name!");
    }
    if (mobile.text.isEmpty || mobile.text.length < 8) {
      throw Exception("Give a valid contact!");
    }
    if (id == '') {
      int userHave = (await db.collection('User').where('mobile', isEqualTo: mobile.text.trim()).count().get()).count ?? 0;

      if (userHave > 0) {
        throw Exception("Different member with same phone number already exist!");
      }
    }
    String password = generateRandomPassword(length: 6);
    UserCredential? userCred;

    if (id == '') {
      userCred = await auth.createUserWithEmailAndPassword(email: email.text, password: password);
      if (userCred.user == null) {
        throw Exception("Error on new user making!");
      } else {
        id = userCred.user!.uid;
      }
    }

    String userTypeId = "";

    for (var f in userTypeMap.entries) {
      if (f.value == UserType.member) {
        userTypeId = f.key;
      }
    }
    String userName = '';
    String code = '';
    if (nameWithCode == '') {
      int count = (await db.collection('User').where('companyId', isEqualTo: userState.state!.companyId).count().get()).count ?? 0;
      userName =
          '${name.text.trim()} ( ${userState.branch?.name.toUpperCase().substring(0, 2)}-${(count + 1).toString().padLeft(4, '0')}-${DateFormat('yy').format(DateTime.now())} )';
      code = '${userState.branch?.name.toUpperCase().substring(0, 2)}-${(count + 1).toString().padLeft(4, '0')}-${DateFormat('yy').format(DateTime.now())}';
    } else {
      userName = nameWithCode.replaceAll(nameWithCode.split('(').first, "${name.text.trim()} ");
      code = nameWithCode.split('(').last.replaceAll(')', '').trim();
    }
    String searchTerm = name.text.trim().replaceAll(" ", "").toLowerCase();
    searchTerm += "${code.toLowerCase()}${mobile.text.toLowerCase()}${mobile1.text.toLowerCase()}".trim();
    Map<String, dynamic> data = {
      "id": id,
      "password": password,
      "name": userName,
      "displayName": name.text.trim(),
      "code": code,
      "searchTerm": searchTerm,
      "mail": email.text,
      "branchId": parseString(data: userState.state?.branchId, defaultValue: ""),
      "companyId": parseString(data: userState.state?.companyId, defaultValue: ""),
      "mobile": mobile.text,
      "mobile1": parseString(data: mobile1.text, defaultValue: ""),
      "userType": userTypeId,

      "activeFrom": "",
      "activeTill": "",
      "isApproved": false,
      "isActive": true,

      // 🔹 new mappings
      "dob": dob,
      "age": age.text,
      "genderId": parseString(data: genderId["id"], defaultValue: ""),
      "bgId": parseString(data: bloodGroupId["id"], defaultValue: ""),
      "height": height.text,
      "bodyWeight": weight.text,
      "profileImage": "",
      "address": address.text,
      "pincode": pincode.text,
      "city": city.text,
      "state": state.text,
      "nationality": nationality.text,
      "country": country.text,
      "profession": profession.text,
      "maritalStatusId": parseString(data: maritalStatusId["id"], defaultValue: ""),
      "services": services,
      "medicalCondition": medicalCondition.text,
      "medication": medication.text,
      "physicalExercise": physicalExercise.text,
      "diet": diet.text,
      "referredById": parseString(data: referredById["id"], defaultValue: ""),
      "referredByName": referredByName.text,
      "referredByMail": referredByMail.text,
      "referredByContact": referredByContact.text,
    };
    if (userCred == null) {
      data['isPosted'] = false;
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
    } else {
      data['updatedAt'] = FieldValue.serverTimestamp();
    }
    if (image != null && image is XFile) {
      File file = File(image!.path);
      final storage = await fb.getStorage();
      Reference ref = storage.ref().child('$id/profile/${image!.name}');
      try {
        UploadTask uploadTask = ref.putData(await image!.readAsBytes());
        await uploadTask;
        data["profileImage"] = await ref.getDownloadURL();
      } on FirebaseException catch (e) {
        throw Exception("Failed with error '${e.code}': ${e.message}");
      } catch (e) {
        throw Exception(e);
      }
    }
    List<String> docPaths = documents.whereType<String>().toList();
    if (documents.isNotEmpty) {
      List<XFile> docs = documents.whereType<XFile>().toList();
      for (int i = 0; i < docs.length; i++) {
        File file = File(docs[i].path);
        final storage = await fb.getStorage();
        Reference ref = storage.ref().child('$id/documents/${docs[i].name}');
        try {
          UploadTask uploadTask = ref.putData(await file.readAsBytes());
          await uploadTask;
          docPaths.add(await ref.getDownloadURL());
        } on FirebaseException catch (e) {
          throw Exception("Failed with error '${e.code}': ${e.message}");
        } catch (e) {
          throw Exception(e);
        }
      }
    }
    data["documents"] = docPaths;

    if (userCred == null) {
      await db.collection("User").doc(id).update(data);
    } else {
      await db.collection("User").doc(id).set(data);
      final authenticator = Get.find<Authenticator>();
      if (authenticator.company != null && authenticator.company!.memberCreationMailSent == true) {
        Dio dio = Dio();
        await dio.post(
          // "https://saleszing.in/apis/sendtheemail/sendtheemail.php",
          "https://saleszing.info/cwreact/utils/email/sendmailbyapp.php",
          data: {
            "replyToEmailId": authenticator.company!.memberCreationMailTo ?? "subirhore@circuitworld.in",
            "ccEmailId": "subirhore@circuitworld.in",
            "bccEmailId": "gourab.das@circuitworld.in",
            "toEmailId": authenticator.company!.memberCreationMailTo ?? "subirhore@circuitworld.in",
            "toSubject": "Welcome to Health and Wellness",
            "toBody": getWelcomeEmailTemplate(name: userName, email: email.text, password: password),
          },
        );
      }
      List<String> tokens = await getNotificationTokens(db);
      await Future.wait(
        tokens.toSet().toList().map((token) {
          return fb.sendNotification(token, "New Member Added!", "New Member Added - $userName");
        }),
      );
    }

    clear();
    update();
    // } catch (e) {
    //   throw Exception(e);
    // }
  }

  Future<List<String>> getNotificationTokens(FirebaseFirestore db) async {
    final users = await db
        .collection("User")
        .where("userType", whereIn: ["Fj3WvG9DjgG6ve0Xw3SF", "qeTcMMfWb1zzLwsNZDZW"])
        .where('isActive', isEqualTo: true)
        .get();
    List<String> tokens = [];
    for (var user in users.docs) {
      tokens.add(makeMapSerialize(user.data())["token"]);
    }
    return tokens;
  }

  Future<void> loadUser(UserG user) async {
    final FB fb = Get.find<FB>();
    final db = await fb.getDB();
    final Authenticator userState = Get.find<Authenticator>();
    if (userState.state == null || userState.state!.userType == UserType.member) {
      showAlert('You are not allowed to edit', AlertType.error);
      return;
    }
    if (user.isApproved) {
      showAlert('User already approved', AlertType.error);
      return;
    }
    image = user.profileImage == '' ? null : user.profileImage;

    if (user.genderId != "") {
      final gender = await db.collection('picklists').where('typeId', isEqualTo: "GENDER").where('id', isEqualTo: user.genderId).get();
      final gdata = makeMapSerialize(gender.docs.isNotEmpty ? gender.docs.first.data() : {});
      if (gdata["id"] != null) {
        genderId = {"id": gdata["id"], "name": gdata["name"]};
      }
    }
    if (user.maritalStatusId != "") {
      final maritalStatus = await db.collection('picklists').where('typeId', isEqualTo: "MARITAL_STATUS").where('id', isEqualTo: user.maritalStatusId).get();
      final maritalData = makeMapSerialize(maritalStatus.docs.isNotEmpty ? maritalStatus.docs.first.data() : {});
      if (maritalData["id"] != null) {
        maritalStatusId = {"id": maritalData["id"], "name": maritalData["name"]};
      }
    }
    if (user.bgId != "") {
      final bg = await db.collection('picklists').where('typeId', isEqualTo: "BLOOD_GROUP").where('id', isEqualTo: user.bgId).get();
      final bgdata = makeMapSerialize(bg.docs.isNotEmpty ? bg.docs.first.data() : {});
      if (bgdata["id"] != null) {
        bloodGroupId = {"id": bgdata["id"], "name": bgdata["name"]};
      }
    }
    if (user.referredById != "") {
      final ref = await db.collection('picklists').where('typeId', isEqualTo: "REFERRED").where('id', isEqualTo: user.referredById).get();
      final refdata = makeMapSerialize(ref.docs.isNotEmpty ? ref.docs.first.data() : {});
      if (refdata["id"] != null) {
        referredById = {"id": refdata["id"], "name": refdata["name"]};
      }
    }

    id = user.id;
    name.text = user.displayName;
    nameWithCode = user.name;
    email.text = user.mail;
    mobile.text = user.mobile;
    mobile1.text = user.mobile1;
    age.text = user.age;
    height.text = user.height;
    weight.text = user.bodyWeight;
    dob = user.dob;
    documents = user.documents;

    address.text = user.address;
    pincode.text = user.pincode;
    city.text = user.city;
    state.text = user.state;

    nationality.text = user.nationality;
    country.text = user.country;
    profession.text = user.profession;

    medicalCondition.text = user.medicalCondition;
    medication.text = user.medication;
    physicalExercise.text = user.physicalExercise;
    diet.text = user.diet;
    referredByName.text = user.referredByName;

    referredByMail.text = user.referredByMail;
    referredByContact.text = user.referredByContact;

    services = user.services;
  }

  void clear() {
    id = '';
    image = null;
    name.clear();
    email.clear();
    phone.clear();
    age.clear();
    height.clear();
    weight.clear();
    dob = '';
    documents = [];
    mobile.clear();
    mobile1.clear();
    address.clear();
    pincode.clear();
    city.clear();
    state.clear();
    nationality.clear();
    country.clear();
    profession.clear();
    medicalCondition.clear();
    medication.clear();
    physicalExercise.clear();
    diet.clear();
    referredByName.clear();
    referredByMail.clear();
    referredByContact.clear();

    // picklist related (store ID or code as string)
    genderId = {};
    maritalStatusId = {};
    bloodGroupId = {};
    services = [];
    referredById = {};
    nameWithCode = '';
  }
}

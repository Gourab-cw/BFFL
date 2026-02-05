import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utility/firebase_service.dart';
import '../../login/data/user.dart';

class NewUserFormControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewUserFormController(), fenix: true);
    // TODO: implement dependencies
  }
}

class NewUserFormController extends GetxController {
  XFile? image;
  final TextEditingController name = TextEditingController();
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

  // picklist related (store ID or code as string)
  Map<String, dynamic> genderId = {};
  Map<String, dynamic> maritalStatusId = {};
  Map<String, dynamic> bloodGroupId = {};
  List<String> services = [];
  Map<String, dynamic> referredById = {};

  Future<void> saveNewMember() async {
    try {
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
      String password = generateRandomPassword(length: 6);
      final userCred = await auth.createUserWithEmailAndPassword(email: email.text, password: password);
      String userTypeId = "";

      for (var f in userTypeMap.entries) {
        if (f.value == UserType.member) {
          userTypeId = f.key;
        }
      }
      if (userCred.user == null) {
        throw Exception("Error on new user making!");
      }
      Map<String, dynamic> data = {
        "id": userCred.user?.uid,
        "password": password,
        "name": name.text.trim(),
        "searchTerm": name.text.trim().replaceAll(" ", "").toLowerCase(),
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
        "createdAt": FieldValue.serverTimestamp(),
      };
      if (image != null && userCred.user?.uid != null) {
        File file = File(image!.path);
        final storage = await fb.getStorage();
        Reference ref = storage.ref().child('${userCred.user?.uid}/profile/${image!.name}');
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
      await db.collection("User").doc(userCred.user!.uid).set(data);
      clear();
      update();
    } catch (e) {
      throw Exception(e);
    }
  }

  void clear() {
    image = null;
    name.clear();
    email.clear();
    phone.clear();
    age.clear();
    height.clear();
    weight.clear();
    dob = '';
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

    // picklist related (store ID or code as string)
    genderId = {};
    maritalStatusId = {};
    bloodGroupId = {};
    services = [];
    referredById = {};
  }
}

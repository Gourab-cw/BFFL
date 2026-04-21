import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/Company/data/company_model.dart';
import 'package:healthandwellness/core/Theme/theme.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/home/controller/home_controller.dart';
import 'package:healthandwellness/features/login/data/user.dart';

import '../../../core/branch/data/branch_model.dart';
import '../../../core/utility/firebase_service.dart';

class Authenticator extends GetxController {
  UserG? state;

  CompanyModel? company;
  BranchModel? branch;
  Stream<User?>? authCheck;
  late FB _firebase;
  @override
  void onInit() async {
    // TODO: implement onInit
    final FB fb = Get.find<FB>();
    _firebase = fb;
    super.onInit();
  }

  Future<bool> checkIfUserLogin() async {
    final auth = await _firebase.getAuth();
    // final User? u = await auth.authStateChanges().where((u) => u != null).first.timeout(const Duration(seconds: 5));
    final User? u = auth.currentUser;
    debugPrint("coming here,$u");
    if (u != null) {
      debugPrint("coming here,$u");
      User user = u;
      FirebaseFirestore db = await _firebase.getDB();
      final querySnapshot = await db.collection("User").doc(user.uid).get();
      if (querySnapshot.exists && makeMapSerialize(querySnapshot.data())["isActive"] == true) {
        if (_firebase.token != null) {
          await db.collection("User").doc(user.uid).update({"token": _firebase.token});
        }
        state = UserG.fromJSON(makeMapSerialize(querySnapshot.data()));

        final branchResp = await db.collection('Branch').doc(state!.branchId).get();
        branch = BranchModel.fromFirestore(branchResp);

        final companyResp = await db.collection('Company').doc(state!.companyId).get();
        company = CompanyModel.fromJson(makeMapSerialize(companyResp.data()));

        MainStore mainStore = Get.find<MainStore>();
        if (state!.userType == UserType.admin) {
          mainStore.theme.value = BergerTheme.themes[1];
        }
        if (state!.userType == UserType.member) {
          mainStore.theme.value = BergerTheme.themes[2];
        }
        if (state!.userType == UserType.accountant) {
          mainStore.theme.value = BergerTheme.themes[5];
        }
        if (state!.userType == UserType.trainer) {
          mainStore.theme.value = BergerTheme.themes[10];
        }
        if (state!.userType == UserType.receptionist) {
          mainStore.theme.value = BergerTheme.themes[7];
        }

        update();
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> emailLogin({required String email, required String password}) async {
    try {
      FirebaseFirestore db = await _firebase.getDB();
      final User? user = await _firebase.makeEmailLogin(email: email, password: password);
      if (user == null) {
        return false;
      }
      final resp = await db.collection("User").doc(user.uid).get();
      if (!resp.exists) {
        showAlert("No user found", AlertType.error);
        return false;
      }
      UserG userG = UserG.fromJSON(makeMapSerialize(resp.data()));
      if (userG.userType == UserType.member && (userG.isActive == false || userG.isApproved == false)) {
        showAlert("Approval in process – we’ll notify you soon.", AlertType.error);
        return false;
      }

      MainStore mainStore = Get.find<MainStore>();
      final userData = await db.collection("User").doc(user.uid).get();

      if (userData.exists && makeMapSerialize(userData.data())["isActive"] == true) {
        print("coming here1");
        if (_firebase.token != null) {
          await db.collection("User").doc(user.uid).update({"token": _firebase.token});
        }
        // UserG user0 = UserG.fromJSON(makeMapSerialize(resp.data()));
        // if (user0.userType == UserType.member && (!user0.isActive || !user0.isApproved)) {
        //   showAlert("Approval in process – we’ll notify you soon.", AlertType.error);
        //   return false;
        // }
        state = UserG.fromJSON(makeMapSerialize(userData.data()));
        final branchResp = await db.collection('Branch').doc(state!.branchId).get();
        branch = BranchModel.fromFirestore(branchResp);

        final companyResp = await db.collection('Company').doc(state!.companyId).get();
        company = CompanyModel.fromJson(makeMapSerialize(companyResp.data()));

        if (state!.userType == UserType.admin) {
          mainStore.theme.value = BergerTheme.themes[1];
        }
        if (state!.userType == UserType.trainer) {
          // mainStore.theme.value = BergerTheme.themes[6];
          mainStore.theme.value = BergerTheme.themes[10];
        }
        if (state!.userType == UserType.receptionist) {
          mainStore.theme.value = BergerTheme.themes[7];
        }
        if (state!.userType == UserType.accountant) {
          mainStore.theme.value = BergerTheme.themes[5];
        }
        if (state!.userType == UserType.member) {
          mainStore.theme.value = BergerTheme.themes[2];
        }
        update();
        return true;
      } else {
        showAlert("Unauthorized access!", AlertType.error);
        return false;
      }

      showAlert("No user found", AlertType.error);
      return false;
      // 3️⃣ Update state
    } catch (e) {
      showAlert("$e", AlertType.error);
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      final auth = await _firebase.getAuth();
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        await homeController.ss?.cancel();
        Get.delete<HomeController>();
      }
      await auth.signOut();
      final mainStore = Get.find<MainStore>();
      mainStore.theme.value = BergerTheme.themes[11];
      mainStore.bottomNavBarIndex.value = 0;
      state = null;
      branch = null;
      company = null;
      update();
      // Get.offAllNamed("/login");
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> addUser({required String email, required String password, required String name}) async {
    try {
      // 2️⃣ Call _firebase function
      final User? user = await _firebase.createNewUser(email: email, password: password, name: name);

      // 3️⃣ Update state
      // state = user;
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }
}

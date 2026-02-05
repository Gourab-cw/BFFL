import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';

import '../../../core/utility/firebase_service.dart';

class Authenticator extends GetxController {
  UserG? state;
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
    final User? u = await auth.authStateChanges().where((u) => u != null).first.timeout(const Duration(seconds: 5));

    if (u != null) {
      User user = u;
      FirebaseFirestore db = await _firebase.getDB();
      final querySnapshot = await db.collection("User").doc(user.uid).get();
      if (querySnapshot.exists && makeMapSerialize(querySnapshot.data())["isActive"] == true) {
        if (_firebase.token != null) {
          await db.collection("User").doc(user.uid).update({"token": _firebase.token});
        }
        state = UserG.fromJSON(makeMapSerialize(querySnapshot.data()));
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
      final User? user = await _firebase.makeEmailLogin(email: email, password: password);
      if (user != null) {
        FirebaseFirestore db = await _firebase.getDB();
        final querySnapshot = await db.collection("User").doc(user.uid).get();
        if (querySnapshot.exists && makeMapSerialize(querySnapshot.data())["isActive"] == true) {
          if (_firebase.token != null) {
            await db.collection("User").doc(user.uid).update({"token": _firebase.token});
          }
          logG(makeMapSerialize(querySnapshot.data()));
          state = UserG.fromJSON(makeMapSerialize(querySnapshot.data()));
          update();
          return true;
        } else {
          return false;
        }
      }
      return false;
      // 3️⃣ Update state
    } catch (e) {
      return false;
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> logOut() async {
    try {
      final auth = await _firebase.getAuth();
      await auth.signOut();
      state = null;
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

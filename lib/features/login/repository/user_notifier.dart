import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:get/get.dart';
import '../../../app/firebase_provider.dart';

class UserNotifier extends Notifier<UserG?> {
  late FirebaseG firebase;

  @override
  UserG? build() {
    firebase = ref.read(firebaseProvider);
    return null;
  }

  Future<bool> checkIfUserLogin() async {
    final auth = await firebase.getAuth();
    if (auth.currentUser != null) {
      User user = auth.currentUser!;
      FirebaseFirestore db = await firebase.getDB();
      final querySnapshot = await db.collection("User").doc(user.uid).get();
      if(querySnapshot.exists && querySnapshot["isActive"]==true){
        if(firebase.token!=null){
          await db.collection("User").doc(user.uid).update({"token":firebase.token});
        }
        state = UserG.fromJSON(makeMapSerialize(querySnapshot.data()));
        return true;
      }
      else{
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> emailLogin({required String email, required String password}) async {
    try {
      // 1️⃣ Get Firebase instance
      final firebase = ref.read(firebaseProvider);

      // 2️⃣ Call Firebase function
      final User? user = await firebase.makeEmailLogin(email: email, password: password);

      if(user!=null){
        FirebaseFirestore db = await firebase.getDB();
        final querySnapshot = await db.collection("User").doc(user.uid).get();
        if(querySnapshot.exists && querySnapshot["isActive"]==true){
          if(firebase.token!=null){
            await db.collection("User").doc(user.uid).update({"token":firebase.token});
          }
          state = UserG.fromJSON(makeMapSerialize(querySnapshot.data()));
          return true;
        }else{
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

  Future<void> logOut()async{
    try{
      final auth = await firebase.getAuth();
      await auth.signOut();
      state=null;
      Get.offAllNamed("/login");
    }catch(e){
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> addUser({required String email, required String password, required String name}) async {
    try {
      final firebase = ref.read(firebaseProvider);

      // 2️⃣ Call Firebase function
      final User? user = await firebase.createNewUser(email: email, password: password, name: name);

      // 3️⃣ Update state
      // state = user;
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }
}

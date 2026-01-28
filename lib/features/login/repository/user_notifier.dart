import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:get/get.dart';
import '../../../app/firebase_provider.dart';
import '../../../core/Picklist/picklist_item.dart';

class UserNotifier extends Notifier<UserG?> {
  late FirebaseG firebase;

  @override
  UserG? build() {
    firebase = ref.read(firebaseProvider);
    return null;
  }

  Future<void> seedPicklists(List<PicklistItem> items,FirebaseFirestore db) async {
    final batch = db.batch();


    for (final item in items) {
      final docId = '${item.typeId}_${item.id}';
      final ref = db
          .collection('picklists')
          .doc(docId);


      batch.set(
        ref,
        {
          ...item.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }


    await batch.commit();
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
        await seedPicklists([
          // Gender
          PicklistItem(id: 'MALE', name: 'Male', typeId: 'GENDER', order: 1),
          PicklistItem(id: 'FEMALE', name: 'Female', typeId: 'GENDER', order: 2),
          PicklistItem(id: 'OTHER', name: 'Other', typeId: 'GENDER', order: 3),

          // Blood Group
          PicklistItem(id: 'A_POS', name: 'A+', typeId: 'BLOOD_GROUP', order: 1),
          PicklistItem(id: 'A_NEG', name: 'A-', typeId: 'BLOOD_GROUP', order: 2),
          PicklistItem(id: 'B_POS', name: 'B+', typeId: 'BLOOD_GROUP', order: 3),
          PicklistItem(id: 'B_NEG', name: 'B-', typeId: 'BLOOD_GROUP', order: 4),
          PicklistItem(id: 'O_POS', name: 'O+', typeId: 'BLOOD_GROUP', order: 5),
          PicklistItem(id: 'O_NEG', name: 'O-', typeId: 'BLOOD_GROUP', order: 6),
          PicklistItem(id: 'AB_POS', name: 'AB+', typeId: 'BLOOD_GROUP', order: 7),
          PicklistItem(id: 'AB_NEG', name: 'AB-', typeId: 'BLOOD_GROUP', order: 8),

          // Marital Status
          PicklistItem(id: 'SINGLE', name: 'Single', typeId: 'MARITAL_STATUS', order: 1),
          PicklistItem(id: 'MARRIED', name: 'Married', typeId: 'MARITAL_STATUS', order: 2),
        ],db);
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

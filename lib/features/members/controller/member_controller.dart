import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utility/firebase_service.dart';
import '../../Payment/data/payment_model.dart';
import '../../login/data/user.dart';

class MemberControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MemberController(), fenix: true);
    // TODO: implement dependencies
  }
}

class MemberController extends GetxController {
  List<UserG> members = [];
  List<PaymentModel> payments = [];
  final auth = Get.find<Authenticator>();
  RxBool isSearching = false.obs;
  UserG? selectedUser;
  // int currentPage = 1;
  // int totalFetchLimit = 20;
  TextEditingController search = TextEditingController();
  Future<void> searchMembers(FirebaseFirestore db) async {
    String s = search.text.trim();
    if (s.isEmpty && members.isEmpty) {
      fetchMembers(db);
    }
    if (s.isEmpty) {
      return;
    }
    try {
      isSearching.value = true;
      final futures = await Future.wait([
        db
            .collection("User")
            .where("userType", isEqualTo: userTypeMap2[UserType.member])
            .where("isActive", isEqualTo: true)
            .where("searchTerm", isGreaterThanOrEqualTo: s)
            .where("searchTerm", isLessThanOrEqualTo: '$s\uf8ff')
            .limit(20)
            .get(),

        db
            .collection("User")
            .where("userType", isEqualTo: userTypeMap2[UserType.member])
            .where("isActive", isEqualTo: true)
            .where("code", isGreaterThanOrEqualTo: s)
            .where("code", isLessThanOrEqualTo: '$s\uf8ff')
            .limit(20)
            .get(),

        db
            .collection("User")
            .where("userType", isEqualTo: userTypeMap2[UserType.member])
            .where("isActive", isEqualTo: true)
            .where("mobile", isGreaterThanOrEqualTo: s)
            .where("mobile", isLessThanOrEqualTo: '$s\uf8ff')
            .limit(20)
            .get(),

        db
            .collection("User")
            .where("userType", isEqualTo: userTypeMap2[UserType.member])
            .where("isActive", isEqualTo: true)
            .where("mobile1", isGreaterThanOrEqualTo: s)
            .where("mobile1", isLessThanOrEqualTo: '$s\uf8ff')
            .limit(20)
            .get(),
      ]);

      // Merge and remove duplicates
      final Map<String, QueryDocumentSnapshot> uniqueDocs = {};

      for (final snapshot in futures) {
        for (final doc in snapshot.docs) {
          uniqueDocs[doc.id] = doc;
        }
      }
      final results = uniqueDocs.values.toList();
      members = results.map((doc) => UserG.fromJSON(makeMapSerialize(doc.data()))).toList();
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    } finally {
      isSearching.value = false;
    }
  }

  // Future<void> init(FirebaseFirestore db) async {
  //   try {
  //     final resp = await db.collection("User").where("userType", isEqualTo: userTypeMap2[UserType.member]).get();
  //     List<UserG> localMembers = resp.docs.map((doc) => UserG.fromJSON(makeMapSerialize(doc.data()))).toList();
  //
  //     final batch = db.batch();
  //     for (UserG user in localMembers) {
  //       String searchTerm = user.displayName.replaceAll(" ", "").toLowerCase();
  //       searchTerm += "${user.code.toLowerCase()}${user.mobile.toLowerCase()}${user.mobile1.toLowerCase()}".trim();
  //       batch.update(db.collection('User').doc(user.id), {'searchTerm': searchTerm});
  //     }
  //     await batch.commit();
  //   } catch (e) {
  //     showAlert("$e", AlertType.error);
  //   } finally {
  //     isSearching.value = false;
  //   }
  // }

  Future<void> updateMembersDocumentImage(XFile data, FirebaseFirestore db) async {
    if (selectedUser == null) {
      return;
    }
    File file = File(data.path);
    final fb = Get.find<FB>();
    final storage = await fb.getStorage();
    Reference ref = storage.ref().child('${selectedUser!.id}/documents/${data.name}');
    try {
      UploadTask uploadTask = ref.putData(await file.readAsBytes());
      await uploadTask;
      final path = await ref.getDownloadURL();
      selectedUser!.documents.remove(data);
      selectedUser!.documents.add(path);
      await db.collection('User').doc(selectedUser!.id).update({'documents': selectedUser!.documents});
      update();
    } on FirebaseException catch (e) {
      throw Exception("Failed with error '${e.code}': ${e.message}");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchMembers(FirebaseFirestore db) async {
    final user = auth.state;
    if (user == null) {
      throw Exception('Unable to authenticate');
    }
    Query<Map<String, dynamic>> query = db.collection('User').where("userType", isEqualTo: userTypeMap2[UserType.member]).where("isActive", isEqualTo: true);

    if (user.userType != UserType.admin) {
      query = query.where('branchId', isEqualTo: user.branchId);
    }

    final resp = await query.limit(8).get();
    members = resp.docs.map((doc) => UserG.fromJSON(makeMapSerialize(doc.data()))).toList();
    update();
  }

  Future<List<UserG>> getMembersById(List<String> ids, FirebaseFirestore db) async {
    final user = auth.state;
    if (user == null) {
      throw Exception('Unable to authenticate');
    }
    Query<Map<String, dynamic>> query = db.collection('User').where("id", whereIn: ids).where("isActive", isEqualTo: true);

    if (user.userType != UserType.admin) {
      query = query.where('branchId', isEqualTo: user.branchId);
    }

    final resp = await query.get();
    return resp.docs.map((doc) => UserG.fromJSON(makeMapSerialize(doc.data()))).toList();
  }

  Future<void> makeApprove(UserG user, FirebaseFirestore db) async {
    await db.collection('User').doc(user.id).update({"isApproved": true, 'activeFrom': Timestamp.now()});
  }

  Future<void> getPaymentList({force = false}) async {
    if (!force && payments.isNotEmpty) return;
    final user = auth.state;
    if (user == null) {
      throw Exception('Unable to authenticate');
    }
    if (selectedUser == null) {
      throw Exception('No user selected');
    }
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    final resp = await db.collection('payment').where('userId', isEqualTo: selectedUser!.id).get();
    payments = resp.docs.map((doc) => PaymentModel.fromJson(makeMapSerialize(doc.data()))).toList();
    update();
  }

  Disposer addListener(GetStateUpdate listener) {
    // TODO: implement addListener
    if (payments.isNotEmpty) {
      getPaymentList(force: true);
    }
    return super.addListener(listener);
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/session_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:intl/intl.dart';

import '../../Service/data/service.dart';

class SlotDetailsController extends GetxController {
  SlotModel? slot;
  List<SessionModel> sessions = [];

  SessionModel? selectedSession;

  TextEditingController remarks = TextEditingController();
  TextEditingController feedbackCtrl = TextEditingController();
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? sessionListener;

  Future<void> giveFeedback(SessionModel sm) async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    if (feedbackCtrl.text.trim().isEmpty) {
      throw Exception("Enter proper feedback to continue!");
    }
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    try {
      await db.collection('session').doc(sm.id).update({'trainerFeedback': feedbackCtrl.text.trim()});
    } on FirebaseException catch (e) {
      throw Exception("${e.message}");
    } catch (e) {
      throw Exception("${e}");
    }
  }

  Future<void> getSlotDetails({SlotModel? selectedSlot}) async {
    if (slot == null) {
      if (selectedSlot == null) {
        throw Exception("Slot not found!");
      } else {
        slot = selectedSlot;
      }
    }
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    if (slot!.trainerName == null || slot!.trainerName == "") {
      final trainerResp = await db.collection('User').doc(slot!.trainerId).get();
      UserG trainer = UserG.fromJSON(makeMapSerialize(trainerResp.data()));
      slot = slot!.copyWith(trainerName: trainer.name);
    }
    sessionListener = db.collection('session').where('slotId', isEqualTo: slot!.id).where('isActive', isEqualTo: true).snapshots().listen((data) async {
      for (var f in data.docChanges) {
        final ss = SessionModel.fromFirestore(f.doc);
        switch (f.type) {
          case DocumentChangeType.added:
            if (sessions.indexWhere((s) => s.id == ss.id) == -1) {
              sessions.add(ss);
              await updateSession(db, ss);
              EasyDebounce.debounce("sessionUpdate", const Duration(milliseconds: 600), () {
                update();
              });
            }
            break;

          case DocumentChangeType.modified:
            int index = sessions.indexWhere((s) => s.id == ss.id);
            sessions.replaceRange(index, index + 1, [ss]);
            await updateSession(db, ss);
            EasyDebounce.debounce("sessionUpdate", const Duration(milliseconds: 600), () {
              update();
            });
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            throw UnimplementedError();
        }
      }
    });
  }

  Future<void> endSlot() async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    try {
      await db.collection('slots').doc(slot!.id).update({'completeAt': Timestamp.now(), 'hasComplete': true});
      final resp = await db.collection('slots').doc(slot!.id).get();
      if (resp.exists && resp.data() != null) {
        slot = SlotModel.fromFirestore(resp);
        update();
      }
    } on FirebaseException catch (e) {
      showAlert("${e.message}", AlertType.error);
    } catch (e) {
      showAlert("${e}", AlertType.error);
    }
  }

  Future<void> markAttendance(SessionModel sm) async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception("User not found!");
    }
    final db = await fb.getDB();
    try {
      await db.collection('session').doc(sm.id).update({'attendedAt': Timestamp.now(), 'hasAttend': true, 'attendanceGivenBy': auth.state!.id});
      await db.collection('slots').doc(sm.slotId).update({'totalAttend': FieldValue.increment(1)});
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<void> endSessionAndSlot() async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception("User not found!");
    }
    final db = await fb.getDB();
    final batch = db.batch();
    try {
      final resp1 = await db.collection('session').where('slotId', isEqualTo: slot!.id).get();
      List<String> slotIds = resp1.docs.map((m) => parseString(data: makeMapSerialize(m.data())["id"], defaultValue: "")).toList();
      for (final s in slotIds) {
        batch.update(db.collection('session').doc(s), {'completeAt': Timestamp.now()});
      }
      batch.update(db.collection('slots').doc(slot!.id), {'completeAt': Timestamp.now()});
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<void> startSession() async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception("User not found!");
    }
    final db = await fb.getDB();
    final batch = db.batch();
    try {
      if (parseInt(data: slot!.startTime.replaceAll(':', '')) > parseInt(data: DateFormat('HH:mm').format(DateTime.now()))) {
        throw Exception("Session can start only after ${slot!.startTime}");
      }
      batch.update(db.collection('slots').doc(slot!.id), {'trainerStartTime': Timestamp.now()});
      await batch.commit();
      slot = SlotModel.fromFirestore(await db.collection('slots').doc(slot!.id).get());
      update();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<void> giveRemarks(String remarks) async {
    if (slot == null) {
      throw Exception("Slot not found!");
    }
    final fb = Get.find<FB>();
    final auth = Get.find<Authenticator>();
    if (auth.state == null) {
      throw Exception("User not found!");
    }
    final db = await fb.getDB();
    final batch = db.batch();
    try {
      batch.update(db.collection('slots').doc(slot!.id), {'trainerRemarks': remarks});
      await batch.commit();
      slot = SlotModel.fromFirestore(await db.collection('slots').doc(slot!.id).get());
      update();
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<void> updateSession(FirebaseFirestore db, SessionModel s) async {
    String userId = s.memberId;
    final resp1 = await db.collection("User").where('id', isEqualTo: userId).where('isActive', isEqualTo: true).get();
    Map<String, String> users = {};
    resp1.docs.forEach((f) {
      users[makeMapSerialize(f.data())['id'] ?? ""] = makeMapSerialize(f.data())['name'] ?? "";
    });
    sessions = sessions.map((m) => m.copyWith(memberName: users[m.memberId])).toList();
  }

  Future<List<UserG>> getOtherTrainers(SlotModel s) async {
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    String serviceId = s.serviceId;
    final serviceResp = await db.collection('Subscription').doc(serviceId).get();
    final serviceData = makeMapSerialize(serviceResp.data());
    if (serviceData.isEmpty) {
      return [];
    }
    final service = ServiceModel.fromJson(serviceData);
    final trainerIds = service.trainerId.where((t) => t != s.trainerId);
    if (trainerIds.isEmpty) {
      return [];
    }
    final resp1 = await db.collection("User").where('id', whereIn: trainerIds.toList()).where('isActive', isEqualTo: true).get();
    List<UserG> users = [];
    for (var f in resp1.docs) {
      users.add(UserG.fromJSON(makeMapSerialize(f.data())));
    }
    return users;
  }

  Future<void> updateSlotData(SlotModel s, String serviceName, String trainerId, String trainerName, String trainerToken) async {
    final fb = Get.find<FB>();
    final db = await fb.getDB();
    await db.collection('slots').doc(s.id).update({'trainerId': trainerId});
    slot = SlotModel.fromFirestore(await db.collection('slots').doc(s.id).get());
    update();

    final users = await db
        .collection("User")
        .where("userType", whereIn: ["Fj3WvG9DjgG6ve0Xw3SF", "qeTcMMfWb1zzLwsNZDZW"])
        .where('isActive', isEqualTo: true)
        .get();
    List<String> tokens = [];
    List<String> memberTokens = [];
    for (var user in users.docs) {
      tokens.add(makeMapSerialize(user.data())["token"]);
    }
    final sessionData = await db.collection('session').where('slotId', isEqualTo: s.id).where('isActive', isEqualTo: true).get();
    final bookedMemberIds = sessionData.docs.map((m) => SessionModel.fromFirestore(m)).map((m) => m.memberId).toList();
    if (bookedMemberIds.isNotEmpty) {
      final memberData = await db.collection('User').where('id', whereIn: bookedMemberIds).where('isActive', isEqualTo: true).get();
      memberTokens = memberData.docs.map((m) => makeMapSerialize(m.data())["token"]).whereType<String>().toList();
    }

    await Future.wait(
      <String>{...tokens, ...memberTokens}.toList().map((t) async {
        return fb.sendNotification(t, "New Trainer Assigned", "$trainerName has been assigned to ${s.date} ${s.startTime}-${s.endTime} slot ( $serviceName )");
      }),
    );

    await fb.sendNotification(trainerToken, "New Slot Assigned", "You have been assigned to ${s.date} ${s.startTime}-${s.endTime} slot ( $serviceName )");
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    sessionListener?.pause();
    await sessionListener?.cancel();
    super.dispose();
  }
}

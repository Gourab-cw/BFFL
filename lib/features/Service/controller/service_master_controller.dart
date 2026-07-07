import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:image_picker/image_picker.dart';

class ServiceMasterController extends GetxController {
  List<ServiceModel> services = [];
  List<Map<String, String>> categories = [];
  List<UserG> trainers = [];
  String searchKey = "";

  late FirebaseFirestore db;
  final FB fb = Get.find<FB>();
  final Authenticator auth = Get.find<Authenticator>();

  @override
  Future<void> onInit() async {
    db = await fb.getDB();
    super.onInit();
  }

  Future<void> getInitialData() async {
    await fetchServices();
    await fetchCategories();
    await fetchTrainers();
  }

  Future<void> fetchServices() async {
    try {
      final resp = await db.collection("Subscription").get();
      services = resp.docs.map((doc) => ServiceModel.fromJson(makeMapSerialize(doc.data()))).toList();
      services.sort((a, b) => a.name.compareTo(b.name));
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final user = auth.state;
      if (user == null) throw Exception("User not found");
      final resp = await db.collection("category").where("companyId", isEqualTo: user.companyId).where("isActive", isEqualTo: true).get();
      categories = resp.docs.map((doc) {
        final data = makeMapSerialize(doc.data());
        return {
          "id": parseString(data: data["id"], defaultValue: ""),
          "name": parseString(data: data["name"], defaultValue: ""),
        };
      }).toList();
      categories.sort((a, b) => (a["name"] ?? "").compareTo(b["name"] ?? ""));
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> fetchTrainers() async {
    try {
      final resp = await db.collection("User").where("userType", isEqualTo: "JoVVKfIcwkccunAFqIdy").where("isActive", isEqualTo: true).get();
      trainers = resp.docs.map((doc) => UserG.fromJSON(makeMapSerialize(doc.data()))).toList();
      trainers.sort((a, b) => a.name.compareTo(b.name));
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> toggleServiceActive(ServiceModel service) async {
    try {
      final updatedStatus = !service.isActive;
      await db.collection("Subscription").doc(service.id).update({"isActive": updatedStatus});
      int index = services.indexWhere((s) => s.id == service.id);
      if (index != -1) {
        services[index] = service.copyWith(isActive: updatedStatus);
        update();
      }
      showAlert("Service status updated successfully", AlertType.success);
    } catch (e) {
      showAlert("Failed to toggle status: $e", AlertType.error);
    }
  }

  Future<void> saveService(ServiceModel model, {XFile? imageFile}) async {
    try {
      final user = auth.state;
      if (user == null) throw Exception("User not found");

      String imageUrl = model.image;

      if (imageFile != null) {
        final storage = await fb.getStorage();
        Reference ref = storage.ref().child('Subscription/${model.id}/${imageFile.name}');
        UploadTask uploadTask = ref.putData(await imageFile.readAsBytes());
        await uploadTask;
        imageUrl = await ref.getDownloadURL();
      }

      final serviceToSave = model.copyWith(
        image: imageUrl,
        companyId: user.companyId,
      );

      final Map<String, dynamic> data = serviceToSave.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await db.collection("Subscription").doc(model.id).set(data, SetOptions(merge: true));

      int index = services.indexWhere((s) => s.id == model.id);
      if (index == -1) {
        services.add(serviceToSave);
      } else {
        services[index] = serviceToSave;
      }
      services.sort((a, b) => a.name.compareTo(b.name));
      update();

      showAlert("Service saved successfully", AlertType.success);
    } catch (e) {
      showAlert("Failed to save service: $e", AlertType.error);
      rethrow;
    }
  }
}

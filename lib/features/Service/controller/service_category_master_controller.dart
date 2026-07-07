import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/category.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';

class ServiceCategoryMasterController extends GetxController {
  List<CategoryModel> categories = [];
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
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final user = auth.state;
      if (user == null) throw Exception("User not found");

      // Query categories for this company
      final resp = await db
          .collection("category")
          .where("companyId", isEqualTo: user.companyId)
          .get();

      categories = resp.docs
          .map((doc) => CategoryModel.fromJson(makeMapSerialize(doc.data())))
          .toList();

      categories.sort((a, b) => a.name.compareTo(b.name));
      update();
    } catch (e) {
      showAlert("$e", AlertType.error);
    }
  }

  Future<void> toggleCategoryActive(CategoryModel category) async {
    try {
      final updatedStatus = !category.isActive;
      await db.collection("category").doc(category.id).update({"isActive": updatedStatus});
      
      int index = categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        categories[index] = category.copyWith(isActive: updatedStatus);
        update();
      }
      showAlert("Category status updated successfully", AlertType.success);
    } catch (e) {
      showAlert("Failed to toggle status: $e", AlertType.error);
    }
  }

  Future<void> saveCategory(CategoryModel category) async {
    try {
      final user = auth.state;
      if (user == null) throw Exception("User not found");

      final categoryToSave = category.copyWith(
        companyId: user.companyId,
        branchId: user.branchId,
      );

      final Map<String, dynamic> data = categoryToSave.toJson();
      data['updatedAt'] = FieldValue.serverTimestamp();

      await db.collection("category").doc(category.id).set(data, SetOptions(merge: true));

      int index = categories.indexWhere((c) => c.id == category.id);
      if (index == -1) {
        categories.add(categoryToSave);
      } else {
        categories[index] = categoryToSave;
      }
      categories.sort((a, b) => a.name.compareTo(b.name));
      update();

      showAlert("Category saved successfully", AlertType.success);
    } catch (e) {
      showAlert("Failed to save category: $e", AlertType.error);
      rethrow;
    }
  }
}

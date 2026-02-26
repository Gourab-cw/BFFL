import 'package:get/get.dart';
import 'package:healthandwellness/core/branch/data/branch_model.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';

class BranchController extends GetxController {
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();
  List<BranchModel> list = [];

  Future<void> getBranchList() async {
    final db = await fb.getDB();
    final resp = await db.collection('Branch').get();
    list = resp.docs.map((m) => BranchModel.fromFirestore(m)).toList();
    update();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    try{
      getBranchList();
    }catch(e){
      showAlert("$e", AlertType.error);
    }
    super.onInit();
  }
}

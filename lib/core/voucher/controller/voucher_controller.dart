import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/core/voucher/model/voucher_model.dart';

import '../../../features/login/repository/authenticator.dart';
import '../../utility/firebase_service.dart';

class VoucherController extends GetxController {
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();
  List<VoucherModel> list = [];
  Future<VoucherModel?> getReceiptVoucher() async {
    final db = await fb.getDB();
    final user = auth.state;
    if (user == null) {
      throw Exception('Not Authenticated');
    }
    if (list.isNotEmpty) {
      final voucher = list.firstWhereOrNull((l) => l.isActive && l.branchId == user.branchId && l.docTypeId == 15);
      if (voucher != null) {
        return voucher;
      }
    }
    final resp = await db
        .collection('voucherType')
        .where('docTypeId', isEqualTo: 15)
        .where('branchId', isEqualTo: user.branchId)
        .where('isActive', isEqualTo: true)
        .get();
    if (resp.docs.isNotEmpty) {
      list.add(VoucherModel.fromJson(makeMapSerialize(resp.docs[0].data())));
      return VoucherModel.fromJson(makeMapSerialize(resp.docs[0].data()));
    } else {
      return null;
    }
  }
}

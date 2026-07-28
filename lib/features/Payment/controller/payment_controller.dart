import 'package:get/get.dart';
import 'package:healthandwellness/core/branch/data/branch_model.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Payment/data/payment_model.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:intl/intl.dart';

import '../../login/repository/authenticator.dart';

class PaymentController extends GetxController {
  final fb = Get.find<FB>();
  final auth = Get.find<Authenticator>();

  PaymentModel? selectedPayment;
  UserG? selectedUser;

  BranchModel? branch;

  Future<void> getUser() async {
    final db = await fb.getDB();
    if (selectedPayment == null) {
      throw Exception('No payment found!');
    }
    final userSnap = await db.collection('User').doc(selectedPayment!.userId).get();
    selectedUser = UserG.fromJSON(makeMapSerialize(userSnap.data()));
    update();
  }

  Future<void> getBranch() async {
    final db = await fb.getDB();
    if (selectedPayment == null) {
      throw Exception('No payment found!');
    }
    final userSnap = await db.collection('Branch').doc(selectedPayment!.branchId).get();
    branch = BranchModel.fromFirestore(userSnap);
    update();
  }

  Future<void> downloadPDF() async {
    final auth = Get.find<Authenticator>();
    if (selectedPayment == null) {
      throw Exception("No payment has been selected!");
    }
    if (auth.company == null) {
      throw Exception("Company not found!");
    }

    Map<String, dynamic> data = {
      "companyName": auth.company?.name ?? "",
      "companyAddress": auth.company?.address,
      "companyMobile": auth.company?.mobile,
      "companyGstIn": auth.company?.gstin,
      "companyEmail": auth.company?.email,
      "companyWebsite": auth.company?.website,
      "logoUrl": "https://example.com/path/to/bfll-logo.png",
      "invoiceNo": selectedPayment!.voucherNumber,
      "invoiceDate": DateFormat('yyyy-MM-dd').format(selectedPayment!.createdAt.toDate()),
      "clientName": selectedUser?.name ?? '',
      "clientMobile": selectedUser?.mobile ?? '',
      "placeOfSupply": selectedUser?.state ?? '',
      "signature": "",
      "totalAmount": selectedPayment!.voucherAmount,
      "receivedAmount": selectedPayment!.paidAmount,
      "balanceAmount": selectedPayment!.voucherAmount > selectedPayment!.paidAmount ? (selectedPayment!.voucherAmount - selectedPayment!.paidAmount) : 0,
      "balance": selectedPayment!.voucherAmount > selectedPayment!.paidAmount ? (selectedPayment!.voucherAmount - selectedPayment!.paidAmount) : 0,
      // "balance": selectedPayment!.advanceAmount,
      "termsAndCondition": "",
      "items": selectedPayment!.subscriptions
          ?.map(
            (m) => ({
              "name": m.subscriptionName,
              "qty": 1,
              "unit": "",
              "rate": m.grossAmount,
              "discAmt": m.discAmount,
              "discPct": m.discPer,
              "amount": m.netAmount,
            }),
          )
          .toList(),

      // [
      //   {
      //     "name": "THERAPEUTIC STRENGTH TRAINIG (PERSONAL TRAINING)",
      //     "qty": 1,
      //     "unit": "PCS",
      //     "rate": 32400,
      //     "discAmt": 24400,
      //     "discPct": 75.31,
      //     "amount": 8000,
      //   },
      // ],
    };
    FileHandlerG fileHandle = FileHandlerG();
    await fileHandle.downloadAndSaveFile(
      filePathWithName: '${selectedUser!.name}-${DateFormat('yyyy-MM-dd').format(selectedPayment!.createdAt.toDate())}',
      url: 'https://saleszing.info/saleszingdev/api/bflinvoicepdf.php',
      query: data,
    );
  }
}

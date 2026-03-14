import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:intl/intl.dart';

import '../../controller/member_controller.dart';

class MemberPaymentDetails extends StatefulWidget {
  const MemberPaymentDetails({super.key});

  @override
  State<MemberPaymentDetails> createState() => _MemberPaymentDetailsState();
}

class _MemberPaymentDetailsState extends State<MemberPaymentDetails> {
  final mainStore = Get.find<MainStore>();
  final memberController = Get.find<MemberController>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        await memberController.getPaymentList();
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberController>(
      init: memberController,
      autoRemove: false,
      builder: (memberController) {
        return ListView.builder(
          itemCount: memberController.payments.length,
          itemBuilder: (_, index) {
            final payment = memberController.payments[index];
            return CardHelper(
              height: 80,
              backgroundColor: mainStore.theme.value.lowShadeColor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper(
                        text: "Payment ID: ${payment.voucherNumber}",
                        fontsize: 12,
                        fontweight: FontWeight.w600,
                        color: mainStore.theme.value.BottomNavColor.withAlpha(180),
                      ),
                      TextHelper(
                        text: DateFormat('dd-MM-yyyy HH:mm a').format(payment.createdAt.toDate()),
                        fontsize: 12,
                        fontweight: FontWeight.w600,
                        color: mainStore.theme.value.LightTextColor.withAlpha(180),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper(
                        text: "Amount: ${currenyFormater(value: payment.paidAmount, withDrCr: false)}",
                        fontsize: 12,
                        fontweight: FontWeight.w600,
                      ),
                      Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextHelper(text: 'Paid By', fontsize: 11.5, fontweight: FontWeight.w600, color: mainStore.theme.value.LightTextColor.withAlpha(160)),
                          TextHelper(
                            text: payment.paymentModeName,
                            fontsize: 12,
                            fontweight: FontWeight.w600,
                            color: mainStore.theme.value.BottomNavColor.withAlpha(180),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper(text: "Service: ${payment.serviceName}", fontsize: 12),
                      TextHelper(text: "Subscription ID: ${payment.subscriptionName}", fontsize: 12),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

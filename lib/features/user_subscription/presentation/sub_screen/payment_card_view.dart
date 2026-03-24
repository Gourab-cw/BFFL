import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/Payment/controller/payment_controller.dart';
import 'package:healthandwellness/features/Payment/data/payment_model.dart';
import 'package:intl/intl.dart';

import '../../../../core/utility/helper.dart';

class PaymentCardView extends StatefulWidget {
  final PaymentModel payment;
  const PaymentCardView({super.key, required this.payment});

  @override
  State<PaymentCardView> createState() => _PaymentCardViewState();
}

class _PaymentCardViewState extends State<PaymentCardView> {
  final mainStore = Get.find<MainStore>();
  final paymentController = Get.find<PaymentController>();
  @override
  Widget build(BuildContext context) {
    PaymentModel payment = widget.payment;
    return CardHelper(
      onTap: () {
        paymentController.selectedPayment = payment;
        Get.toNamed('/paymentDetails');
      },
      height: 65,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, offset: Offset(1, 1), spreadRadius: 0.5)],
      backgroundColor: Colors.white,
      child: Column(
        spacing: 5,
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     TextHelper(text: "Service: ${payment.serviceName}", fontsize: 12),
          //     TextHelper(text: "Subscription ID: ${payment.subscriptionName}", fontsize: 12),
          //   ],
          // ),
        ],
      ),
    );
  }
}

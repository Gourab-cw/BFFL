import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Payment/controller/payment_controller.dart';
import 'package:intl/intl.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final PaymentController pc = Get.find<PaymentController>();
  final mainStore = Get.find<MainStore>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        await pc.getUser();
        await pc.getBranch();
      } catch (e) {
        showAlert('$e', AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: pc,
      autoRemove: false,
      builder: (pc) {
        final item = pc.selectedPayment;
        if (item == null) {
          return Center(child: TextHelper(text: "No Payment Found!"));
        }
        return Scaffold(
          appBar: AppBar(title: Text('Payment Details')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextHelper(text: 'ID : '),
                          TextHelper(text: item.voucherNumber, fontweight: FontWeight.w600),
                        ],
                      ),
                      Row(children: [TextHelper(text: DateFormat('dd-MM-yyyy hh:mm a').format(item.createdAt.toDate()), fontsize: 12.5)]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextHelper(text: 'Subscription ID : '),
                          TextHelper(text: item.subscriptionName, fontweight: FontWeight.w600),
                        ],
                      ),
                      Row(
                        children: [
                          TextHelper(text: 'Branch : '),
                          TextHelper(text: pc.branch?.name ?? ""),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          TextHelper(text: 'Service : '),
                          TextHelper(text: item.serviceName, fontweight: FontWeight.w600),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'User : '),
                      TextHelper(
                        text: pc.selectedUser == null ? "" : ('${pc.selectedUser?.name ?? ''}  (${pc.selectedUser?.mobile ?? ''})'),
                        fontweight: FontWeight.w600,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'Paid By : '),
                      TextHelper(text: item.paymentModeName, fontweight: FontWeight.w600),
                    ],
                  ),
                  Container(
                    color: mainStore.theme.value.lowShadeColor,
                    padding: EdgeInsets.all(2),
                    child: Column(
                      children: [
                        TextHelper(text: 'Paid Amount : ', fontsize: 11.5),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextHelper(
                                text: currenyFormater(value: item.paidAmount, withDrCr: false),
                                fontweight: FontWeight.w600,
                                fontsize: 22,
                                textalign: TextAlign.right,
                                color: mainStore.theme.value.HeadColor,
                              ),
                              Container(
                                color: mainStore.theme.value.BackgroundColor.withAlpha(100),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    TextHelper(text: 'Remarks: ', fontsize: 11),
                                    TextHelper(text: item.remarks, fontsize: 11, fontweight: FontWeight.w600),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

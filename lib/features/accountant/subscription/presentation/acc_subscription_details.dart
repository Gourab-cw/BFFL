import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/core/voucher/controller/voucher_controller.dart';

import '../../../../core/utility/app_loader.dart';
import '../../../../core/voucher/model/voucher_model.dart';
import '../../../subscriptions/controller/subscription_controller.dart';
import '../controller/acc_subscription_controller.dart';

class AccSubscriptionDetails extends StatefulWidget {
  const AccSubscriptionDetails({super.key});

  @override
  State<AccSubscriptionDetails> createState() => _AccSubscriptionDetailsState();
}

class _AccSubscriptionDetailsState extends State<AccSubscriptionDetails> {
  final accSubController = Get.find<AccSubscriptionController>();
  final subController = Get.find<SubscriptionController>();
  final voucherController = Get.find<VoucherController>();
  final loader = Get.find<AppLoaderController>();
  final remarksController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        VoucherModel? v = await voucherController.getReceiptVoucher();
        if (v != null) {
          accSubController.voucher = v;
          await accSubController.loadPaymentModes(v.paymentMethods);
          accSubController.update();
        } else {
          showAlert("No voucher found!", AlertType.error);
        }
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    accSubController.amount.clear();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GSTDetails calc = accSubController.getCalculationDetails(
      selectedUser: accSubController.selectedUser!,
      service: subController.list.firstWhereOrNull((s) => s.id == accSubController.selectedUser!.subscriptionId)!,
    );
    return GetBuilder<AccSubscriptionController>(
      init: accSubController,
      autoRemove: false,
      builder: (accSubController) {
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(title: Text("Subscription Details")),
            body: Builder(
              builder: (context) {
                final us = accSubController.selectedUser;
                if (us == null) {
                  return Center(child: Text("No data found!"));
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Member :", width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(text: us.user!.name),
                          ],
                        ),
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Address :", width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(text: us.user!.address),
                          ],
                        ),
                        Divider(),
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Service :", width: 80, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(text: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.name ?? "", fontsize: 12),
                          ],
                        ),
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Per session :", width: 80, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(
                              text: currenyFormater(
                                value: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.amount.toString(),
                                withDrCr: false,
                              ),
                              fontsize: 12,
                            ),
                          ],
                        ),
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Full Package :", width: 90, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(
                              text: currenyFormater(
                                value: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.totalAmount.toString(),
                                withDrCr: false,
                              ),
                              fontsize: 12,
                            ),
                          ],
                        ),
                        Row(
                          spacing: 6,
                          children: [
                            TextHelper(text: "Total Session Booked :", width: 135, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            TextHelper(
                              text: parseString(data: us.totalSessions, defaultValue: '0'),
                              fontsize: 12,
                            ),
                          ],
                        ),
                        Row(
                          spacing: 30,
                          children: [
                            Row(
                              spacing: 6,
                              children: [
                                TextHelper(text: "Start Date :", width: 75, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                                TextHelper(
                                  text: parseDateToString(data: us.startDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: ''),
                                  fontsize: 12,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 6,
                              children: [
                                TextHelper(text: "End Date :", width: 65, fontsize: 12, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                                TextHelper(
                                  text: parseDateToString(data: us.endDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: ''),
                                  fontsize: 12,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 2,
                          children: [
                            TextHelper(text: 'Amount', fontsize: 12, fontweight: FontWeight.w600, textalign: TextAlign.right, padding: EdgeInsets.zero),
                            Divider(),
                            Row(
                              spacing: 20,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextHelper(text: 'Gross Amount :', fontsize: 12),
                                TextHelper(
                                  text: currenyFormater(value: calc.grossAmount, withDrCr: false),
                                  width: 150,
                                  fontweight: FontWeight.w600,
                                  fontsize: 12,
                                  color: Colors.grey.shade700,
                                  textalign: TextAlign.right,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 20,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextHelper(text: 'Tax Amount :', fontsize: 12),
                                TextHelper(
                                  text: currenyFormater(value: calc.gstAmount, withDrCr: false),
                                  width: 150,
                                  textalign: TextAlign.right,
                                  fontweight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                  fontsize: 12,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 20,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextHelper(text: 'Net Amount :', fontsize: 12),
                                TextHelper(
                                  text: currenyFormater(value: calc.netAmount, withDrCr: false),
                                  width: 150,
                                  fontsize: 12,
                                  textalign: TextAlign.right,
                                  fontweight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 6,
                          children: [
                            TextHelper(text: "Payment :", fontsize: 12, width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            SizedBox(
                              width: 115,
                              child: DropDownHelperG(
                                height: 35,
                                showBorder: false,
                                leading: SizedBox.shrink(),
                                trailing: Icon(Icons.arrow_drop_down, color: getMainStore().theme.value.HeadColor.withAlpha(200)),
                                fontSize: 12,
                                rowHeight: 30,
                                showClearText: false,
                                uniqueKey: UniqueKey().toString(),
                                value: accSubController.selectedPaymentMode?.toJSON() ?? {},
                                onValueChange: (v) {
                                  accSubController.selectedPaymentMode = accSubController.paymentModes.firstWhereOrNull((f) => f.id == (v['id'] ?? ''));
                                  accSubController.update();
                                },
                                items: accSubController.paymentModes.map((m) => m.toJSON()).toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 6,
                          children: [
                            TextHelper(text: "Paid :", fontsize: 12, width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                            SizedBox(
                              width: 120,
                              child: TextBox(
                                controller: accSubController.amount,
                                height: 35,
                                width: 120,
                                showAlwaysLabel: true,
                                withBorder: false,
                                backgroundColor: getMainStore().theme.value.lowShadeColor.withAlpha(180),
                                fontSize: 13,
                                onValueChange: (v) {
                                  double amount = parseDouble(data: v, defaultValue: 0);
                                  if (amount > calc.netAmount) {
                                    showAlert("Paid amount is greater than total amount", AlertType.error);
                                    accSubController.amount.clear();
                                  }
                                },
                                leading: Icon(FontAwesomeIcons.indianRupeeSign, size: 12, color: getMainStore().theme.value.HeadColor.withAlpha(200)),
                              ),
                            ),
                          ],
                        ),
                        TextAreaBox(
                          height: 80,
                          labelText: 'Remarks  ',
                          showAlwaysLabel: true,
                          borderRadius: BorderRadius.circular(10),
                          controller: remarksController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonHelperG(
                              onTap: () async {
                                try {
                                  final s = subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId);
                                  if (s == null) {
                                    showAlert("No subscription found!", AlertType.error);
                                    return;
                                  }
                                  loader.startLoading();
                                  await accSubController.makePaid(selectedUser: us, service: s, remarks: remarksController.text.trim());
                                  showAlert("Success", AlertType.success);
                                  goBack(context);
                                } catch (e) {
                                  showAlert("$e", AlertType.error);
                                } finally {
                                  loader.stopLoading();
                                }
                              },
                              width: 80,
                              label: TextHelper(text: "Paid", color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';

import '../../../../core/utility/app_loader.dart';
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
  final loader = Get.find<AppLoaderController>();

  final remarksController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccSubscriptionController>(
      init: accSubController,
      autoRemove: false,
      builder: (accSubController) {
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(
              title: TextHelper(text: "Subscription Details", fontweight: FontWeight.w600, fontsize: 15),
            ),
            body: Builder(
              builder: (context) {
                final us = accSubController.selectedUser;
                if (us == null) {
                  return Center(child: Text("No data found!"));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          TextHelper(text: "User :", width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
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
                          TextHelper(text: "Service :", width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                          TextHelper(text: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.name ?? ""),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          TextHelper(text: "Per session :", width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                          TextHelper(
                            text: currenyFormater(
                              value: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.amount.toString(),
                              withDrCr: false,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          TextHelper(text: "Full Package :", width: 90, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                          TextHelper(
                            text: currenyFormater(
                              value: subController.list.firstWhereOrNull((s) => s.id == us.subscriptionId)?.totalAmount.toString(),
                              withDrCr: false,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          TextHelper(text: "Total Session Booked :", width: 150, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                          TextHelper(
                            text: parseString(data: us.totalSessions, defaultValue: '0'),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          TextHelper(text: "Start Date :", width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                          TextHelper(
                            text: parseDateToString(data: us.startDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: ''),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        children: [
                          TextHelper(text: "End Date :", width: 80, fontweight: FontWeight.w600, color: Colors.grey.shade600),
                          TextHelper(
                            text: parseDateToString(data: us.endDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: ''),
                          ),
                        ],
                      ),
                      Spacer(),
                      TextAreaBox(
                        height: 80,
                        labelText: 'Remarks',
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
                                loader.startLoading();
                                await accSubController.updateDetails(us, remarksController.text.trim());
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}

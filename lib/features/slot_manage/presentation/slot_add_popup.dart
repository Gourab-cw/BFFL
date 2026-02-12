import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:healthandwellness/features/subscriptions/data/Subscription.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../../subscriptions/controller/subscription_controller.dart';
import '../controller/slot_manage_controller.dart';

class SlotAddData {
  final String columnName;
  final int rowIndex;
  final String time;
  final String startTime;
  final String endTime;
  final DateTime date;

  SlotAddData({required this.columnName, required this.rowIndex, required this.time, required this.startTime, required this.endTime, required this.date});
}

Future<void> slotAddPopup(
  BuildContext context, {
  required SlotAddData data,
  required SlotController slotController,
  required SubscriptionController subscriptionController,
}) async {
  await showAdaptiveDialog(
    context: context,
    builder: (ctx) {
      final sc = slotController.slots
          .where((w) => w.date == DateFormat("yyyy-MM-dd").format(data.date) && w.startTime == data.startTime && w.endTime == data.endTime)
          .map((m) => m.serviceId)
          .toList();

      List<Subscription> selectedCourses = subscriptionController.list.where((w) => sc.contains(w.id)).toList();
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 450, minHeight: 200, maxWidth: 450, minWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextHelper(text: "Slot manage", fontweight: FontWeight.w600, fontsize: 14),
                    TextHelper(text: "Date:  ${DateFormat("EEE, dd-MM-yyyy").format(data.date)} , ${data.time}"),
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: subscriptionController.list.length,
                      itemBuilder: (ctx, index) {
                        final s = subscriptionController.list[index];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 5,
                          children: [
                            MoonCheckbox(
                              activeColor: Colors.blueGrey,
                              value: selectedCourses.indexWhere((m) => m.id == s.id) != -1,
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    selectedCourses.add(s);
                                  } else {
                                    selectedCourses.removeWhere((m) => s.id == m.id);
                                  }
                                });
                              },
                              tapAreaSizeValue: 30,
                            ),
                            Expanded(child: TextHelper(text: s.name, fontsize: 12)),
                          ],
                        );
                      },
                    ),
                    ButtonHelperG(
                      width: 80,
                      onTap: () {
                        if (selectedCourses.isEmpty) {
                          return;
                        }
                        final Authenticator auth = Get.find<Authenticator>();
                        final user = auth.state!;
                        int i = 0;
                        while (i < selectedCourses.length) {
                          int index = slotController.slots.indexWhere(
                            (s) =>
                                s.date == DateFormat('yyyy-MM-dd').format(data.date) &&
                                s.startTime == data.startTime &&
                                s.endTime == data.endTime &&
                                s.serviceId == selectedCourses[i].id,
                          );
                          if (index == -1) {
                            SlotModel s = SlotModel.fromJSON(
                              makeMapSerialize({
                                'companyId': user.companyId,
                                'branchId': user.branchId,
                                'date': DateFormat('yyyy-MM-dd').format(data.date),
                                'startTime': data.startTime,
                                'endTime': data.endTime,
                                'serviceId': selectedCourses[i].id,
                                'bookingCount': 0,
                                'createdAt': Timestamp.now(),
                                'month': DateFormat('yyyy-MM').format(data.date),
                                'isActive': true,
                                'id': "",
                              }),
                            );
                            slotController.slots.add(s);
                          }
                          i++;
                        }
                        // slotController.slotData[data.rowIndex][data.columnName] = selectedCourses;
                        slotController.update();
                        goBack(context);
                      },
                      label: TextHelper(text: "Set", color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

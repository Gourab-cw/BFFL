import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/controller/slot_manage_controller.dart';
import 'package:healthandwellness/features/slot_manage/presentation/slot_add_popup.dart';
import 'package:healthandwellness/features/slot_manage/presentation/slot_add_popup_weekly.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';

import '../../../core/utility/app_loader.dart';
import '../../../core/utility/helper.dart';

class SlotManage extends StatefulWidget {
  const SlotManage({super.key});

  @override
  State<SlotManage> createState() => _SlotManageState();
}

class _SlotManageState extends State<SlotManage> {
  final MainStore mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final fb = Get.find<FB>();
  final Authenticator authenticator = Get.find<Authenticator>();
  final SlotController slotController = Get.find<SlotController>();
  final SubscriptionController subscriptionController = Get.find<SubscriptionController>();
  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      loader.startLoading();
      try {
        await subscriptionController.fetchSubscription(await fb.getDB());
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        loader.stopLoading();
      }
    });
    super.initState();
  }

  Future<void> handleFillSlotClick() async {
    await showAdaptiveDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: SizedBox(
            height: 180,
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ButtonHelperG(
                    onTap: () async {
                      try {
                        loader.startLoading();
                        await slotController.slotDataFeelFromLastMonth();
                        subscriptionController.update();
                        goBack(context);
                      } catch (e) {
                        showAlert('$e', AlertType.error);
                      } finally {
                        loader.stopLoading();
                      }
                    },
                    height: 35,
                    width: 180,
                    label: TextHelper(text: 'Fill Slots From Last Month', color: mainStore.theme.value.BackgroundColor),
                  ),
                  ButtonHelperG(
                    onTap: () async {
                      goBack(context);
                      await slotAddPopupWeekly(context);
                    },
                    height: 35,
                    width: 180,
                    label: TextHelper(text: 'Fill Slots From Last Weeks', color: mainStore.theme.value.BackgroundColor),
                  ),
                  ButtonHelperG(
                    onTap: () async {
                      goBack(context);
                      await slotAddPopupByDate(context);
                    },
                    height: 35,
                    width: 180,
                    label: TextHelper(text: 'Fill Slots From a Date', color: mainStore.theme.value.BackgroundColor),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    return GetBuilder<SlotController>(
      init: slotController,
      autoRemove: false,
      builder: (slotController) {
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Slot Manage"),
              actions: [
                ButtonHelperG(
                  onTap: () async {
                    loader.startLoading();
                    try {
                      final db = await fb.getDB();
                      await slotController.saveSlots(db, authenticator.state!);
                      slotController.slots = [];
                      await slotController.slotDataFeel();
                      slotController.update();
                    } catch (e) {
                      showAlert("$e", AlertType.error);
                    } finally {
                      loader.stopLoading();
                    }
                  },
                  label: TextHelper(text: "Save"),
                  background: getMainStore().theme.value.lowShadeColor,
                  shadow: [],
                  width: 80,
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(left: safePadding.left + 10, top: safePadding.top, bottom: safePadding.bottom, right: safePadding.right + 10),
              child: Column(
                spacing: 9,
                children: [
                  const SizedBox(height: 5),
                  Row(
                    spacing: 5,
                    children: [
                      TextHelper(text: "Select Month :", fontweight: FontWeight.w500, width: 110),
                      Expanded(
                        child: TextBox(
                          height: 35,
                          fontSize: 13.2,
                          width: 120,
                          backgroundColor: Colors.white,
                          onTap: () {
                            DateTimePicker.dateTimePicker(
                              mode: CupertinoDatePickerMode.monthYear,
                              context: context,
                              defaultDateTime: slotController.month,
                              onDateTimeChanged: (v) {
                                slotController.month = v;
                                slotController.update();
                              },
                            );
                          },
                          readonly: true,
                          initialValue: slotController.month == null ? "" : DateFormat('MMM, yyyy').format(slotController.month!),
                        ),
                      ),
                      ButtonHelperG(
                        onTap: () async {
                          await handleFillSlotClick();
                          return;
                          // try {
                          //   loader.startLoading();
                          //   await slotController.slotDataFeelFromLastMonth();
                          // } catch (e) {
                          //   showAlert("$e", AlertType.error);
                          // } finally {
                          //   loader.stopLoading();
                          // }
                        },
                        height: 35,
                        shadow: [BoxShadow(spreadRadius: 0.6, blurRadius: 0.1, color: Colors.grey.shade200)],
                        icon: Icon(Icons.calendar_month, size: 16),
                        type: ButtonHelperTypeG.outlined,
                        label: TextHelper(text: "Fill Slots", fontsize: 12),
                        width: 80,
                        borderColor: mainStore.theme.value.mediumShadeColor,
                      ),
                      ButtonHelperG(
                        onTap: () async {
                          try {
                            loader.startLoading();
                            await slotController.slotDataFeel();
                          } catch (e) {
                            showAlert("$e", AlertType.error);
                          } finally {
                            loader.stopLoading();
                          }
                        },
                        height: 35,
                        icon: Icon(Icons.cloud_download, color: Colors.white, size: 16),
                        label: TextHelper(text: "Slots", color: Colors.white, fontsize: 12),
                        width: 80,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      TextHelper(text: "Time :", fontweight: FontWeight.w500, width: 40),
                      Expanded(
                        child: Row(
                          spacing: 5,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextBox(
                              height: 35,
                              labelText: "Day Start ",
                              showAlwaysLabel: true,
                              fontSize: 13.2,
                              width: 80,
                              backgroundColor: Colors.white,
                              onTap: () {
                                DateTimePicker.dateTimePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  headerText: "Select Start Time",
                                  context: context,
                                  defaultDateTime: slotController.dailyStart,
                                  onDateTimeChanged: (v) {
                                    slotController.dailyStart = v;
                                    slotController.update();
                                  },
                                );
                              },
                              readonly: true,
                              initialValue: slotController.dailyStart == null ? "" : DateFormat('HH:mm').format(slotController.dailyStart!),
                            ),
                            Container(width: 10, height: 2, color: Colors.grey),
                            TextBox(
                              height: 35,
                              labelText: "Day End ",
                              showAlwaysLabel: true,
                              fontSize: 13.2,
                              width: 75,
                              backgroundColor: Colors.white,
                              onTap: () {
                                DateTimePicker.dateTimePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  headerText: "Select End Time",
                                  defaultDateTime: slotController.dailyEnd,
                                  context: context,
                                  onDateTimeChanged: (v) {
                                    slotController.dailyEnd = v;
                                    slotController.update();
                                  },
                                );
                              },
                              readonly: true,
                              initialValue: slotController.dailyEnd == null ? "" : DateFormat('HH:mm').format(slotController.dailyEnd!),
                            ),
                            TextBox(
                              trailing: TextHelper(text: "mins ", fontsize: 12),
                              height: 35,
                              labelText: "Interval",
                              controller: slotController.period,
                              showAlwaysLabel: true,
                              fontSize: 13,
                              backgroundColor: Colors.white,
                              width: 80,
                              keyboard: TextInputType.numberWithOptions(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: GetBuilder<SubscriptionController>(
                      init: subscriptionController,
                      autoRemove: false,
                      builder: (subscriptionController) {
                        final branch = authenticator.branch;
                        if (branch == null) {
                          return Center(child: TextHelper(text: 'No branch found!'));
                        }
                        return DataGridHelper3(
                          dataSource: slotController.slotData,
                          columnFixCount: 1,
                          withBorder: true,
                          showAlternateColor: true,
                          headerColor: Colors.green.shade100,
                          columnSpacing: 1,
                          rowHeight: 80,
                          columnList: slotController.slotData.isEmpty
                              ? []
                              : slotController.slotData[0].keys.toList().sublist(1).map((k) {
                                  return DataGridColumnModel3(
                                    dataField: k,
                                    dataType: CellDataType3.string,
                                    title: "Time",
                                    width: 100,
                                    customHeaderCell: (c) {
                                      if (c.cellIndex == 0) {
                                        return Container(
                                          color: Colors.blueGrey.shade200,
                                          child: TextHelper(text: "Time", textalign: TextAlign.center, fontweight: FontWeight.w600),
                                        );
                                      } else {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color:
                                                DateFormat("EEE").format(
                                                      DateTime(
                                                        slotController.month!.year,
                                                        slotController.month!.month,
                                                        parseInt(data: c.cellValue, defaultInt: 1),
                                                      ),
                                                    ) ==
                                                    "Sun"
                                                ? Colors.red.shade50
                                                : Colors.green.shade50,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              TextHelper(text: c.cellValue, textalign: TextAlign.center, fontsize: 12),
                                              TextHelper(
                                                text: DateFormat("EEE").format(
                                                  DateTime(slotController.month!.year, slotController.month!.month, parseInt(data: c.cellValue, defaultInt: 1)),
                                                ),
                                                textalign: TextAlign.center,
                                                color: Colors.blueGrey.shade500,
                                                fontsize: 11,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    customCell: (c) {
                                      if (c.cellIndex == 0) {
                                        return TextHelper(
                                          text: "${c.rowValue['startTime']} - ${c.rowValue['endTime']}",
                                          textalign: TextAlign.center,
                                          fontsize: 12,
                                        );
                                      } else {
                                        String date = DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(DateTime(slotController.month!.year, slotController.month!.month, parseInt(data: c.cellIndex.toString())));
                                        int holidayIndex = slotController.holidayList.indexWhere((h) => h.holidayDate == date);

                                        if (holidayIndex != -1) {
                                          return Container(
                                            color: Colors.amber.shade50,
                                            child: Center(
                                              child: TextHelper(
                                                text: slotController.holidayList[holidayIndex].holidayName,
                                                color: Colors.amber.shade500,
                                                fontweight: FontWeight.w600,
                                                fontsize: 11,
                                                textalign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }

                                        int startTime = parseInt(data: c.rowValue['startTime'].toString().replaceAll(':', ''), defaultInt: 0);
                                        int endTime = parseInt(data: c.rowValue['endTime'].toString().replaceAll(':', ''), defaultInt: 0);

                                        int lunchStartTime = parseInt(data: branch.lunchStart.replaceAll(':', ''), defaultInt: 0);
                                        int lunchEndTime = parseInt(data: branch.lunchEnd.replaceAll(':', ''), defaultInt: 0);

                                        if (startTime >= lunchStartTime && endTime <= lunchEndTime) {
                                          return Container(
                                            color: Colors.red.shade50,
                                            child: Center(
                                              child: TextHelper(
                                                text: 'Lunch Break',
                                                color: Colors.red.shade200,
                                                fontweight: FontWeight.w600,
                                                fontsize: 11,
                                                textalign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            slotAddPopup(
                                              context,
                                              data: SlotAddData(
                                                columnName: k,
                                                rowIndex: c.rowIndex,
                                                startTime: c.rowValue['startTime'],
                                                endTime: c.rowValue['endTime'],
                                                time: "${c.rowValue['startTime']} - ${c.rowValue['endTime']}",
                                                date: DateTime(slotController.month!.year, slotController.month!.month, parseInt(data: k, defaultInt: 1)),
                                              ),
                                              slotController: slotController,
                                              subscriptionController: subscriptionController,
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            padding: EdgeInsets.all(2),
                                            child: SingleChildScrollView(
                                              child: Wrap(
                                                spacing: 15,
                                                runSpacing: 5,
                                                children: slotController
                                                    .getSelectedService(
                                                      DateFormat('yyyy-MM-dd').format(
                                                        DateTime(slotController.month!.year, slotController.month!.month, parseInt(data: k, defaultInt: 1)),
                                                      ),
                                                      parseString(data: c.rowValue['startTime'], defaultValue: ""),
                                                      parseString(data: c.rowValue['endTime'], defaultValue: ""),
                                                      subscriptionController,
                                                    )
                                                    .map<Widget>(
                                                      (m) => Container(
                                                        height: 20,
                                                        decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(5)),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            ConstrainedBox(
                                                              constraints: BoxConstraints(maxWidth: m.isNewSlot == true ? 60 : 90, minWidth: 20),
                                                              child: Text(
                                                                m.name,
                                                                style: TextStyle(fontSize: 10),
                                                                overflow: TextOverflow.ellipsis,
                                                                // fontsize: 10,
                                                              ),
                                                            ),
                                                            if (m.isNewSlot == true)
                                                              ButtonHelperG(
                                                                onTap: () {
                                                                  final start = parseString(data: c.rowValue['startTime'], defaultValue: "");
                                                                  final end = parseString(data: c.rowValue['endTime'], defaultValue: "");
                                                                  final date = DateFormat('yyyy-MM-dd').format(
                                                                    DateTime(
                                                                      slotController.month!.year,
                                                                      slotController.month!.month,
                                                                      parseInt(data: k, defaultInt: 1),
                                                                    ),
                                                                  );
                                                                  slotController.slots.removeWhere(
                                                                    (s) => s.startTime == start && s.endTime == end && s.serviceId == m.id && s.date == date,
                                                                  );
                                                                  slotController.update();
                                                                },
                                                                margin: 0,
                                                                shadow: [],
                                                                background: Colors.grey.shade200,
                                                                width: 20,
                                                                height: 20,
                                                                padding: EdgeInsets.zero,
                                                                icon: Icon(Icons.clear, size: 15),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }).toList(),
                          uniqueKey: UniqueKey().toString(),
                          width: MediaQuery.sizeOf(context).width * 0.8,
                        );
                      },
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

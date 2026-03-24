import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../app/mainstore.dart';
import '../../Service/data/service.dart';
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
  void newSlotSaveFunction(List<Map<String, dynamic>> tableData) {
    if (tableData.isEmpty) {
      return;
    }
    final Authenticator auth = Get.find<Authenticator>();
    final user = auth.state!;
    int i = 0;
    while (i < tableData.length) {
      int index = slotController.slots.indexWhere(
        (s) =>
            s.date == DateFormat('yyyy-MM-dd').format(data.date) &&
            s.startTime == data.startTime &&
            s.endTime == data.endTime &&
            s.serviceId == tableData[i]['service'],
      );
      if (index == -1) {
        SlotModel s = SlotModel.fromJSON(
          makeMapSerialize({
            'companyId': user.companyId,
            'branchId': user.branchId,
            'date': DateFormat('yyyy-MM-dd').format(data.date),
            'startTime': data.startTime,
            'endTime': data.endTime,
            'serviceId': tableData[i]['service'],
            'trainerId': tableData[i]['trainer'],
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
  }

  await showAdaptiveDialog(
    context: context,
    builder: (ctx) {
      List<SlotModel> slotsInThePeriod = slotController.slots
          .where((w) => w.date == DateFormat("yyyy-MM-dd").format(data.date) && w.startTime == data.startTime && w.endTime == data.endTime)
          .toList();
      final sc = slotsInThePeriod.map((m) => m.serviceId).toList();
      List<ServiceModel> selectedCourses = subscriptionController.list.where((w) => sc.contains(w.id)).toList();
      List<Map<String, dynamic>> tableData = slotsInThePeriod.map((s) {
        return {'service': s.serviceId, 'trainer': s.trainerId, 'id': s.id, 'uid': Uuid().v4()};
      }).toList();
      List<Map<String, dynamic>> subscriptionDataInJson = subscriptionController.list.map((m) => m.toJson()).toList();
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 450, minHeight: 200, maxWidth: 450, minWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextHelper(text: "Slot manage", fontweight: FontWeight.w600, fontsize: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextHelper(text: "Date:  ${DateFormat("EEE, dd-MM-yyyy").format(data.date)} , ${data.time}", fontsize: 12, isWrap: true),
                        ButtonHelperG(
                          onTap: () {
                            setState(() {
                              tableData.add({'service': '', 'trainer': '', 'id': '', 'uid': Uuid().v4()} as Map<String, dynamic>);
                            });
                          },
                          width: 100,
                          height: 30,
                          label: TextHelper(text: 'Add new slot', color: Colors.white),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 300,
                      child: DataGridHelper3(
                        headerColor: getMainStore().theme.value.lowShadeColor,
                        showAlternateColor: true,
                        withBorder: true,
                        fontSize: 12,
                        dataSource: tableData,
                        columnList: [
                          DataGridColumnModel3(
                            dataField: 'service',
                            title: 'Service',
                            dataType: CellDataType3.string,
                            customCell: (v) {
                              if (v.rowValue['id'] != '') {
                                return TextHelper(
                                  text: subscriptionController.getServiceById(v.cellValue)?.name ?? '',
                                  fontsize: 12,
                                  textalign: TextAlign.center,
                                );
                              }
                              return Row(
                                children: [
                                  ButtonHelperG(
                                    onTap: () {
                                      setState(() {
                                        tableData.removeWhere((t) => t['uid'] == v.rowValue['uid']);
                                      });
                                    },
                                    width: 30,
                                    margin: 0,
                                    icon: Icon(Icons.delete, size: 15),
                                    background: getMainStore().theme.value.lowShadeColor,
                                  ),
                                  Expanded(
                                    child: DropDownHelperG(
                                      leading: SizedBox.shrink(),
                                      trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
                                      height: 30,
                                      fontSize: 12,
                                      rowHeight: 30,
                                      showClearText: false,
                                      showBorder: false,
                                      uniqueKey: UniqueKey().toString(),
                                      items: subscriptionDataInJson,
                                      value: subscriptionController.getServiceById(v.cellValue)?.toJson() ?? {},
                                      onValueChange: (c) {
                                        setState(() {
                                          if (tableData.any((t) => t['service'] == c['id'])) {
                                            ServiceModel s = subscriptionController.getServiceById(c['id'])!;
                                            if (s.trainersData != null && s.trainersData!.length < 2) {
                                              showAlert('Service already exist', AlertType.error);
                                              return;
                                            }
                                          }
                                          int tableDataIndex = tableData.indexWhere((m) => m['uid'] == v.rowValue['uid']);
                                          tableData[tableDataIndex]['service'] = c['id'] ?? '';
                                          tableData = tableData;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          DataGridColumnModel3(
                            dataField: 'trainer',
                            title: 'Trainer',
                            dataType: CellDataType3.string,
                            customCell: (v) {
                              if (v.rowValue['id'] != '') {
                                return TextHelper(
                                  text:
                                      subscriptionController
                                          .getServiceById(v.rowValue['service'])!
                                          .trainersData
                                          ?.firstWhereOrNull((t) => t.id == v.cellValue)
                                          ?.name ??
                                      '',
                                  fontsize: 12,
                                  textalign: TextAlign.center,
                                );
                              }
                              return DropDownHelperG(
                                leading: SizedBox.shrink(),
                                trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
                                height: 30,
                                fontSize: 12,
                                rowHeight: 30,
                                showClearText: false,
                                showBorder: false,
                                uniqueKey: UniqueKey().toString(),
                                items: subscriptionController.getServiceById(v.rowValue['service'])?.trainersData?.map((m) => m.toJSON()).toList() ?? [],
                                value:
                                    subscriptionController
                                        .getServiceById(v.rowValue['service'])
                                        ?.trainersData
                                        ?.firstWhereOrNull((t) => t.id == v.cellValue)
                                        ?.toJSON() ??
                                    {},
                                onValueChange: (c) {
                                  setState(() {
                                    if (tableData.any((t) => t['trainer'] == c['id'] && t['service'] == v.rowValue['service'])) {
                                      showAlert('Trainer already exist for same service', AlertType.error);
                                      return;
                                    }
                                    int tableDataIndex = tableData.indexWhere((m) => m['uid'] == v.rowValue['uid']);
                                    tableData[tableDataIndex]['trainer'] = c['id'] ?? '';
                                    tableData = tableData;
                                  });
                                },
                              );
                            },
                          ),
                          DataGridColumnModel3(
                            width: 57,
                            dataField: 'id',
                            title: 'Status',
                            dataType: CellDataType3.string,
                            customCell: (v) {
                              return Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: v.cellValue == '' ? Colors.grey : Colors.green),
                              );
                            },
                          ),
                        ],
                        uniqueKey: UniqueKey().toString(),
                        width: 440,
                      ),
                    ),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: subscriptionController.list.length,
                    //   itemBuilder: (ctx, index) {
                    //     final s = subscriptionController.list[index];
                    //     return Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       spacing: 5,
                    //       children: [
                    //         MoonCheckbox(
                    //           activeColor: Colors.blueGrey,
                    //           value: selectedCourses.indexWhere((m) => m.id == s.id) != -1,
                    //           onChanged: (v) {
                    //             setState(() {
                    //               if (v == true) {
                    //                 selectedCourses.add(s);
                    //               } else {
                    //                 selectedCourses.removeWhere((m) => s.id == m.id);
                    //               }
                    //             });
                    //           },
                    //           tapAreaSizeValue: 30,
                    //         ),
                    //         Expanded(child: TextHelper(text: s.name, fontsize: 12)),
                    //       ],
                    //     );
                    //   },
                    // ),
                    ButtonHelperG(
                      width: 80,
                      onTap: () {
                        newSlotSaveFunction(tableData);
                        return;
                        // if (selectedCourses.isEmpty) {
                        //   return;
                        // }
                        // final Authenticator auth = Get.find<Authenticator>();
                        // final user = auth.state!;
                        // int i = 0;
                        // while (i < selectedCourses.length) {
                        //   int index = slotController.slots.indexWhere(
                        //     (s) =>
                        //         s.date == DateFormat('yyyy-MM-dd').format(data.date) &&
                        //         s.startTime == data.startTime &&
                        //         s.endTime == data.endTime &&
                        //         s.serviceId == selectedCourses[i].id,
                        //   );
                        //   if (index == -1) {
                        //     SlotModel s = SlotModel.fromJSON(
                        //       makeMapSerialize({
                        //         'companyId': user.companyId,
                        //         'branchId': user.branchId,
                        //         'date': DateFormat('yyyy-MM-dd').format(data.date),
                        //         'startTime': data.startTime,
                        //         'endTime': data.endTime,
                        //         'serviceId': selectedCourses[i].id,
                        //         'trainerId': parseString(data: selectedCourses[i].trainerId.first, defaultValue: ''),
                        //         'bookingCount': 0,
                        //         'createdAt': Timestamp.now(),
                        //         'month': DateFormat('yyyy-MM').format(data.date),
                        //         'isActive': true,
                        //         'id': "",
                        //       }),
                        //     );
                        //     slotController.slots.add(s);
                        //   }
                        //   i++;
                        // }
                        // // slotController.slotData[data.rowIndex][data.columnName] = selectedCourses;
                        // slotController.update();
                        // goBack(context);
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

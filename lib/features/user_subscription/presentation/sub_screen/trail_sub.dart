import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';

import '../../controller/user_subscription_controller.dart';

class TrailSub extends StatefulWidget {
  const TrailSub({super.key});

  @override
  State<TrailSub> createState() => _TrailSubState();
}

class _TrailSubState extends State<TrailSub> {
  final UserSubscriptionController userSubscriptionController = Get.find<UserSubscriptionController>();
  final subscription = Get.find<SubscriptionController>();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserSubscriptionController>(
      init: userSubscriptionController,
      autoRemove: false,
      builder: (userSubscriptionController) {
        return GetBuilder<SubscriptionController>(
          init: subscription,
          autoRemove: false,
          builder: (subscription) {
            return Column(
              spacing: 5,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextHelper(text: "Subscription Items", fontweight: FontWeight.w600),
                    ),
                    ButtonHelperG(
                      margin: 0,
                      width: 30,
                      height: 30,
                      background: Colors.green.shade100,
                      onTap: () {
                        userSubscriptionController.subDataGridData.add({
                          'id': Uuid().v4(),
                          'startDate': DateTime.now(),
                          'endDate': null,
                          'serviceId': '',
                          'serviceName': '',
                          'sessionCount': '',
                        });
                        userSubscriptionController.update();
                      },
                      icon: Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
                Expanded(
                  child: DataGridHelper3(
                    fontSize: 11.4,
                    columnSpacing: 1,
                    headerColor: Colors.grey.shade300,
                    dataSource: userSubscriptionController.subDataGridData,
                    onCellValueChange: (c) {
                      int index = userSubscriptionController.subDataGridData.indexWhere((i) => c.rowValue['id'] == c.rowValue['id']);
                      userSubscriptionController.subDataGridData[index]['sessionCount'] = parseInt(data: c.value, defaultInt: 0);
                      userSubscriptionController.update();
                    },
                    columnList: [
                      DataGridColumnModel3(
                        dataField: 'serviceId',
                        title: 'Service',
                        dataType: CellDataType3.string,
                        customCell: (c) {
                          return DropDownHelperG(
                            leading: SizedBox.shrink(),
                            trailing: SizedBox.shrink(),
                            showBorder: false,
                            fontSize: 11,
                            height: 35,
                            listHeight: 80,
                            dropDownPosition: MoonDropdownAnchorPosition.top,
                            customRow: (c) {
                              return Container(
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
                                child: TextHelper(text: c['name'], textalign: TextAlign.center, fontsize: 11, isWrap: true),
                              );
                            },
                            uniqueKey: UniqueKey().toString(),
                            value: {'id': c.rowValue['serviceId'], 'name': c.rowValue['serviceName'], 'value': c.rowValue['serviceName']},
                            items: subscription.list.map((m) => m.toJson()).toList(),
                            onValueChange: (v) {
                              int index = userSubscriptionController.subDataGridData.indexWhere((i) => i['id'] == c.rowValue['id']);
                              userSubscriptionController.subDataGridData[index]['serviceId'] = v['id'];
                              userSubscriptionController.subDataGridData[index]['serviceName'] = v['name'];
                              userSubscriptionController.update();
                            },
                          );
                        },
                      ),
                      DataGridColumnModel3(
                        dataField: 'startDate',
                        title: 'Start Date',
                        customCell: (c) {
                          return GestureDetector(
                            onTap: () async {
                              DateTimePicker.dateTimePicker(
                                mode: CupertinoDatePickerMode.date,
                                headerText: "Select End Date",
                                context: context,
                                defaultDateTime: c.cellValue is DateTime ? c.cellValue : null,
                                onDateTimeChanged: (date) {
                                  if (date != null) {
                                    int index = userSubscriptionController.subDataGridData.indexWhere((i) => i['id'] == c.rowValue['id']);
                                    userSubscriptionController.subDataGridData[index]['startDate'] = date;
                                    userSubscriptionController.update();
                                  }
                                },
                              );
                            },
                            child: TextHelper(
                              text: (c.cellValue is DateTime && c.cellValue != null) ? DateFormat('dd-MM-yyyy').format(c.cellValue) : "",
                              fontsize: 10.5,
                              textalign: TextAlign.center,
                            ),
                          );
                        },
                        dataType: CellDataType3.string,
                      ),
                      DataGridColumnModel3(
                        dataField: 'endDate',
                        title: 'End Date',
                        dataType: CellDataType3.string,
                        customCell: (c) {
                          return GestureDetector(
                            onTap: () async {
                              DateTimePicker.dateTimePicker(
                                mode: CupertinoDatePickerMode.date,
                                headerText: "Select End Date",
                                context: context,
                                defaultDateTime: c.cellValue is DateTime ? c.cellValue : null,
                                onDateTimeChanged: (date) {
                                  if (date != null) {
                                    int index = userSubscriptionController.subDataGridData.indexWhere((i) => i['id'] == c.rowValue['id']);
                                    userSubscriptionController.subDataGridData[index]['endDate'] = date;
                                    userSubscriptionController.update();
                                  }
                                },
                              );
                            },
                            child: TextHelper(
                              text: (c.cellValue is DateTime && c.cellValue != null) ? DateFormat('dd-MM-yyyy').format(c.cellValue) : "",
                              fontsize: 10.5,
                              textalign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      DataGridColumnModel3(
                        dataField: 'sessionCount',
                        title: 'Session Count',
                        selectTextOnEditStart: true,
                        dataType: CellDataType3.int,
                        editable: true,
                        keyboard: TextInputType.number,
                      ),
                      DataGridColumnModel3(
                        dataField: '',
                        title: '',
                        dataType: CellDataType3.string,
                        width: 40,
                        customCell: (c) {
                          return ButtonHelperG(
                            onTap: () {
                              int index = userSubscriptionController.subDataGridData.indexWhere((i) => i['id'] == c.rowValue['id']);
                              userSubscriptionController.subDataGridData.removeAt(index);
                              userSubscriptionController.update();
                            },
                            shadow: [],
                            background: Colors.green.shade100,
                            icon: Icon(Icons.delete, size: 14, color: Colors.green.shade900),
                          );
                        },
                      ),
                    ],
                    uniqueKey: UniqueKey().toString(),
                    width: MediaQuery.sizeOf(context).width - 10,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/features/slot_manage/controller/slot_manage_controller.dart';
import 'package:intl/intl.dart';

import '../../../app/mainstore.dart';
import '../../../core/utility/helper.dart';

Future<void> slotAddPopupWeekly(BuildContext context) async {
  final slotController = Get.find<SlotController>();
  List<Map<String, dynamic>> yearList = List.generate(50, (index) => {'id': 2000 + index, 'name': '${2000 + index}'});
  List<Map<String, dynamic>> monthList = List.generate(12, (index) => {'id': 1 + index, 'name': DateFormat('MMMM').format(DateTime(2000, index + 1, 1))});
  List<Map<String, dynamic>> weekList = List.generate(4, (index) => {'id': 1 + index, 'name': '${1 + index}'});
  List<Map<String, dynamic>> weekCountList = List.generate(52, (index) => {'id': 1 + index, 'name': '${1 + index}'});
  await showAdaptiveDialog(
    builder: (_) {
      int year = DateTime.now().year;
      int month = DateTime.now().month - 1;
      int week = 1;
      int weekCount = 2;
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 450, minHeight: 200, maxWidth: 450, minWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    TextHelper(text: "Slot manage", fontweight: FontWeight.w600, fontsize: 14),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHelper(text: 'Select Week : ', width: 100),
                        Expanded(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              SizedBox(
                                width: 120,
                                child: DropDownHelperG(
                                  height: 35,
                                  uniqueKey: UniqueKey().toString(),
                                  items: yearList,
                                  leading: null,
                                  showClearText: false,
                                  showLabelAlways: true,
                                  labelText: 'Year ',
                                  value: yearList.firstWhereOrNull((w) => w['id'] == year) ?? {},
                                  onValueChange: (v) {
                                    setState(() {
                                      year = v['id'];
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: DropDownHelperG(
                                  height: 35,
                                  uniqueKey: UniqueKey().toString(),
                                  items: monthList,
                                  leading: null,
                                  showClearText: false,
                                  showLabelAlways: true,
                                  labelText: 'Month ',
                                  value: monthList.firstWhereOrNull((w) => w['id'] == month) ?? {},
                                  onValueChange: (v) {
                                    setState(() {
                                      month = v['id'];
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: DropDownHelperG(
                                  height: 35,
                                  listHeight: 130,
                                  uniqueKey: UniqueKey().toString(),
                                  items: weekList,
                                  leading: null,
                                  showClearText: false,
                                  showLabelAlways: true,
                                  labelText: 'Week',
                                  value: weekList.firstWhereOrNull((w) => w['id'] == week) ?? {},
                                  onValueChange: (v) {
                                    setState(() {
                                      week = v['id'];
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     TextHelper(text: 'Fill for next : ', width: 100),
                    //     Expanded(
                    //       child: Wrap(
                    //         crossAxisAlignment: WrapCrossAlignment.center,
                    //         spacing: 10,
                    //         runSpacing: 10,
                    //         children: [
                    //           SizedBox(
                    //             width: 90,
                    //             child: DropDownHelperG(
                    //               height: 35,
                    //               uniqueKey: UniqueKey().toString(),
                    //               items: weekCountList,
                    //               leading: null,
                    //               showClearText: false,
                    //               showLabelAlways: true,
                    //               labelText: 'Count ',
                    //               value: weekCountList.firstWhereOrNull((w) => w['id'] == weekCount) ?? {},
                    //               onValueChange: (v) {
                    //                 setState(() {
                    //                   weekCount = v['id'];
                    //                 });
                    //               },
                    //             ),
                    //           ),
                    //           TextHelper(text: 'weeks', width: 50),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Divider(),

                    ButtonHelperG(
                      onTap: () async {
                        try {
                          Loader.startLoading();
                          await slotController.slotDataFeelFromSelectedWeek(year, month, week, weekCount: 4);
                          goBack(context);
                        } catch (e) {
                          showAlert("$e", AlertType.error);
                        } finally {
                          Loader.stopLoading();
                        }
                      },
                      width: 90,
                      height: 35,
                      label: TextHelper(text: 'Fill the slots', color: getMainStore().theme.value.BackgroundColor),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
    context: context,
  );
}

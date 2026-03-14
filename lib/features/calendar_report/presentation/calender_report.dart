import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/features/slot_details_trainer/controller/slot_details_controller.dart';
import 'package:intl/intl.dart';

import '../../../core/branch/controller/branch_controller.dart';
import '../../../core/utility/firebase_service.dart';
import '../../../core/utility/helper.dart';
import '../../slot_manage/data/slot_making_model.dart';
import '../controller/calendar_report_controller.dart';

class CalenderReport extends StatefulWidget {
  const CalenderReport({super.key});

  @override
  State<CalenderReport> createState() => _CalenderReportState();
}

class _CalenderReportState extends State<CalenderReport> {
  final mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();

  final slotDetailsController = Get.find<SlotDetailsController>();
  final CalenderReportController calenderReportController = Get.find<CalenderReportController>();
  final BranchController branchController = Get.find<BranchController>();

  Future<void> loadData() async {
    try {
      loader.startLoading();

      if (calenderReportController.selectedBranch == null) {
        await branchController.getBranchList();
        if (branchController.list.isNotEmpty) {
          calenderReportController.selectedBranch = branchController.list[0].toJson();
        }
      }

      await calenderReportController.loadSlots();
    } catch (e) {
      showAlert("$e", AlertType.error);
    } finally {
      loader.stopLoading();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      await loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CalenderReportController>(
      init: calenderReportController,
      autoRemove: false,
      builder: (calenderReportController) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextHelper(text: "Monthly overview", fontsize: 15, fontweight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: 130,
                        child: GetBuilder<BranchController>(
                          init: branchController,
                          autoRemove: false,
                          builder: (branchController) {
                            return DropDownHelperG(
                              uniqueKey: UniqueKey().toString(),
                              trailing: SizedBox.shrink(),
                              height: 35,
                              labelText: 'Branch',
                              showLabelAlways: true,
                              fontSize: 12,
                              onValueChange: (v) async {
                                calenderReportController.selectedBranch = v;
                                await loadData();
                                calenderReportController.update();
                              },
                              value: calenderReportController.selectedBranch,
                              items: branchController.list.map((m) => m.toJson()).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      firstDate: DateTime(2020, 02, 01),
                      lastDate: DateTime(2096, 02, 29),
                      hideNextMonthIcon: true,
                      hideMonthPickerDividers: true,
                      hideLastMonthIcon: true,
                      hideYearPickerDividers: true,
                      hideScrollViewMonthWeekHeader: true,
                      hideScrollViewTopHeader: true,
                      hideScrollViewTopHeaderDivider: true,
                      currentDate: DateTime.now(),
                      controlsTextStyle: TextStyle(fontSize: 12),
                      calendarType: CalendarDatePicker2Type.single,
                      calendarViewMode: CalendarDatePicker2Mode.day,
                      dayBuilder:
                          ({
                            required DateTime date, // Changed from dynamic dateToBuild
                            TextStyle? textStyle, // This must be included
                            BoxDecoration? decoration,
                            bool? isSelected,
                            bool? isDisabled,
                            bool? isToday,
                          }) {
                            final tc = calenderReportController.totalCount(DateFormat('yyyy-MM-dd').format(date));
                            return Center(
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: tc.backgroundColor),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextHelper(text: date.day.toString(), textalign: TextAlign.center, color: tc.fontColor),
                                      // if (tc.booked > 0)
                                      TextHelper(text: "${tc.booked} / ${tc.maxBookingSlot}", fontsize: 10, textalign: TextAlign.center, color: tc.fontColor1),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                    ),
                    value: [calenderReportController.selectedDate],
                    onValueChanged: (v) {
                      if (v.isNotEmpty) {
                        calenderReportController.selectedDate = v[0];
                        calenderReportController.update();
                      }
                    },
                  ),
                  Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextHelper(
                          text: "Details of ${DateFormat('dd-MM-yyyy').format(calenderReportController.selectedDate)}",
                          fontweight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  ...calenderReportController.getDayDetails().map((m) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        spacing: 3,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextHelper(text: m.serviceName, fontsize: 13, fontweight: FontWeight.w600, isWrap: true),
                              ),
                              TextHelper(text: "${m.booked} / ${m.maxBookingSlot}", fontsize: 13, fontweight: FontWeight.w600, isWrap: true),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            child: DataGridHelper3(
                              headerColor: mainStore.theme.value.mediumShadeColor,
                              dataSource: m.slots.map((m) => m.toJSON()).toList(),
                              fontSize: 12,
                              columnList: [
                                DataGridColumnModel3(
                                  dataField: "slot",
                                  dataType: CellDataType3.string,
                                  title: "Slot",
                                  customCell: (c) {
                                    return GestureDetector(
                                      onTap: () async {
                                        try {
                                          Loader.startLoading();
                                          final fb = Get.find<FB>();
                                          final db = await fb.getDB();
                                          final resp = await db.collection('slots').doc(c.rowValue['slotId']).get();
                                          if (!resp.exists) {
                                            throw Exception('No slot data found!');
                                          }
                                          await slotDetailsController.getSlotDetails(selectedSlot: SlotModel.fromFirestore(resp));
                                          Get.toNamed('/slotdetailsreceptionist');
                                        } catch (e) {
                                          showAlert("$e", AlertType.error);
                                        } finally {
                                          Loader.stopLoading();
                                        }
                                      },
                                      child: TextHelper(text: c.cellValue, textalign: TextAlign.center, fontsize: 12),
                                    );
                                  },
                                ),
                                DataGridColumnModel3(dataField: "booked", dataType: CellDataType3.int, title: "Booking"),
                                DataGridColumnModel3(dataField: 'totalAttendance', dataType: CellDataType3.int, title: "Attend"),
                              ],
                              uniqueKey: UniqueKey().toString(),
                              width: MediaQuery.sizeOf(context).width - 48,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

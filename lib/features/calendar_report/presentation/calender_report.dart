import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:intl/intl.dart';

import '../../../core/utility/helper.dart';
import '../controller/calendar_report_controller.dart';

class CalenderReport extends StatefulWidget {
  const CalenderReport({super.key});

  @override
  State<CalenderReport> createState() => _CalenderReportState();
}

class _CalenderReportState extends State<CalenderReport> {
  final mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();

  final CalenderReportController calenderReportController = Get.find<CalenderReportController>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        loader.startLoading();
        await calenderReportController.loadSlots();
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    return GetBuilder<CalenderReportController>(
      init: calenderReportController,
      autoRemove: false,
      builder: (calenderReportController) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(left: safePadding.left + 10, right: safePadding.right + 10, top: safePadding.top + 10, bottom: safePadding.bottom),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextHelper(text: "Monthly overview", fontsize: 15, fontweight: FontWeight.w600),

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
                            final tc = calenderReportController.totalCount(DateFormat('yyyy-MM-dd').format(daslotte));
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
                      logG(v);
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
                              headerColor: Colors.green.shade100,
                              dataSource: m.slots.map((m) => m.toJSON()).toList(),
                              fontSize: 12,
                              columnList: [
                                DataGridColumnModel3(dataField: "slot", dataType: CellDataType3.string, title: "Slot"),
                                DataGridColumnModel3(dataField: "booked", dataType: CellDataType3.int, title: "Booking"),
                              ],
                              uniqueKey: UniqueKey().toString(),
                              width: MediaQuery.sizeOf(context).width * 0.89,
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

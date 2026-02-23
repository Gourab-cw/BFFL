import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/receptionist/schedule/presentation/day_scheduler_tile.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../controller/daily_schedule_controller.dart';

class DailySchedule extends StatefulWidget {
  const DailySchedule({super.key});

  @override
  State<DailySchedule> createState() => _DailyScheduleState();
}

class _DailyScheduleState extends State<DailySchedule> {
  final mainStore = Get.find<MainStore>();
  // final loader = Get.find<AppLoaderController>();
  final dailyScheduleController = Get.find<DailyScheduleController>();

  Widget getDayWidget(DateTime d, bool isSelected) {
    return GestureDetector(
      onTap: () async {
        dailyScheduleController.selectedDate = d;
        dailyScheduleController.update();
        try {
          Loader.startLoading();
          await dailyScheduleController.getSessions();
        } catch (e) {
          showAlert("$e", AlertType.error);
        } finally {
          Loader.stopLoading();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastEaseInToSlowEaseOut,
        width: 40,
        height: 40,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: isSelected ? mainStore.theme.value.BottomNavColor : mainStore.theme.value.lowShadeColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextHelper(
              text: DateFormat('EEE').format(d),
              textalign: TextAlign.center,
              fontsize: 11,
              color: isSelected ? mainStore.theme.value.DarkTextColor : null,
            ),
            TextHelper(
              text: DateFormat('dd').format(d),
              textalign: TextAlign.center,
              fontweight: FontWeight.w600,
              color: isSelected ? mainStore.theme.value.DarkTextColor : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    Future(() async {
      try {
        Loader.startLoading();
        await dailyScheduleController.getSessions();
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyScheduleController>(
      init: dailyScheduleController,
      autoRemove: false,
      builder: (dailyScheduleController) {
        return GetBuilder<MainStore>(
          init: mainStore,
          autoRemove: false,
          builder: (mainStore) {
            return Scaffold(
              body: Column(
                spacing: 6,
                children: [
                  TextHelper(text: "Daily Status", fontweight: FontWeight.w600, fontsize: 15),
                  Row(
                    children: [
                      ButtonHelperG(
                        onTap: () {
                          dailyScheduleController.getPrevDate();
                        },
                        label: Icon(Icons.arrow_left),
                        background: mainStore.theme.value.secondaryColor.withAlpha(40),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          spacing: 10,
                          children: dailyScheduleController.dateList.map((m) {
                            DateTime d1 = m;
                            DateTime d0 = dailyScheduleController.selectedDate;
                            return getDayWidget(d1, DateFormat('yyyy-MM-dd').format(d0) == DateFormat('yyyy-MM-dd').format(d1));
                          }).toList(),
                        ),
                      ),
                      ButtonHelperG(
                        onTap: () {
                          dailyScheduleController.getNextDate();
                        },
                        label: Icon(Icons.arrow_right),
                        background: mainStore.theme.value.secondaryColor.withAlpha(40),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      TextHelper(text: 'Selected : '),
                      TextHelper(
                        text: DateFormat('dd-MM-yyyy').format(dailyScheduleController.selectedDate),
                        color: mainStore.theme.value.secondaryColor,
                        fontweight: FontWeight.w800,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      Container(
                        width: 95,
                        height: 60,
                        decoration: BoxDecoration(
                          color: mainStore.theme.value.lowShadeColor,
                          border: Border.all(color: mainStore.theme.value.HeadColor.withAlpha(30)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextHelper(
                              text: dailyScheduleController.daysSessionList.values.map((m) => m.length).fold(0, (a, b) => a + b).toString(),
                              fontsize: 15,
                              textalign: TextAlign.center,
                              fontweight: FontWeight.w600,
                              color: mainStore.theme.value.HeadColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MoonIcons.generic_users_24_regular, size: 20),
                                TextHelper(
                                  text: 'Booked',
                                  fontsize: 11.5,
                                  textalign: TextAlign.center,
                                  color: mainStore.theme.value.LightTextColor.withAlpha(220),
                                  fontweight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 95,
                        height: 60,
                        decoration: BoxDecoration(
                          color: mainStore.theme.value.lowShadeColor,
                          border: Border.all(color: mainStore.theme.value.HeadColor.withAlpha(30)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextHelper(
                              text: dailyScheduleController.daysSessionList.values
                                  .map((m) => m.where((w) => w.hasAttend).length)
                                  .fold(0, (a, b) => a + b)
                                  .toString(),
                              fontsize: 15,
                              textalign: TextAlign.center,
                              fontweight: FontWeight.w600,
                              color: mainStore.theme.value.HeadColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(MoonIcons.generic_check_alternative_24_regular, size: 20),
                                TextHelper(
                                  text: 'Attended',
                                  fontsize: 11.5,
                                  textalign: TextAlign.center,
                                  color: mainStore.theme.value.LightTextColor.withAlpha(220),
                                  fontweight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextHelper(text: "Sessions", fontweight: FontWeight.w600, fontsize: 15),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: mainStore.theme.value.lowShadeColor.withAlpha(100),
                        border: Border.all(color: mainStore.theme.value.mediumShadeColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(18.0),
                      margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: dailyScheduleController.daysSessionList.keys.length,
                        itemBuilder: (ctx, index) {
                          final s = dailyScheduleController.daysSessionList.keys.toList()[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 3,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.watch_later_outlined, size: 15),
                                        TextHelper(
                                          text: s,
                                          fontsize: 12.6,
                                          fontweight: FontWeight.w600,
                                          color: mainStore.theme.value.LightTextColor.withAlpha(200),
                                        ),
                                      ],
                                    ),
                                    ButtonHelperG(
                                      background: mainStore.theme.value.HeadColor.withAlpha(200),
                                      width: 80,
                                      height: 25,
                                      margin: 0,
                                      label: TextHelper(text: "Details", fontsize: 11, color: mainStore.theme.value.BackgroundColor),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: dailyScheduleController.daysSessionList[s]?.length,
                                  itemBuilder: (ctx, index) {
                                    final session = dailyScheduleController.daysSessionList[s]?[index];
                                    if (session == null) {
                                      return SizedBox.shrink();
                                    }
                                    int lastIndex = (dailyScheduleController.daysSessionList[s]?.length ?? 0) - 1;
                                    return DaySchedulerTile(
                                      sessionModel: session,
                                      lastIndex: lastIndex,
                                      index: index,
                                      dailyScheduleController: dailyScheduleController,
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

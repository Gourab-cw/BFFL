import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/features/receptionist/schedule/controller/daily_schedule_controller.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../../../../core/utility/helper.dart';
import '../../../Service/data/session_model.dart';

class DaySchedulerTile extends StatefulWidget {
  final SessionModel sessionModel;
  final int lastIndex;
  final int index;
  final DailyScheduleController dailyScheduleController;
  const DaySchedulerTile({super.key, required this.sessionModel, required this.lastIndex, required this.index, required this.dailyScheduleController});

  @override
  State<DaySchedulerTile> createState() => _DaySchedulerTileState();
}

class _DaySchedulerTileState extends State<DaySchedulerTile> {
  final mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();

  bool getIsReschedule() {
    final session = widget.sessionModel;
    final sessionTime = parseInt(data: (session.date + session.startTime).replaceAll('-', '').replaceAll(':', ''), defaultInt: 0);
    final now = parseInt(
      data: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).replaceAll(' ', '').replaceAll('-', '').replaceAll(':', ''),
      defaultInt: 0,
    );
    return sessionTime > now;
  }

  bool getCheckIn() {
    final session = widget.sessionModel;
    final sessionTime = parseInt(data: (session.date + session.startTime).replaceAll('-', '').replaceAll(':', ''), defaultInt: 0);
    final sessionEndTime = parseInt(data: (session.date + session.endTime).replaceAll('-', '').replaceAll(':', ''), defaultInt: 0);
    final now = parseInt(
      data: DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).replaceAll(' ', '').replaceAll('-', '').replaceAll(':', ''),
      defaultInt: 0,
    );
    return sessionTime < now && now < sessionEndTime;
  }

  @override
  Widget build(BuildContext context) {
    bool isReschedule = getIsReschedule();
    bool isCheckIn = getCheckIn();
    int lastIndex = widget.lastIndex;
    int index = widget.index;
    final session = widget.sessionModel;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 20),
        Transform(
          transform: Matrix4.translationValues(
            8,
            lastIndex == index
                ? (isReschedule || isCheckIn)
                      ? -38
                      : -28
                : index == 0
                ? -8
                : -15,
            0,
          ),
          child: Container(
            height: lastIndex == index
                ? (isReschedule || isCheckIn)
                      ? 65
                      : 44
                : (isReschedule || isCheckIn)
                ? 110
                : 74,
            width: 10,
            decoration: BoxDecoration(
              boxShadow: [],
              // color: mainStore.theme.value.HeadColor.withAlpha(160),
              borderRadius: lastIndex == index ? BorderRadius.only(bottomLeft: Radius.elliptical(10, 18)) : null,
              // borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(20, 15)),
              border: Border(
                bottom: lastIndex == index ? BorderSide(color: mainStore.theme.value.HeadColor.withAlpha(100)) : BorderSide.none,
                left: BorderSide(color: mainStore.theme.value.HeadColor.withAlpha(100)),
              ),
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(0, -25, 0),
          child: Container(
            height: 40,
            width: 28,
            decoration: BoxDecoration(
              boxShadow: [],
              borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(10, 15)),
              border: Border(
                bottom: BorderSide(color: mainStore.theme.value.HeadColor.withAlpha(160)),
                // left: BorderSide(color: mainStore.theme.value.HeadColor.withAlpha(160)),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: mainStore.theme.value.HeadColor.withAlpha(40)),
              color: mainStore.theme.value.BackgroundColor,
            ),
            child: Column(
              spacing: 0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextHelper(text: session.memberName ?? "", fontweight: FontWeight.w600),
                    Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 3),
                          decoration: BoxDecoration(color: mainStore.theme.value.HeadColor.withAlpha(10), borderRadius: BorderRadius.circular(5)),
                          child: TextHelper(
                            text: session.hasAttend ? "Attended" : "Not Attended",
                            fontsize: 10,
                            fontweight: session.hasAttend ? FontWeight.w600 : FontWeight.w400,
                            color: session.hasAttend ? mainStore.theme.value.HeadColor : null,
                          ),
                        ),
                        if (session.memberContact1 != null && session.memberContact1 != "")
                          ButtonHelperG(
                            onTap: () async {
                              try {
                                await makePhoneCall(session.memberContact1!, context);
                              } catch (e) {
                                showAlert("$e", AlertType.error);
                              }
                            },
                            background: mainStore.theme.value.mediumShadeColor,
                            margin: 0,
                            height: 30,
                            width: 30,
                            icon: Icon(Icons.call, size: 15),
                          ),
                      ],
                    ),
                  ],
                ),
                Wrap(
                  spacing: 10,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 3,
                      children: [
                        Icon(MoonIcons.generic_ticket_24_regular, size: 16),
                        TextHelper(text: session.serviceName ?? "", fontsize: 10.5),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(MoonIcons.generic_user_24_regular, size: 16),
                        TextHelper(text: session.trainerName ?? "", fontsize: 10.5),
                      ],
                    ),
                  ],
                ),
                if (isReschedule)
                  Center(
                    child: ButtonHelperG(
                      onTap: () async {
                        try {
                          Loader.startLoading();
                          await widget.dailyScheduleController.goForReschedule(session);
                        } catch (e) {
                          showAlert("$e", AlertType.error);
                        } finally {
                          Loader.stopLoading();
                        }
                      },
                      height: 25,
                      width: 200,
                      background: mainStore.theme.value.mediumShadeColor,
                      label: TextHelper(text: 'Reschedule', fontsize: 11, fontweight: FontWeight.w600),
                    ),
                  ),
                if ((isCheckIn))
                  Center(
                    child: ButtonHelperG(
                      onTap: () {
                        if (session.hasAttend) {
                          return;
                        }
                      },
                      height: 25,
                      type: ButtonHelperTypeG.outlined,
                      width: 200,
                      background: mainStore.theme.value.mediumShadeColor,
                      withBorder: true,
                      label: TextHelper(
                        text: session.hasAttend
                            ? session.attendedAt == null
                                  ? "Attended"
                                  : DateFormat('dd-MM-yyyy HH:mm a').format(session.attendedAt!)
                            : 'Check In',
                        fontsize: 11,
                        fontweight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

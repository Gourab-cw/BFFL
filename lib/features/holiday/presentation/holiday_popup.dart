import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/holiday/controller/holiday_controller.dart';
import 'package:healthandwellness/features/holiday/data/holiday.dart';
import 'package:moon_design/moon_design.dart';

import '../../../core/utility/app_loader.dart';
import '../../../core/utility/helper.dart';

Future<void> holidayPopup(HolidayModel day, BuildContext context, HolidayController holidayController, AppLoaderController loader) async {
  List<Map<String, dynamic>> activeInactiveList = [
    {"id": 1, "name": "Active", "value": true},
    {"id": 0, "name": "InActive", "value": false},
  ];

  await showAdaptiveDialog(
    context: context,
    builder: (_) {
      bool showUpdateBtn = false;
      HolidayModel holiday = holidayController.holidays.firstWhere((f) => f.id == day.id);
      return StatefulBuilder(
        builder: (context, setState) {
          return AppLoader(
            child: AlertDialog(
              backgroundColor: getMainStore().theme.value.BackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              title: Row(
                spacing: 6,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FontAwesomeIcons.calendar, size: 18),
                  TextHelper(text: "Holiday", width: 100, fontsize: 16),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper(text: "Name :", width: 80),
                      TextHelper(text: holiday.holidayName),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper(text: "Date :", width: 80),
                      TextHelper(
                        text: parseDateToString(data: holiday.holidayDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: "yyyy-MM-dd", defaultValue: ""),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper(text: "Active :", width: 80),
                      MoonSwitch(
                        value: holiday.isActive,
                        switchSize: MoonSwitchSize.xs,
                        activeTrackColor: Colors.green[400],
                        onChanged: (v) {
                          holiday = holiday.copyWith(isActive: v);
                          setState(() {
                            showUpdateBtn = true;
                            holiday = holiday;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                if (showUpdateBtn)
                  ButtonHelperG(
                    onTap: () async {
                      try {
                        loader.startLoading();
                        await holidayController.updateHoliday(holiday);
                        showAlert("Updated Successfully", AlertType.success);
                        goBack(context);
                      } catch (e) {
                        showAlert("$e", AlertType.error);
                      } finally {
                        loader.stopLoading();
                      }
                    },
                    shadow: [],
                    width: 60,
                    height: 35,
                    label: TextHelper(text: "Update", color: getMainStore().theme.value.BackgroundColor),
                  ),
                ButtonHelperG(
                  onTap: () async {
                    goBack(context);
                  },
                  shadow: [],
                  width: 60,
                  height: 35,
                  background: getMainStore().theme.value.HeadColor.withAlpha(50),
                  label: TextHelper(text: "Close"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

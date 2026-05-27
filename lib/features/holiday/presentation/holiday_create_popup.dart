import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/branch/controller/branch_controller.dart';
import 'package:healthandwellness/features/holiday/controller/holiday_controller.dart';
import 'package:healthandwellness/features/holiday/data/holiday.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../../../core/utility/app_loader.dart';
import '../../../core/utility/helper.dart';
import '../../login/data/user.dart';
import '../../login/repository/authenticator.dart';

Future<void> holidayCreatePopup(BuildContext context, HolidayController holidayController, AppLoaderController loader) async {
  final auth = Get.find<Authenticator>();
  final branchController = Get.find<BranchController>();
  await showAdaptiveDialog(
    context: context,
    builder: (_) {
      DateTime date = DateTime.now();
      TextEditingController name = TextEditingController();
      HolidayModel holiday = HolidayModel(
        holidayName: "",
        holidayDate: DateFormat('yyyy-MM-dd').format(date),
        isActive: true,
        branchId: auth.state!.branchId,
        companyId: auth.state!.companyId,
      );
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
                      TextBox(controller: name, width: 180),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextHelper(text: "Date :", width: 80),
                      GestureDetector(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateFormat('yyyy-MM-dd').parse(holiday.holidayDate),
                            initialDatePickerMode: DatePickerMode.day,
                            helpText: "Select Date",
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            holiday = holiday.copyWith(holidayDate: DateFormat('yyyy-MM-dd').format(date));
                            setState(() {
                              holiday = holiday;
                            });
                          }
                        },
                        child: TextHelper(
                          text: parseDateToString(data: holiday.holidayDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: "yyyy-MM-dd", defaultValue: ""),
                        ),
                      ),
                    ],
                  ),
                  if (auth.state?.userType == UserType.admin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextHelper(text: "Branch :", width: 80),
                        SizedBox(
                          width: 180,
                          child: DropDownHelperG(
                            uniqueKey: UniqueKey().toString(),
                            height: 35,
                            value: branchController.list.firstWhereOrNull((b) => b.id == holiday.branchId)?.toJson(),
                            items: branchController.list.map((e) => e.toJson()).toList(),
                            onValueChange: (v) {
                              if (v["id"] != null) {
                                setState(() {
                                  holiday = holiday.copyWith(branchId: v["id"]);
                                  holiday = holiday;
                                });
                              }
                            },
                          ),
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
                            holiday = holiday;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                ButtonHelperG(
                  onTap: () async {
                    try {
                      if (name.text.trim().isEmpty) {
                        showAlert("Please enter name", AlertType.error);
                        return;
                      }
                      holiday = holiday.copyWith(holidayName: name.text.trim());
                      loader.startLoading();
                      await holidayController.createHoliday(holiday);
                      showAlert("Created Successfully", AlertType.success);
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
                  label: TextHelper(text: "Add", color: getMainStore().theme.value.BackgroundColor),
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

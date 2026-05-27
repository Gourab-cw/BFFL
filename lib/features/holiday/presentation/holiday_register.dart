import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/branch/controller/branch_controller.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:moon_design/moon_design.dart';

import '../../../app/mainstore.dart';
import '../controller/holiday_controller.dart';
import '../data/holiday.dart';
import 'holiday_create_popup.dart';
import 'holiday_popup.dart';

class HolidayRegister extends StatefulWidget {
  const HolidayRegister({super.key});

  @override
  State<HolidayRegister> createState() => _HolidayRegisterState();
}

class _HolidayRegisterState extends State<HolidayRegister> {
  HolidayController holidayController = Get.find<HolidayController>();
  BranchController branchController = Get.find<BranchController>();
  final mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        loader.startLoading();
        if (branchController.list.isEmpty) {
          await branchController.getBranchList();
        }
        await holidayController.getHolidays();
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
    return AppLoader(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Holiday Register"),
          actions: [
            ButtonHelperG(
              onTap: () async {
                try {
                  loader.startLoading();
                  await holidayController.getHolidays();
                } catch (e) {
                  showAlert("$e", AlertType.error);
                } finally {
                  loader.stopLoading();
                }
              },
              shadow: [],
              width: 80,
              height: 35,
              icon: Icon(Icons.refresh),
              label: TextHelper(text: "Refresh", color: getMainStore().theme.value.BackgroundColor),
            ),
          ],
        ),
        body: SafeArea(
          child: GetBuilder(
            init: holidayController,
            autoRemove: false,
            builder: (holidayController) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextBox(
                            controller: searchTextController,
                            leading: Icon(MoonIcons.generic_search_24_regular),
                            placeholder: "Search..",
                            onValueChange: (c) {
                              holidayController.update();
                            },
                          ),
                        ),
                        ButtonHelperG(
                          onTap: () async {
                            await holidayCreatePopup(context, holidayController, loader);
                          },
                          shadow: [],
                          width: 60,
                          background: mainStore.theme.value.BackgroundColor,
                          height: 35,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: mainStore.theme.value.HeadColor, size: 18),
                              TextHelper(text: "Add", color: mainStore.theme.value.HeadColor, fontweight: FontWeight.w600, fontsize: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Builder(
                    builder: (context) {
                      if (holidayController.holidays.isEmpty) {
                        return Center(child: TextHelper(text: "No data found"));
                      }
                      List<HolidayModel> filteredList = holidayController.holidays;
                      if (searchTextController.text.isNotEmpty) {
                        filteredList = holidayController.holidays
                            .where((element) => element.holidayName.toLowerCase().contains(searchTextController.text.toLowerCase()))
                            .toList();
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: filteredList.length,
                          padding: EdgeInsets.all(5),
                          itemBuilder: (_, index) {
                            HolidayModel holiday = filteredList[index];
                            return CardHelper(
                              onTap: () {
                                holidayPopup(holiday, context, holidayController, loader);
                              },
                              backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                              height: 40,
                              boxShadow: [],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 4,
                                    children: [
                                      Icon(FontAwesomeIcons.calendarDay, size: 16, color: mainStore.theme.value.HeadColor.withAlpha(180)),
                                      TextHelper(text: holiday.holidayName),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      TextHelper(
                                        text: parseDateToString(
                                          data: holiday.holidayDate,
                                          formatDate: 'dd-MM-yyyy',
                                          predefinedDateFormat: 'yyyy-MM-dd',
                                          defaultValue: "",
                                        ),
                                        width: 80,
                                      ),
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: holiday.isActive ? Colors.green : Colors.deepOrange.shade900.withAlpha(200),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

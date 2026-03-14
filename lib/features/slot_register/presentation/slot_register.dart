import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/daterangepicker.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/slot_details_trainer/controller/slot_details_controller.dart';
import 'package:healthandwellness/features/slot_register/controller/slot_register_controller.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:moon_design/moon_design.dart';

import '../../slot_manage/data/slot_making_model.dart';

class SlotRegister extends StatefulWidget {
  const SlotRegister({super.key});

  @override
  State<SlotRegister> createState() => _SlotRegisterState();
}

class _SlotRegisterState extends State<SlotRegister> {
  final slotRegisterController = Get.find<SlotRegisterController>();
  final slotDetailsController = Get.find<SlotDetailsController>();
  final sc = Get.find<SubscriptionController>();
  final searchText = TextEditingController();
  final mainStore = Get.find<MainStore>();

  bool showSearch = false;

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        await slotRegisterController.fetchRegister();
      } catch (e) {
        showAlert('$e', AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  List<SlotModel> filteredRegister(String searchText) {
    String text = searchText.replaceAll(',', '').replaceAll(' ', '');

    if (text.isEmpty) {
      return slotRegisterController.register;
    }
    return slotRegisterController.register.where((w) {
      String serviceName = (sc.list.firstWhereOrNull((f) => f.id == w.serviceId)?.name ?? "").replaceAll(',', '').replaceAll(' ', '').toLowerCase();
      String date = parseDateToString(
        data: w.date,
        formatDate: 'EEE, dd-MM-yyyy',
        predefinedDateFormat: 'yyyy-MM-dd',
        defaultValue: '',
      ).replaceAll(',', '').replaceAll(' ', '');
      return (date.contains(text) || serviceName.toLowerCase().contains(text) || w.startTime.contains(text) || w.endTime.contains(text));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlotRegisterController>(
      init: slotRegisterController,
      autoRemove: false,
      builder: (slotRegisterController) {
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Register'),
              actions: [
                ButtonHelperG(
                  shadow: [],
                  onTap: () async {
                    try {
                      Loader.startLoading();
                      await slotRegisterController.fetchRegister();
                    } catch (e) {
                      showAlert('$e', AlertType.error);
                    } finally {
                      Loader.stopLoading();
                    }
                  },
                  icon: Icon(Icons.refresh),
                ),
                DateRangePicker(
                  height: 40,
                  fontColor: mainStore.theme.value.BackgroundColor,
                  backgroundColor: mainStore.theme.value.HeadColor.withAlpha(180),
                  withBorder: false,
                  onValueChange: (v) async {
                    if (slotRegisterController.selectedDate != v) {
                      slotRegisterController.selectedDate = v;
                      try {
                        Loader.startLoading();
                        await slotRegisterController.fetchRegister();
                      } catch (e) {
                        showAlert('$e', AlertType.error);
                      } finally {
                        Loader.stopLoading();
                      }
                      slotRegisterController.update();
                    }
                  },
                  selectedDateRange: slotRegisterController.selectedDate,
                ),
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 10),
                    if (showSearch)
                      Expanded(
                        child: TextBox(
                          controller: searchText,
                          autofocus: true,
                          onValueChange: (v) {
                            slotRegisterController.searchTerm = v;
                            slotRegisterController.update();
                          },
                        ),
                      ),
                    ButtonHelperG(
                      background: mainStore.theme.value.mediumShadeColor,
                      onTap: () {
                        setState(() {
                          showSearch = !showSearch;
                          if (!showSearch) {
                            slotRegisterController.searchTerm = '';
                            slotRegisterController.update();
                          }
                        });
                      },
                      icon: showSearch ? Icon(Icons.close) : Icon(Icons.search),
                    ),

                    const SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final list = filteredRegister(slotRegisterController.searchTerm);
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (_, index) {
                          final s = list[index];
                          return GestureDetector(
                            onTap: () async {
                              try {
                                Loader.startLoading();
                                await slotDetailsController.getSlotDetails(selectedSlot: s);
                                Get.toNamed('/slotdetailsreceptionist');
                              } catch (e) {
                                showAlert("$e", AlertType.error);
                              } finally {
                                Loader.stopLoading();
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CardHelper(
                                  margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                                  height: 80,
                                  child: Row(
                                    spacing: 8,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(MoonIcons.generic_ticket_24_regular),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                TextHelper(text: sc.list.firstWhereOrNull((f) => f.id == s.serviceId)?.name ?? "", fontweight: FontWeight.w600),
                                                Spacer(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Icon(MoonIcons.generic_users_24_regular, size: 18, color: mainStore.theme.value.HeadColor),
                                                    TextHelper(text: s.bookingCount.toString()),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              spacing: 8,
                                              children: [
                                                Icon(Icons.watch_later, size: 17, color: mainStore.theme.value.HeadColor.withAlpha(150)),
                                                TextHelper(text: '${s.startTime} - ${s.endTime}', fontsize: 11.5),
                                              ],
                                            ),
                                            Row(
                                              spacing: 8,
                                              children: [
                                                Icon(Icons.calendar_month, size: 17, color: mainStore.theme.value.HeadColor.withAlpha(150)),
                                                TextHelper(
                                                  text: parseDateToString(
                                                    data: s.date,
                                                    formatDate: 'EEE, dd-MM-yyyy',
                                                    predefinedDateFormat: 'yyyy-MM-dd',
                                                    defaultValue: '',
                                                  ),
                                                  fontsize: 11.5,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

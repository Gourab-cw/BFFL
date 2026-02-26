import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:moon_design/moon_design.dart';

import '../../../core/utility/daterangepicker.dart';
import '../controller/slot_details_controller.dart';
import '../controller/slot_details_register_controller.dart';

class SlotDetailsRegister extends StatefulWidget {
  const SlotDetailsRegister({super.key});

  @override
  State<SlotDetailsRegister> createState() => _SlotDetailsRegisterState();
}

class _SlotDetailsRegisterState extends State<SlotDetailsRegister> {
  final loader = Get.find<AppLoaderController>();
  final sc = Get.find<SubscriptionController>();
  final mainStore = Get.find<MainStore>();
  final slotTrainerController = Get.find<SlotDetailsTrainerController>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        loader.startLoading();
        await slotTrainerController.getSlots();
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
    return GetBuilder<SlotDetailsTrainerController>(
      init: slotTrainerController,
      autoRemove: false,
      builder: (slotTrainerController) {
        return GetBuilder<SubscriptionController>(
          init: sc,
          autoRemove: false,
          builder: (sc) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Register"),
                actions: [
                  DateRangePicker(
                    height: 40,
                    leadingIcon: Icon(Icons.calendar_month),
                    fontColor: mainStore.theme.value.BackgroundColor,
                    backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(100),
                    selectedDateRange: slotTrainerController.date,
                    onValueChange: (v) {
                      slotTrainerController.date = v;
                      slotTrainerController.update();
                    },
                  ),
                  ButtonHelperG(
                    onTap: () async {
                      try {
                        loader.startLoading();
                        await slotTrainerController.getSlots();
                      } catch (e) {
                        showAlert("$e", AlertType.error);
                      } finally {
                        loader.stopLoading();
                      }
                    },
                    shadow: [],
                    height: 40,
                    icon: Icon(Icons.refresh, color: Colors.white),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: slotTrainerController.slots.length,
                      itemBuilder: (ctx, index) {
                        final s = slotTrainerController.slots[index];
                        return Column(
                          children: [
                            if (index == 0 || (s.date != slotTrainerController.slots[index - 1].date))
                              Container(
                                margin: EdgeInsetsGeometry.all(5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(MoonIcons.time_calendar_24_light, size: 20),
                                    TextHelper(
                                      text: parseDateToString(data: s.date, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: ''),
                                      fontweight: FontWeight.w500,
                                      fontsize: 12,
                                      color: mainStore.theme.value.LightTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final slotCtrl = Get.find<SlotDetailsController>();
                                  slotCtrl.slot = s;
                                  loader.startLoading();
                                  await slotCtrl.getSlotDetails();
                                  Get.toNamed('/slotdetailstrainerview');
                                } catch (e) {
                                  showAlert("$e", AlertType.error);
                                } finally {
                                  loader.stopLoading();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(color: mainStore.theme.value.secondaryColor.withAlpha(20), borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        TextHelper(
                                          text: sc.getServiceById(s.serviceId)?.name ?? "",
                                          fontweight: FontWeight.w600,
                                          color: mainStore.theme.value.LightTextColor,
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextHelper(
                                              text: s.bookingCount.toString(),
                                              fontweight: FontWeight.w600,
                                              color: s.bookingCount > 0
                                                  ? mainStore.theme.value.secondaryColor
                                                  : mainStore.theme.value.LightTextColor.withAlpha(100),
                                            ),
                                            Icon(
                                              MoonIcons.generic_users_24_regular,
                                              size: 20,
                                              color: s.bookingCount > 0
                                                  ? mainStore.theme.value.secondaryColor
                                                  : mainStore.theme.value.LightTextColor.withAlpha(100),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(MoonIcons.time_clock_24_regular, size: 20),
                                        TextHelper(
                                          text: '${s.startTime} - ${s.endTime}',
                                          fontweight: FontWeight.w500,
                                          fontsize: 12,
                                          color: mainStore.theme.value.LightTextColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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

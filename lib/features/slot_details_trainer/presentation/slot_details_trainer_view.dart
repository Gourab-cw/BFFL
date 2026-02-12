import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/slot_details_trainer/controller/slot_details_controller.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

class SlotDetailsTrainerView extends StatefulWidget {
  const SlotDetailsTrainerView({super.key});

  @override
  State<SlotDetailsTrainerView> createState() => _SlotDetailsTrainerViewState();
}

class _SlotDetailsTrainerViewState extends State<SlotDetailsTrainerView> {
  final mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final sc = Get.find<SubscriptionController>();
  final slotController = Get.find<SlotDetailsController>();

  @override
  void dispose() {
    // TODO: implement dispose
    slotController.sessionListener?.pause();
    slotController.sessionListener?.cancel();
    slotController.sessions = [];
    slotController.slot = null;
    slotController.remarks.clear();
    slotController.feedbackCtrl.clear();
    slotController.selectedSession = null;
    slotController.update();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: GetBuilder<SlotDetailsController>(
        init: slotController,
        autoRemove: false,
        builder: (slotController) {
          final slot = slotController.slot;
          if (slot == null) {
            return Center(child: TextHelper(text: "Slot not found!"));
          }
          return Scaffold(
            appBar: AppBar(
              title: TextHelper(text: 'Session', fontsize: 16, fontweight: FontWeight.w600),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextHelper(text: sc.list.firstWhereOrNull((s) => s.id == slot.serviceId)?.name ?? "", fontweight: FontWeight.w600, fontsize: 14),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Icon(Icons.calendar_month, color: Colors.blueGrey.shade600, size: 16),
                                TextHelper(text: slot.date, width: 100, fontsize: 12, color: Colors.grey.shade900),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Icon(Icons.watch_later_outlined, color: Colors.blueGrey.shade600, size: 16),
                                TextHelper(text: "${slot.startTime} - ${slot.endTime}", width: 100, fontsize: 12, color: Colors.grey.shade900),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextAreaBox(
                          labelText: "Remarks",
                          controller: slotController.remarks,
                          height: 60,
                          borderRadius: BorderRadius.circular(10),
                          withBorder: false,
                        ),
                        const SizedBox(height: 10),
                        ButtonHelperG(
                          onTap: () async {
                            try {
                              loader.startLoading();
                              await slotController.endSessionAndSlot();
                            } catch (e) {
                              showAlert("$e", AlertType.error);
                            } finally {
                              loader.stopLoading();
                            }
                          },
                          label: TextHelper(text: "End Session", color: Colors.white),
                          width: MediaQuery.sizeOf(context).width * 0.9 > 400 ? 400 : MediaQuery.sizeOf(context).width * 0.9,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  TextHelper(text: "Members", fontweight: FontWeight.w600, fontsize: 15),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: slotController.sessions.map((s) {
                          return GestureDetector(
                            onTap: () {
                              if (slotController.selectedSession == null || slotController.selectedSession!.id != s.id) {
                                slotController.selectedSession = s;
                              } else {
                                slotController.selectedSession = null;
                              }

                              slotController.update();
                            },
                            child: Container(
                              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(4),
                              padding: EdgeInsets.all(4),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(MoonIcons.generic_user_24_regular, weight: 800),
                                          TextHelper(text: s.memberName ?? "", fontweight: FontWeight.w600),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        spacing: 10,
                                        children: [
                                          (s.hasAttend && s.attendedAt != null)
                                              ? TextHelper(text: DateFormat('hh:mm a').format(s.attendedAt!))
                                              : ButtonHelperG(
                                                  onTap: () async {
                                                    try {
                                                      loader.startLoading();
                                                      await slotController.markAttendance(s);
                                                    } catch (e) {
                                                      showAlert("$e", AlertType.error);
                                                    } finally {
                                                      loader.stopLoading();
                                                    }
                                                  },
                                                  margin: 0,
                                                  height: 30,
                                                  width: 140,
                                                  label: TextHelper(text: "Mark attendance", fontsize: 11, color: Colors.white),
                                                ),
                                          ButtonHelperG(
                                            margin: 0,
                                            height: 30,
                                            background: Colors.white,
                                            icon: Icon(Icons.info, size: 18, color: Colors.blueGrey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  if (slotController.selectedSession != null && slotController.selectedSession!.id == s.id) const SizedBox(height: 10),
                                  if (slotController.selectedSession != null && slotController.selectedSession!.id == s.id)
                                    Row(
                                      spacing: 4,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.subdirectory_arrow_right, size: 15, color: Colors.grey.shade500),
                                        ),
                                        Expanded(
                                          child: s.trainerFeedback.isNotEmpty
                                              ? TextHelper(text: s.trainerFeedback, color: Colors.blueGrey.shade500)
                                              : TextBox(
                                                  borderRadius: 10,
                                                  controller: slotController.feedbackCtrl,
                                                  withBorder: false,
                                                  autofocus: true,
                                                  labelText: "Feedback ",
                                                  trailing: ButtonHelperG(
                                                    onTap: () async {
                                                      try {
                                                        loader.startLoading();
                                                        await slotController.giveFeedback(s);
                                                      } catch (e) {
                                                        showAlert("$e", AlertType.error);
                                                      } finally {
                                                        loader.stopLoading();
                                                      }
                                                    },
                                                    margin: 4,
                                                    background: Colors.green.shade50,
                                                    icon: Icon(Icons.send_rounded, color: Colors.green, size: 18),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

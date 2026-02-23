import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/slot_details_trainer/controller/slot_details_controller.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

class SlotDetailsReceptionist extends StatefulWidget {
  const SlotDetailsReceptionist({super.key});

  @override
  State<SlotDetailsReceptionist> createState() => _SlotDetailsReceptionistState();
}

class _SlotDetailsReceptionistState extends State<SlotDetailsReceptionist> {
  final mainStore = Get.find<MainStore>();
  final slotDetailsController = Get.find<SlotDetailsController>();
  final sc = Get.find<SubscriptionController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose
    slotDetailsController.sessions = [];
    slotDetailsController.slot = null;
    Future(() async {
      if (slotDetailsController.sessionListener != null) {
        await slotDetailsController.sessionListener!.cancel();
        slotDetailsController.sessionListener = null;
      }
    });

    super.dispose();
  }

  Widget getServiceLogo(String serviceId) {
    ServiceModel? sv = sc.list.firstWhereOrNull((f) => f.id == serviceId);
    if (sv == null) {
      return Text('No service found!');
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: mainStore.theme.value.HeadColor.withAlpha(120), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(0.2),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(10),
            child: CachedNetworkImage(
              imageUrl: sv.image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) {
                return Icon(MoonIcons.generic_ticket_24_regular);
              },
            ),
          ),
        ),
        Positioned(
          bottom: -6,
          right: -8,
          child: Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 1),
            decoration: BoxDecoration(
              color: mainStore.theme.value.secondaryColor,
              borderRadius: BorderRadius.circular(4),
              // border: Border.all(color: mainStore.theme.value.HeadColor.withAlpha(120)),
            ),
            child: Row(
              spacing: 6,
              children: [TextHelper(text: "Done", fontsize: 11, fontweight: FontWeight.w600, color: mainStore.theme.value.BackgroundShadeColor)],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlotDetailsController>(
      autoRemove: false,
      init: slotDetailsController,
      builder: (slotDetailsController) {
        return Scaffold(
          appBar: AppBar(title: Text("Details")),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Column(
              spacing: 1,
              children: [
                Builder(
                  builder: (context) {
                    ServiceModel? s = sc.list.firstWhereOrNull((f) => f.id == slotDetailsController.slot!.serviceId);
                    if (s == null) {
                      return Text("No service found");
                    }
                    return Row(
                      spacing: 15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getServiceLogo(slotDetailsController.slot!.serviceId),
                        Expanded(
                          child: Column(
                            spacing: 1,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextHelper(text: s.name, fontsize: 18, fontweight: FontWeight.w700),
                              Column(
                                spacing: 3,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Icon(Icons.calendar_month, color: mainStore.theme.value.HeadColor.withAlpha(160), size: 16),
                                      TextHelper(
                                        color: mainStore.theme.value.HeadColor.withAlpha(200),
                                        fontweight: FontWeight.w600,
                                        fontsize: 12,
                                        text: parseDateToString(
                                          data: slotDetailsController.slot!.date,
                                          formatDate: 'EEE, dd-MM-yyyy',
                                          predefinedDateFormat: 'yyyy-MM-dd',
                                          defaultValue: '',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Icon(Icons.watch_later, color: mainStore.theme.value.HeadColor.withAlpha(160), size: 16),
                                      TextHelper(
                                        color: mainStore.theme.value.HeadColor.withAlpha(200),
                                        fontweight: FontWeight.w600,
                                        fontsize: 12,
                                        text: '${slotDetailsController.slot!.startTime} - ${slotDetailsController.slot!.endTime}',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 10,
                                    children: [
                                      Icon(FontAwesomeIcons.userDoctor, color: mainStore.theme.value.HeadColor.withAlpha(160), size: 16),
                                      TextHelper(
                                        color: mainStore.theme.value.HeadColor.withAlpha(200),
                                        fontweight: FontWeight.w600,
                                        text: slotDetailsController.slot!.trainerName ?? "",
                                        fontsize: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainStore.theme.value.lowShadeColor,
                        border: Border.all(color: mainStore.theme.value.mediumShadeColor),
                      ),
                      child: Column(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextHelper(text: 'Started At', fontsize: 11.5),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.watch_later_rounded, size: 15),
                              TextHelper(
                                text: slotDetailsController.slot!.trainerStartTime == null
                                    ? "__:__"
                                    : DateFormat('HH:mm').format(slotDetailsController.slot!.trainerStartTime!.toDate()),
                                textalign: TextAlign.right,
                                fontsize: 17,
                                fontweight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainStore.theme.value.lowShadeColor,
                        border: Border.all(color: mainStore.theme.value.mediumShadeColor),
                      ),
                      child: Column(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextHelper(text: 'Completed At', fontsize: 11.5),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.watch_later_rounded, size: 15),
                              TextHelper(
                                text: slotDetailsController.slot!.completeAt == null
                                    ? "__:__"
                                    : DateFormat('HH:mm').format(slotDetailsController.slot!.completeAt!.toDate()),
                                textalign: TextAlign.right,
                                fontsize: 17,
                                fontweight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [TextHelper(text: "Booking List", fontsize: 15, fontweight: FontWeight.w600)],
                ),
                Expanded(
                  child: Container(
                    color: mainStore.theme.value.lowShadeColor,
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: slotDetailsController.sessions.length,
                      itemBuilder: (_, index) {
                        final s = slotDetailsController.sessions[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: mainStore.theme.value.mediumShadeColor),
                          ),
                          child: Column(
                            spacing: 10,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  getNameIcon(s.memberName ?? "", color: mainStore.theme.value.mediumShadeColor),
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextHelper(text: s.memberName ?? "", fontweight: FontWeight.w600, fontsize: 13),
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6),
                                            decoration: BoxDecoration(
                                              color: s.hasAttend ? Colors.green.shade50 : Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              spacing: 3,
                                              children: [
                                                Icon(
                                                  s.hasAttend ? Icons.check_circle : Icons.close_rounded,
                                                  size: 11.5,
                                                  color: s.hasAttend ? Colors.green.shade700 : Colors.red,
                                                ),
                                                TextHelper(
                                                  text: s.hasAttend ? "Attended" : "Not Attended",
                                                  fontsize: 9.5,
                                                  color: s.hasAttend ? Colors.green.shade700 : Colors.red.shade400,
                                                  fontweight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          TextHelper(
                                            text: s.attendedAt == null ? '' : DateFormat('HH:mm a').format(s.attendedAt!),
                                            fontsize: 11,
                                            fontweight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border(left: BorderSide(color: mainStore.theme.value.HeadColor, width: 4)),
                                  borderRadius: BorderRadius.circular(7),
                                  color: mainStore.theme.value.BackgroundShadeColor,
                                ),
                                child: Column(
                                  spacing: 10,
                                  children: [
                                    TextHelper(
                                      text: "Feedback",
                                      fontweight: FontWeight.w600,
                                      fontsize: 11,
                                      color: mainStore.theme.value.HeadColor.withAlpha(180),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 28, child: Icon(MoonIcons.generic_user_24_regular, size: 20)),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            color: mainStore.theme.value.BackgroundColor,
                                            child: TextHelper(text: s.feedback, fontsize: 11, fontweight: FontWeight.w600, isWrap: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 28, child: Icon(FontAwesomeIcons.userDoctor, size: 16)),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(3),
                                            color: mainStore.theme.value.BackgroundColor,
                                            child: TextHelper(text: s.trainerFeedback, fontsize: 11, fontweight: FontWeight.w600, isWrap: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
          ),
        );
      },
    );
  }
}

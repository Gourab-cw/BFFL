import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:healthandwellness/features/home/controller/member_home_controller.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:intl/intl.dart';

import '../../Service/controller/service_controller.dart';
import '../../login/data/user.dart';

class MemberSessionDetails extends StatefulWidget {
  const MemberSessionDetails({super.key});

  @override
  State<MemberSessionDetails> createState() => _MemberSessionDetailsState();
}

class _MemberSessionDetailsState extends State<MemberSessionDetails> {
  final loader = Get.find<AppLoaderController>();
  final mainStore = Get.find<MainStore>();
  final auth = Get.find<Authenticator>();

  final serviceController = Get.find<ServiceController>();

  final mhc = Get.find<MemberHomeController>();

  final TextEditingController feedback = TextEditingController();

  bool hasSessionEnd() {
    final booking = mhc.selectedBooking;
    if (booking == null) {
      return false;
    }
    return parseInt(data: booking.endTime.replaceAll(':', ''), defaultInt: 0) <
        parseInt(data: DateFormat('HH:mm').format(DateTime.now()).replaceAll(':', ''), defaultInt: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberHomeController>(
      init: mhc,
      autoRemove: false,
      builder: (mhc) {
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Session Details"),
              actions: [
                if (mhc.selectedBooking != null && !mhc.selectedBooking!.hasAttend && hasSessionEnd() && auth.state!.userType == UserType.member)
                  ButtonHelperG(
                    width: 100,
                    onTap: () async {
                      try {
                        if (mhc.selectedBooking == null) {
                          return;
                        }
                        loader.startLoading();
                        serviceController.selectedReschedule = mhc.selectedBooking!;
                        serviceController.selectedMember = {"id": mhc.selectedBooking!.memberId, "name": mhc.selectedBooking!.memberName};
                        final fb = Get.find<FB>();
                        final db = await fb.getDB();
                        await serviceController.getServiceDetails(mhc.selectedBooking!.serviceId, auth.state!.branchId, isReschedule: true);
                        ServiceModel sv = ServiceModel.fromJson(
                          makeMapSerialize((await db.collection('Subscription').doc(mhc.selectedBooking!.serviceId).get()).data()),
                        );
                        serviceController.selectedService = sv;
                        if (!serviceController.services.any((s) => s.id == sv.id)) {
                          serviceController.services.add(sv);
                        }
                        List<String> trainers = serviceController.selectedService!.trainerId;
                        final resp1 = await db.collection("User").where('id', whereIn: trainers).get();
                        List<UserG> trainser_users = resp1.docs.map((m) => UserG.fromJSON(makeMapSerialize(m.data()))).toList();
                        for (var f in trainser_users) {
                          if (!serviceController.trainers.any((a) => a.id == f.id)) {
                            serviceController.trainers.add(f);
                          }
                        }
                        Get.toNamed('/servicedetailsview?isReschedule=1');
                      } catch (e) {
                        showAlert("$e", AlertType.error);
                      } finally {
                        loader.stopLoading();
                      }
                    },
                    shadow: [],
                    background: mainStore.theme.value.BackgroundColor,
                    // type: ButtonHelperTypeG.outlined,
                    label: TextHelper(text: "Reschedule"),
                  ),
              ],
            ),
            body: Builder(
              builder: (context) {
                final booking = mhc.selectedBooking;
                if (booking == null) {
                  return Center(child: TextHelper(text: "No session found!"));
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextHelper(text: booking.serviceName ?? "", fontweight: FontWeight.w600, fontsize: 16),
                          ),
                          if (hasSessionEnd() && auth.state!.userType == UserType.member)
                            Container(
                              decoration: BoxDecoration(color: mainStore.theme.value.HeadColor.withAlpha(100), borderRadius: BorderRadius.circular(4)),
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                              child: TextHelper(
                                text: booking.hasAttend ? 'Attended' : 'Not Attended',
                                fontsize: 11,
                                color: mainStore.theme.value.DarkTextColor,
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 10,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 2),
                                Icon(FontAwesomeIcons.ticket, size: 17, color: Colors.grey.shade600),
                                const SizedBox(width: 13),
                                TextHelper(text: booking.subscriptionNo ?? ''),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Icon(Icons.calendar_month, size: 21, color: Colors.grey.shade600),
                                TextHelper(
                                  text: parseDateToString(data: booking.date, formatDate: "dd-MM-yyyy", predefinedDateFormat: "yyyy-MM-dd", defaultValue: ""),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Icon(Icons.watch_later_outlined, size: 21, color: Colors.grey.shade600),
                                TextHelper(text: "${booking.startTime} - ${booking.endTime}"),
                              ],
                            ),
                            if (booking.completeAt != null)
                              Row(
                                spacing: 10,
                                children: [
                                  TextHelper(text: "Finished At: ", width: 90),
                                  TextHelper(text: DateFormat("dd-MM-yyyy hh:mm a").format(booking.completeAt!.toDate())),
                                ],
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Icon(FontAwesomeIcons.userDoctor, size: 21, color: Colors.grey.shade600),
                                    TextHelper(text: booking.trainerName ?? ""),
                                  ],
                                ),
                                if (booking.trainerFeedback != "")
                                  Container(
                                    margin: EdgeInsets.only(left: 28.0),
                                    decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      spacing: 3,
                                      children: [
                                        Icon(FontAwesomeIcons.message, size: 12),
                                        TextHelper(text: booking.trainerFeedback ?? "", fontweight: FontWeight.w600, fontsize: 12),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      if (booking.hasAttend)
                        Row(
                          children: [
                            TextHelper(text: "Attended at :", width: 90),
                            TextHelper(
                              text: booking.attendedAt == null ? "" : (DateFormat("dd-MM-yyyy hh:mm a").format(booking.attendedAt!)),
                              fontsize: 14,
                              fontweight: FontWeight.w600,
                            ),
                          ],
                        ),
                      Spacer(),

                      booking.feedback == "" && booking.hasAttend
                          ? Row(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextAreaBox(
                                    controller: feedback,
                                    labelText: "Feedback  ",
                                    showAlwaysLabel: true,
                                    height: 80,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                if (booking.hasAttend)
                                  ButtonHelperG(
                                    onTap: () async {
                                      try {
                                        loader.startLoading();
                                        await mhc.submitFeedback(booking, feedback.text);
                                      } catch (e) {
                                        showAlert("$e", AlertType.error);
                                      } finally {
                                        loader.stopLoading();
                                      }
                                    },
                                    background: Colors.green.shade100,
                                    margin: 0,
                                    icon: Icon(Icons.send, color: Colors.green),
                                  ),
                              ],
                            )
                          : TextAreaBox(
                              controller: TextEditingController(text: booking.feedback),
                              labelText: "Feedback",
                              readonly: true,
                              showAlwaysLabel: true,
                              height: 80,
                              borderRadius: BorderRadius.circular(10),
                            ),
                      const SizedBox(height: 20),
                      if (!booking.hasAttend && DateFormat('yyyy-MM-dd').format(DateTime.now()) == booking.date)
                        Opacity(
                          opacity: (auth.state!.userType == UserType.member && hasSessionEnd()) ? 0.4 : 1,
                          child: ButtonHelperG(
                            onTap: () async {
                              if (auth.state!.userType == UserType.member && hasSessionEnd()) {
                                showAlert('Session has ended', AlertType.error);
                                return;
                              }

                              try {
                                loader.startLoading();
                                await mhc.markAttendance(booking);
                              } catch (e) {
                                showAlert("$e", AlertType.error);
                              } finally {
                                loader.stopLoading();
                              }
                            },
                            width: 150,
                            label: TextHelper(text: "Mark as attend", color: Colors.white),
                          ),
                        ),
                      Spacer(),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

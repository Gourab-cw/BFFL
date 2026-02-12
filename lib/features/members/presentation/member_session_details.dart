import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/home/controller/member_home_controller.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:intl/intl.dart';

class MemberSessionDetails extends StatefulWidget {
  const MemberSessionDetails({super.key});

  @override
  State<MemberSessionDetails> createState() => _MemberSessionDetailsState();
}

class _MemberSessionDetailsState extends State<MemberSessionDetails> {
  final loader = Get.find<AppLoaderController>();
  final mainStore = Get.find<MainStore>();
  final auth = Get.find<Authenticator>();
  final mhc = Get.find<MemberHomeController>();

  final TextEditingController feedback = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberHomeController>(
      init: mhc,
      autoRemove: false,
      builder: (mhc) {
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(
              title: TextHelper(text: "Session Details", fontsize: 16, fontweight: FontWeight.w600),
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
                      TextHelper(text: booking.serviceName ?? "", fontweight: FontWeight.w600, fontsize: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 10,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                Icon(Icons.calendar_month, color: Colors.grey.shade600),
                                TextHelper(
                                  text: parseDateToString(data: booking.date, formatDate: "dd-MM-yyyy", predefinedDateFormat: "yyyy-MM-dd", defaultValue: ""),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Icon(Icons.watch_later_outlined, color: Colors.grey.shade600),
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
                                    Icon(FontAwesomeIcons.userDoctor, color: Colors.grey.shade600),
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
                            TextHelper(text: "Attend at :", width: 80),
                            TextHelper(text: booking.attendedAt == null ? "" : (DateFormat("dd-MM-yyyy hh:mm a").format(booking.attendedAt!)), fontsize: 15),
                          ],
                        ),
                      Spacer(),

                      booking.feedback == ""
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
                      if (!booking.hasAttend)
                        ButtonHelperG(
                          onTap: () async {
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

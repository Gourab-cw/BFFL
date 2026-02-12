import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/home/controller/member_home_controller.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';

import '../../login/repository/authenticator.dart';

class HomeMember extends StatefulWidget {
  const HomeMember({super.key});

  @override
  State<HomeMember> createState() => _HomeMemberState();
}

class _HomeMemberState extends State<HomeMember> {
  final MainStore mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final auth = Get.find<Authenticator>();
  final SubscriptionController subscriptionController = Get.find<SubscriptionController>();

  late final MemberHomeController homeController;
  final Authenticator user = Get.find<Authenticator>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);

  @override
  void initState() {
    // TODO: implement initState
    if (!Get.isRegistered<MemberHomeController>()) {
      Get.lazyPut(() => MemberHomeController(), fenix: true);
      // HomeController exists in memory
    }
    homeController = Get.find<MemberHomeController>();
    Future(() async {
      try {
        loader.startLoading();
        await homeController.getBookings();
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
    return GetBuilder<MemberHomeController>(
      init: homeController,
      autoRemove: false,
      builder: (homeController) {
        return GetBuilder<SubscriptionController>(
          init: subscriptionController,
          autoRemove: false,
          builder: (subscriptionController) {
            return Scaffold(
              body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.green.shade300, borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(4),
                            child: Icon(Icons.person_rounded, color: Colors.green.shade900, size: 24),
                          ),
                          TextHelper(text: "Hello, ${user.state?.name ?? ""}", fontsize: 15, fontweight: FontWeight.w600),
                        ],
                      ),
                      Row(
                        children: [
                          // if (auth.state != null && auth.state!.userType == UserType.member)
                          //   ButtonHelperG(
                          //     onTap: () {
                          //       Future(() async {
                          //         try {
                          //           loader.startLoading();
                          //           await homeController.getBookings();
                          //         } catch (e) {
                          //           showAlert("$e", AlertType.error);
                          //         } finally {
                          //           loader.stopLoading();
                          //         }
                          //       });
                          //     },
                          //     background: Colors.transparent,
                          //     icon: Icon(Icons.refresh),
                          //   ),
                          ButtonHelperG(background: Colors.transparent, icon: Icon(Icons.notifications)),
                        ],
                      ),
                    ],
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            TextHelper(text: "Today's booking,", fontweight: FontWeight.w600, fontsize: 14, color: Colors.blueGrey.shade800),
                            homeController.getTodaysBooking() == null
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextHelper(text: "No booking found!", color: Colors.grey.shade500, textalign: TextAlign.center),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          try {
                                            // final slotCtrl = Get.find<SlotDetailsController>();
                                            // slotCtrl.slot = m;
                                            // loader.startLoading();
                                            // await slotCtrl.getSlotDetails();
                                            homeController.selectedBooking = homeController.getTodaysBooking();
                                            Get.toNamed('/membersessiondetails');
                                          } catch (e) {
                                            showAlert("$e", AlertType.error);
                                          } finally {
                                            loader.stopLoading();
                                          }
                                        },
                                        child: Builder(
                                          builder: (context) {
                                            final m = homeController.getTodaysBooking();
                                            if (m == null) {
                                              return SizedBox();
                                            }
                                            return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.symmetric(horizontal: 5),
                                              child: Container(
                                                // margin: EdgeInsets.all(10),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.green.shade50),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ConstrainedBox(
                                                      constraints: BoxConstraints(maxWidth: 100),
                                                      child: TextHelper(
                                                        text: subscriptionController.list.firstWhereOrNull((s) => s.id == m.serviceId)?.name ?? "",
                                                        isWrap: true,
                                                        color: Colors.blueGrey.shade800,
                                                        fontweight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      spacing: 5,
                                                      children: [
                                                        Icon(Icons.watch_later_outlined, size: 17, color: Colors.blueGrey.shade500),
                                                        TextHelper(
                                                          text: "${m.startTime} - ${m.endTime}",
                                                          width: 80,
                                                          fontsize: 12,
                                                          color: Colors.blueGrey.shade400,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      spacing: 5,
                                                      children: [
                                                        Icon(Icons.calendar_month_rounded, size: 17, color: Colors.blueGrey.shade500),
                                                        TextHelper(text: "${m.date}", width: 80, fontsize: 12, color: Colors.blueGrey.shade400),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                            const SizedBox(height: 20),
                            TextHelper(text: "Upcoming booking,", fontweight: FontWeight.w600, fontsize: 14, color: Colors.blueGrey.shade800),
                            if (homeController.getUpcomingBooking().isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextHelper(text: "No booking found!", color: Colors.grey.shade500, textalign: TextAlign.center),
                              ),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: homeController.getUpcomingBooking().length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  final m = homeController.getUpcomingBooking()[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      try {
                                        // final slotCtrl = Get.find<SlotDetailsController>();
                                        // slotCtrl.slot = m;
                                        // loader.startLoading();
                                        // await slotCtrl.getSlotDetails();
                                        homeController.selectedBooking = m;
                                        Get.toNamed('/membersessiondetails');
                                      } catch (e) {
                                        showAlert("$e", AlertType.error);
                                      } finally {
                                        loader.stopLoading();
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                        // margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.green.shade50),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextHelper(
                                              text: subscriptionController.list.firstWhereOrNull((s) => s.id == m.serviceId)?.name ?? "",
                                              isWrap: true,
                                              color: Colors.blueGrey.shade800,
                                              fontweight: FontWeight.w600,
                                            ),
                                            Row(
                                              spacing: 5,
                                              children: [
                                                Icon(Icons.watch_later_outlined, size: 17, color: Colors.blueGrey.shade500),
                                                TextHelper(text: "${m.startTime} - ${m.endTime}", width: 80, fontsize: 12, color: Colors.blueGrey.shade400),
                                              ],
                                            ),
                                            Row(
                                              spacing: 5,
                                              children: [
                                                Icon(Icons.calendar_month_rounded, size: 17, color: Colors.blueGrey.shade500),
                                                TextHelper(text: "${m.date}", width: 80, fontsize: 12, color: Colors.blueGrey.shade400),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Button Row
                          ],
                        ),
                      ),
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

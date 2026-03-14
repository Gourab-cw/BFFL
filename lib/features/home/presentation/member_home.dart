import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/home/controller/member_home_controller.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';
import 'package:moon_design/moon_design.dart';

import '../../Service/data/session_model.dart';
import '../../login/repository/authenticator.dart';
import 'admin_sub_ui/admin_dashboard_card.dart';

class HomeMember extends StatefulWidget {
  const HomeMember({super.key});

  @override
  State<HomeMember> createState() => _HomeMemberState();
}

class _HomeMemberState extends State<HomeMember> {
  final MainStore mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final auth = Get.find<Authenticator>();
  final fb = Get.find<FB>();

  late Future<int> _getDashboardDataActiveSubs;
  late Future<int> _getDashboardDataTotalBooking;
  final SubscriptionController subscriptionController = Get.find<SubscriptionController>();

  late final MemberHomeController homeController;
  final Authenticator user = Get.find<Authenticator>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);

  double leftPadding = 30;
  Timer? timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 650), (v) {
      if (leftPadding == 20) {
        setState(() {
          leftPadding = 24;
        });
      } else {
        setState(() {
          leftPadding = 20;
        });
      }
    });

    // TODO: implement initState
    if (!Get.isRegistered<MemberHomeController>()) {
      Get.lazyPut(() => MemberHomeController(), fenix: true);
      // HomeController exists in memory
    }
    homeController = Get.find<MemberHomeController>();
    setState(() {
      _getDashboardDataActiveSubs = homeController.getActiveSubscriptionCount();
      _getDashboardDataTotalBooking = homeController.getTotalBookingCount();
    });
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
  void dispose() {
    // TODO: implement dispose
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
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
                          ButtonHelperG(
                            onTap: () async {
                              try {
                                loader.startLoading();
                                await homeController.getBookings();
                                setState(() {
                                  _getDashboardDataActiveSubs = homeController.getActiveSubscriptionCount();
                                  _getDashboardDataTotalBooking = homeController.getTotalBookingCount();
                                });
                              } catch (e) {
                                showAlert("$e", AlertType.error);
                              } finally {
                                loader.stopLoading();
                              }
                            },
                            background: Colors.transparent,
                            icon: Icon(Icons.refresh),
                          ),
                          ButtonHelperG(background: Colors.transparent, icon: Icon(Icons.notifications)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            children: [
                              FutureBuilder(
                                future: _getDashboardDataActiveSubs,
                                builder: (context, asyncSnapshot) {
                                  bool waiting = false;
                                  String content = '';
                                  if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                    waiting = true;
                                  } else {
                                    waiting = false;
                                  }
                                  if (asyncSnapshot.hasError) {
                                    showAlert('${asyncSnapshot.error}', AlertType.error);
                                    content = '';
                                  } else {
                                    content = parseString(data: asyncSnapshot.data, defaultValue: '0');
                                  }
                                  return AdminDashboardCard(
                                    onTap: () {
                                      // Get.toNamed('/memberlist');
                                    },
                                    icon: Icon(MoonIcons.generic_bookmark_24_regular),
                                    enabled: waiting,
                                    iconBgColor: mainStore.theme.value.HeadColor.withAlpha(30),
                                    title: 'Active Subscription',
                                    content: content,
                                  );
                                },
                              ),
                              FutureBuilder(
                                future: _getDashboardDataTotalBooking,
                                builder: (context, asyncSnapshot) {
                                  bool waiting = false;
                                  String content = '';
                                  if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                    waiting = true;
                                  } else {
                                    waiting = false;
                                  }
                                  if (asyncSnapshot.hasError) {
                                    showAlert('${asyncSnapshot.error}', AlertType.error);
                                    content = '';
                                  } else {
                                    content = parseString(data: asyncSnapshot.data, defaultValue: '0');
                                  }
                                  return AdminDashboardCard(
                                    onTap: () {
                                      // Get.toNamed('/memberlist');
                                    },
                                    icon: Icon(MoonIcons.files_draft_24_regular),
                                    enabled: waiting,
                                    iconBgColor: mainStore.theme.value.HeadColor.withAlpha(30),
                                    title: 'Total Booking',
                                    content: content,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      ButtonHelperG(
                        onTap: () {
                          Get.toNamed('/serviceview');
                        },
                        width: 300,
                        label: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            TextHelper(text: 'Book a slot now', color: mainStore.theme.value.DarkTextColor),
                            AnimatedPositioned(
                              curve: Curves.fastEaseInToSlowEaseOut,
                              duration: Duration(milliseconds: 600),
                              left: leftPadding + 90,
                              top: 14,
                              child: Icon(Icons.double_arrow, size: 15, color: mainStore.theme.value.DarkTextColor),
                            ),
                          ],
                        ),
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
                            homeController.getTodaysBooking().isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextHelper(text: "No booking found!", color: Colors.grey.shade500, textalign: TextAlign.center),
                                  )
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        ...homeController.getTodaysBooking().map((m) {
                                          return GestureDetector(
                                            onTap: () async {
                                              try {
                                                Loader.startLoading();
                                                final db = await fb.getDB();
                                                final resp = await db.collection('userSubscription').doc(m.subscriptionId).get();
                                                if (resp.exists) {
                                                  SessionModel m1 = m.copyWith(subscriptionNo: UserSubscription.fromJSON(makeMapSerialize(resp.data())).name);
                                                  homeController.selectedBooking = m1;
                                                  Get.toNamed('/membersessiondetails');
                                                } else {
                                                  showAlert("No subscription found!", AlertType.error);
                                                }
                                              } catch (e) {
                                                showAlert("$e", AlertType.error);
                                              } finally {
                                                Loader.stopLoading();
                                              }
                                            },
                                            child: Builder(
                                              builder: (context) {
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
                                          );
                                        }),
                                      ],
                                    ),
                                  ),

                            const SizedBox(height: 20),
                            TextHelper(text: "Upcoming booking,", fontweight: FontWeight.w600, fontsize: 14, color: Colors.blueGrey.shade800),
                            if (homeController.getUpcomingBooking().isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextHelper(text: "No booking found!", color: Colors.grey.shade500, textalign: TextAlign.center),
                              ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: homeController.getUpcomingBooking().length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, index) {
                                  final m = homeController.getUpcomingBooking()[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      try {
                                        Loader.startLoading();
                                        final db = await fb.getDB();
                                        final resp = await db.collection('userSubscription').doc(m.subscriptionId).get();
                                        if (resp.exists) {
                                          SessionModel m1 = m.copyWith(subscriptionNo: UserSubscription.fromJSON(makeMapSerialize(resp.data())).name);
                                          homeController.selectedBooking = m1;
                                          Get.toNamed('/membersessiondetails');
                                        } else {
                                          showAlert("No subscription found!", AlertType.error);
                                        }
                                      } catch (e) {
                                        showAlert("$e", AlertType.error);
                                      } finally {
                                        Loader.stopLoading();
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
                                            const SizedBox(height: 8),
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
                                                TextHelper(
                                                  text: parseDateToString(
                                                    data: m.date,
                                                    formatDate: 'dd-MM-yyyy',
                                                    predefinedDateFormat: 'yyyy-MM-dd',
                                                    defaultValue: '',
                                                  ),
                                                  width: 80,
                                                  fontsize: 12,
                                                  color: Colors.blueGrey.shade400,
                                                ),
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

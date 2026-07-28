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
  final SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();

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
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  // Modern Header Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    mainStore.theme.value.HeadColor,
                                    mainStore.theme.value.HeadColor.withAlpha(
                                      180,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person_rounded,
                                  color: Colors.blueGrey,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextHelper(
                                  text: "Hello, ${user.state?.name ?? ""}",
                                  fontsize: 15,
                                  fontweight: FontWeight.w700,
                                  color: Colors.blueGrey.shade900,
                                  padding: EdgeInsets.zero,
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainStore.theme.value.HeadColor
                                        .withAlpha(20),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextHelper(
                                    text: "Member Portal",
                                    fontsize: 11,
                                    fontweight: FontWeight.w600,
                                    color: mainStore.theme.value.HeadColor,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ButtonHelperG(
                              onTap: () async {
                                try {
                                  loader.startLoading();
                                  await homeController.getBookings();
                                  setState(() {
                                    _getDashboardDataActiveSubs = homeController
                                        .getActiveSubscriptionCount();
                                    _getDashboardDataTotalBooking =
                                        homeController.getTotalBookingCount();
                                  });
                                } catch (e) {
                                  showAlert("$e", AlertType.error);
                                } finally {
                                  loader.stopLoading();
                                }
                              },
                              background: Colors.grey.shade100,
                              width: 38,
                              height: 38,
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: Colors.blueGrey.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 6),
                            ButtonHelperG(
                              background: Colors.grey.shade100,
                              width: 38,
                              height: 38,
                              icon: Icon(
                                Icons.notifications_rounded,
                                color: Colors.blueGrey.shade700,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Dashboard Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stat Cards Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: [
                                  FutureBuilder(
                                    future: _getDashboardDataActiveSubs,
                                    builder: (context, asyncSnapshot) {
                                      bool waiting =
                                          asyncSnapshot.connectionState ==
                                          ConnectionState.waiting;
                                      String content = '';
                                      if (asyncSnapshot.hasError) {
                                        showAlert(
                                          '${asyncSnapshot.error}',
                                          AlertType.error,
                                        );
                                        content = '0';
                                      } else {
                                        content = parseString(
                                          data: asyncSnapshot.data,
                                          defaultValue: '0',
                                        );
                                      }
                                      return AdminDashboardCard(
                                        onTap: () {},
                                        icon: Icon(
                                          MoonIcons.generic_bookmark_24_regular,
                                          color:
                                              mainStore.theme.value.HeadColor,
                                        ),
                                        enabled: waiting,
                                        iconBgColor: mainStore
                                            .theme
                                            .value
                                            .HeadColor
                                            .withAlpha(30),
                                        title: 'Active Subscription',
                                        content: content,
                                      );
                                    },
                                  ),
                                  FutureBuilder(
                                    future: _getDashboardDataTotalBooking,
                                    builder: (context, asyncSnapshot) {
                                      bool waiting =
                                          asyncSnapshot.connectionState ==
                                          ConnectionState.waiting;
                                      String content = '';
                                      if (asyncSnapshot.hasError) {
                                        showAlert(
                                          '${asyncSnapshot.error}',
                                          AlertType.error,
                                        );
                                        content = '0';
                                      } else {
                                        content = parseString(
                                          data: asyncSnapshot.data,
                                          defaultValue: '0',
                                        );
                                      }
                                      return AdminDashboardCard(
                                        onTap: () {},
                                        icon: Icon(
                                          MoonIcons.files_draft_24_regular,
                                          color:
                                              mainStore.theme.value.HeadColor,
                                        ),
                                        enabled: waiting,
                                        iconBgColor: mainStore
                                            .theme
                                            .value
                                            .HeadColor
                                            .withAlpha(30),
                                        title: 'Total Booking',
                                        content: content,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Book Slot Hero Button
                          Center(
                            child: ButtonHelperG(
                              onTap: () => Get.toNamed('/serviceview'),
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              height: 50,
                              label: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.bolt_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      TextHelper(
                                        text: 'Book a Slot Now',
                                        color: Colors.white,
                                        fontweight: FontWeight.w700,
                                        fontsize: 15,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
                                  AnimatedPositioned(
                                    curve: Curves.fastEaseInToSlowEaseOut,
                                    duration: const Duration(milliseconds: 600),
                                    right: 20 - (leftPadding - 20),
                                    child: const Icon(
                                      Icons.double_arrow_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Today's Bookings Section
                          Row(
                            children: [
                              Icon(
                                Icons.today_rounded,
                                size: 18,
                                color: mainStore.theme.value.HeadColor,
                              ),
                              const SizedBox(width: 6),
                              TextHelper(
                                text: "Today's Bookings",
                                fontweight: FontWeight.w700,
                                fontsize: 15,
                                color: Colors.blueGrey.shade900,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          homeController.getTodaysBooking().isEmpty
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: TextHelper(
                                    text: "No bookings scheduled for today",
                                    color: Colors.grey.shade500,
                                    fontsize: 13,
                                  ),
                                )
                              : SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: homeController
                                        .getTodaysBooking()
                                        .length,
                                    itemBuilder: (ctx, index) {
                                      final m = homeController
                                          .getTodaysBooking()[index];
                                      return GestureDetector(
                                        onTap: () async {
                                          try {
                                            Loader.startLoading();
                                            final db = await fb.getDB();
                                            final resp = await db
                                                .collection('userSubscription')
                                                .doc(m.subscriptionId)
                                                .get();
                                            if (resp.exists) {
                                              SessionModel m1 = m.copyWith(
                                                subscriptionNo:
                                                    UserSubscription.fromJSON(
                                                      makeMapSerialize(
                                                        resp.data(),
                                                      ),
                                                    ).name,
                                              );
                                              homeController.selectedBooking =
                                                  m1;
                                              Get.toNamed(
                                                '/membersessiondetails',
                                              );
                                            } else {
                                              showAlert(
                                                "No subscription found!",
                                                AlertType.error,
                                              );
                                            }
                                          } catch (e) {
                                            showAlert("$e", AlertType.error);
                                          } finally {
                                            Loader.stopLoading();
                                          }
                                        },
                                        child: Container(
                                          width: 175,
                                          margin: const EdgeInsets.only(
                                            right: 12,
                                            top: 4,
                                            bottom: 4,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                  8,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextHelper(
                                                text:
                                                    subscriptionController.list
                                                        .firstWhereOrNull(
                                                          (s) =>
                                                              s.id ==
                                                              m.serviceId,
                                                        )
                                                        ?.name ??
                                                    "Service",
                                                isWrap: true,
                                                color: Colors.blueGrey.shade900,
                                                fontweight: FontWeight.w700,
                                                fontsize: 13,
                                                padding: EdgeInsets.zero,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        size: 14,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade400,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      TextHelper(
                                                        text:
                                                            "${m.startTime} - ${m.endTime}",
                                                        fontsize: 11,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade600,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_today_rounded,
                                                        size: 13,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade400,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      TextHelper(
                                                        text: "${m.date}",
                                                        fontsize: 11,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade600,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          const SizedBox(height: 22),

                          // Upcoming Bookings Section
                          Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                size: 18,
                                color: mainStore.theme.value.HeadColor,
                              ),
                              const SizedBox(width: 6),
                              TextHelper(
                                text: "Upcoming Bookings",
                                fontweight: FontWeight.w700,
                                fontsize: 15,
                                color: Colors.blueGrey.shade900,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          homeController.getUpcomingBooking().isEmpty
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: TextHelper(
                                    text: "No upcoming bookings found",
                                    color: Colors.grey.shade500,
                                    fontsize: 13,
                                  ),
                                )
                              : SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: homeController
                                        .getUpcomingBooking()
                                        .length,
                                    itemBuilder: (ctx, index) {
                                      final m = homeController
                                          .getUpcomingBooking()[index];
                                      return GestureDetector(
                                        onTap: () async {
                                          try {
                                            Loader.startLoading();
                                            final db = await fb.getDB();
                                            final resp = await db
                                                .collection('userSubscription')
                                                .doc(m.subscriptionId)
                                                .get();
                                            if (resp.exists) {
                                              SessionModel m1 = m.copyWith(
                                                subscriptionNo:
                                                    UserSubscription.fromJSON(
                                                      makeMapSerialize(
                                                        resp.data(),
                                                      ),
                                                    ).name,
                                              );
                                              homeController.selectedBooking =
                                                  m1;
                                              Get.toNamed(
                                                '/membersessiondetails',
                                              );
                                            } else {
                                              showAlert(
                                                "No subscription found!",
                                                AlertType.error,
                                              );
                                            }
                                          } catch (e) {
                                            showAlert("$e", AlertType.error);
                                          } finally {
                                            Loader.stopLoading();
                                          }
                                        },
                                        child: Container(
                                          width: 175,
                                          margin: const EdgeInsets.only(
                                            right: 12,
                                            top: 4,
                                            bottom: 4,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                  8,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextHelper(
                                                text:
                                                    subscriptionController.list
                                                        .firstWhereOrNull(
                                                          (s) =>
                                                              s.id ==
                                                              m.serviceId,
                                                        )
                                                        ?.name ??
                                                    "Service",
                                                isWrap: true,
                                                color: Colors.blueGrey.shade900,
                                                fontweight: FontWeight.w700,
                                                fontsize: 13,
                                                padding: EdgeInsets.zero,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .access_time_rounded,
                                                        size: 14,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade400,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      TextHelper(
                                                        text:
                                                            "${m.startTime} - ${m.endTime}",
                                                        fontsize: 11,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade600,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .calendar_today_rounded,
                                                        size: 13,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade400,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      TextHelper(
                                                        text: parseDateToString(
                                                          data: m.date,
                                                          formatDate:
                                                              'dd-MM-yyyy',
                                                          predefinedDateFormat:
                                                              'yyyy-MM-dd',
                                                          defaultValue: '',
                                                        ),
                                                        fontsize: 11,
                                                        color: Colors
                                                            .blueGrey
                                                            .shade600,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          const SizedBox(height: 16),
                        ],
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

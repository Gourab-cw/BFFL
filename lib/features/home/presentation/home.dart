import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:moon_design/moon_design.dart';

import '../../login/data/user.dart';
import '../../login/repository/authenticator.dart';
import '../../slot_details_trainer/controller/slot_details_controller.dart';
import '../controller/home_controller.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MainStore mainStore = Get.find<MainStore>();
  final SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();
  final SlotDetailsController slotDetailsController =
      Get.find<SlotDetailsController>();

  late final HomeController homeController;
  final Authenticator user = Get.find<Authenticator>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);

  String getStatus(SlotModel s) {
    if (s.trainerStartTime == null) {
      return 'Not started';
    }
    if (s.trainerStartTime != null && s.completeAt == null) {
      return 'Ongoing';
    }
    if (s.trainerStartTime != null && s.completeAt != null) {
      return 'Completed';
    }
    return 'Completed';
  }

  @override
  void initState() {
    // TODO: implement initState
    if (!Get.isRegistered<HomeController>()) {
      Get.lazyPut(() => HomeController(), fenix: true);
      // HomeController exists in memory
    }
    homeController = Get.find<HomeController>();
    Future(() async {
      await homeController.fetchTodayBooking();
      await homeController.getUpcomingBookings();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: mainStore,
      autoRemove: false,
      builder: (mainStore) {
        return GetBuilder<HomeController>(
          init: homeController,
          autoRemove: false,
          builder: (homeController) {
            final auth = Get.find<Authenticator>();
            return GetBuilder<SubscriptionController>(
              init: subscriptionController,
              autoRemove: false,
              builder: (subscriptionController) {
                return AppLoader(
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Unboxed Top User Header Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: mainStore
                                          .theme
                                          .value
                                          .HeadColor
                                          .withAlpha(25),
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: mainStore.theme.value.HeadColor,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextHelper(
                                          text:
                                              "Hello, ${user.state?.name ?? ""}",
                                          fontsize: 16,
                                          fontweight: FontWeight.w700,
                                          color: Colors.blueGrey.shade900,
                                          padding: EdgeInsets.zero,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              size: 13,
                                              color: mainStore
                                                  .theme
                                                  .value
                                                  .HeadColor,
                                            ),
                                            const SizedBox(width: 2),
                                            TextHelper(
                                              text: user.branch?.name ?? "",
                                              fontsize: 11,
                                              fontweight: FontWeight.w600,
                                              color: Colors.blueGrey.shade600,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                ButtonHelperG(
                                  onTap: () => Get.toNamed('/memberlist'),
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
                          ),
                          const SizedBox(height: 16),

                          // Main Scrollable Dashboard Content
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Categorized Quick Action Tile Cards
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Category 1: Member Operations
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.people_alt_rounded,
                                            size: 16,
                                            color:
                                                mainStore.theme.value.HeadColor,
                                          ),
                                          const SizedBox(width: 6),
                                          TextHelper(
                                            text: "Member Management",
                                            fontsize: 13,
                                            fontweight: FontWeight.w700,
                                            color: Colors.blueGrey.shade800,
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: [
                                          // Primary Add Member Tile Card
                                          InkWell(
                                            onTap: () =>
                                                Get.toNamed("/useradd"),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    mainStore
                                                        .theme
                                                        .value
                                                        .HeadColor,
                                                    mainStore
                                                        .theme
                                                        .value
                                                        .HeadColor
                                                        .withAlpha(210),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: mainStore
                                                        .theme
                                                        .value
                                                        .HeadColor
                                                        .withAlpha(60),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withAlpha(45),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: const Icon(
                                                      MoonIcons
                                                          .generic_user_24_regular,
                                                      size: 18,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  TextHelper(
                                                    text: "Add Member +",
                                                    fontsize: 13,
                                                    fontweight: FontWeight.w700,
                                                    color: Colors.white,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Member List Tile Card
                                          InkWell(
                                            onTap: () =>
                                                Get.toNamed('/memberlist'),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.purple.shade100,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(6),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.purple.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      MoonIcons
                                                          .generic_users_24_regular,
                                                      size: 18,
                                                      color: Colors
                                                          .purple
                                                          .shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  TextHelper(
                                                    text: "Member List",
                                                    fontsize: 13,
                                                    fontweight: FontWeight.w700,
                                                    color: Colors
                                                        .blueGrey
                                                        .shade900,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Book a Service Tile Card
                                          InkWell(
                                            onTap: () =>
                                                Get.toNamed('/serviceview'),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.blue.shade100,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(6),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.blue.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      MoonIcons
                                                          .generic_ticket_24_regular,
                                                      size: 18,
                                                      color:
                                                          Colors.blue.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  TextHelper(
                                                    text: "Book a Service",
                                                    fontsize: 13,
                                                    fontweight: FontWeight.w700,
                                                    color: Colors
                                                        .blueGrey
                                                        .shade900,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 18),

                                      // Category 2: Financial & Billing
                                      Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .account_balance_wallet_rounded,
                                            size: 16,
                                            color:
                                                mainStore.theme.value.HeadColor,
                                          ),
                                          const SizedBox(width: 6),
                                          TextHelper(
                                            text: "Billing & Accounts",
                                            fontsize: 13,
                                            fontweight: FontWeight.w700,
                                            color: Colors.blueGrey.shade800,
                                            padding: EdgeInsets.zero,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 12,
                                        runSpacing: 12,
                                        children: [
                                          // Pay Bills Tile Card
                                          InkWell(
                                            onTap: () => Get.toNamed(
                                              '/accsubscriptionlist',
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.green.shade100,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(6),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.green.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      MoonIcons
                                                          .travel_bill_24_regular,
                                                      size: 18,
                                                      color:
                                                          Colors.green.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  TextHelper(
                                                    text: "Pay Bills",
                                                    fontsize: 13,
                                                    fontweight: FontWeight.w700,
                                                    color: Colors
                                                        .blueGrey
                                                        .shade900,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Bill Register Tile Card
                                          InkWell(
                                            onTap: () => Get.toNamed(
                                              '/accountantHistory',
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: Colors.teal.shade100,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(6),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.teal.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      MoonIcons
                                                          .travel_bill_24_regular,
                                                      size: 18,
                                                      color:
                                                          Colors.teal.shade700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  TextHelper(
                                                    text: "Bill Register",
                                                    fontsize: 13,
                                                    fontweight: FontWeight.w700,
                                                    color: Colors
                                                        .blueGrey
                                                        .shade900,
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      if (auth.state != null &&
                                          (auth.state!.userType ==
                                                  UserType.admin ||
                                              auth.state!.userType ==
                                                  UserType.branchManager)) ...[
                                        const SizedBox(height: 18),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.event_note_rounded,
                                              size: 16,
                                              color: mainStore
                                                  .theme
                                                  .value
                                                  .HeadColor,
                                            ),
                                            const SizedBox(width: 6),
                                            TextHelper(
                                              text: "Schedule & Slots",
                                              fontsize: 13,
                                              fontweight: FontWeight.w700,
                                              color: Colors.blueGrey.shade800,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Wrap(
                                          spacing: 12,
                                          runSpacing: 12,
                                          children: [
                                            // Slot Manage Tile Card
                                            InkWell(
                                              onTap: () =>
                                                  Get.toNamed('/slotmanage'),
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 12,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  border: Border.all(
                                                    color:
                                                        Colors.orange.shade100,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(6),
                                                      blurRadius: 8,
                                                      offset: const Offset(
                                                        0,
                                                        2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .orange
                                                            .shade50,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                      child: Icon(
                                                        MoonIcons
                                                            .time_calendar_24_regular,
                                                        size: 18,
                                                        color: Colors
                                                            .orange
                                                            .shade700,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    TextHelper(
                                                      text: "Slot Manage",
                                                      fontsize: 13,
                                                      fontweight:
                                                          FontWeight.w700,
                                                      color: Colors
                                                          .blueGrey
                                                          .shade900,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 22),

                                  // Upcoming Slots Section
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_rounded,
                                            size: 18,
                                            color:
                                                mainStore.theme.value.HeadColor,
                                          ),
                                          const SizedBox(width: 6),
                                          TextHelper(
                                            text: "Upcoming Slots",
                                            fontweight: FontWeight.w700,
                                            fontsize: 15,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                        ],
                                      ),
                                      ButtonHelperG(
                                        onTap: () =>
                                            Get.toNamed('/slotregister'),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 10,
                                        ),
                                        label: TextHelper(
                                          text: 'View More',
                                          fontsize: 11,
                                          color: Colors.white,
                                          fontweight: FontWeight.w600,
                                        ),
                                        height: 28,
                                        width: 85,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 115,
                                    child: homeController.bookings.isEmpty
                                        ? Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: TextHelper(
                                              text:
                                                  "No upcoming slots scheduled",
                                              color: Colors.grey.shade500,
                                              fontsize: 13,
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount:
                                                homeController.bookings.length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (ctx, index) {
                                              final m = homeController
                                                  .bookings[index];
                                              final statusText = getStatus(m);
                                              final isCompleted = statusText
                                                  .toLowerCase()
                                                  .contains('complete');
                                              final isOngoing = statusText
                                                  .toLowerCase()
                                                  .contains('ongoing');
                                              return GestureDetector(
                                                onTap: () async {
                                                  try {
                                                    Loader.startLoading();
                                                    await slotDetailsController
                                                        .getSlotDetails(
                                                          selectedSlot: m,
                                                        );
                                                    Get.toNamed(
                                                      '/slotdetailsreceptionist',
                                                    );
                                                  } catch (e) {
                                                    showAlert(
                                                      "$e",
                                                      AlertType.error,
                                                    );
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
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade200,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withAlpha(8),
                                                        blurRadius: 8,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              10,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            TextHelper(
                                                              text:
                                                                  subscriptionController
                                                                      .list
                                                                      .firstWhereOrNull(
                                                                        (s) =>
                                                                            s.id ==
                                                                            m.serviceId,
                                                                      )
                                                                      ?.name ??
                                                                  "Slot",
                                                              isWrap: true,
                                                              color: Colors
                                                                  .blueGrey
                                                                  .shade900,
                                                              fontweight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontsize: 13,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
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
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                TextHelper(
                                                                  text:
                                                                      "${m.startTime} - ${m.endTime}",
                                                                  fontsize: 11,
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade600,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
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
                                                                const SizedBox(
                                                                  width: 4,
                                                                ),
                                                                TextHelper(
                                                                  text: parseDateToString(
                                                                    data:
                                                                        m.date,
                                                                    formatDate:
                                                                        'dd-MM-yyyy',
                                                                    predefinedDateFormat:
                                                                        'yyyy-MM-dd',
                                                                    defaultValue:
                                                                        '',
                                                                  ),
                                                                  fontsize: 11,
                                                                  color: Colors
                                                                      .blueGrey
                                                                      .shade600,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 4,
                                                              horizontal: 10,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: isCompleted
                                                              ? Colors
                                                                    .green
                                                                    .shade50
                                                              : isOngoing
                                                              ? Colors
                                                                    .orange
                                                                    .shade50
                                                              : Colors
                                                                    .blue
                                                                    .shade50,
                                                          borderRadius:
                                                              const BorderRadius.only(
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                      13,
                                                                    ),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                      13,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: TextHelper(
                                                          text: statusText,
                                                          fontsize: 11,
                                                          fontweight:
                                                              FontWeight.w600,
                                                          color: isCompleted
                                                              ? Colors
                                                                    .green
                                                                    .shade700
                                                              : isOngoing
                                                              ? Colors
                                                                    .orange
                                                                    .shade800
                                                              : Colors
                                                                    .blue
                                                                    .shade700,
                                                          padding:
                                                              EdgeInsets.zero,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Today's Booking Section & Analytics
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(8),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: mainStore
                                                    .theme
                                                    .value
                                                    .HeadColor
                                                    .withAlpha(20),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Image(
                                                image: const AssetImage(
                                                  "assets/booking.png",
                                                ),
                                                color: mainStore
                                                    .theme
                                                    .value
                                                    .HeadColor,
                                                width: 18,
                                                height: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            TextHelper(
                                              text: "Today's Booking Analytics",
                                              fontweight: FontWeight.w700,
                                              fontsize: 14,
                                              color: Colors.blueGrey.shade900,
                                            ),
                                          ],
                                        ),
                                        const Divider(height: 20),
                                        SizedBox(
                                          height: 150,
                                          child: AreaChartHelper(
                                            customTooltip: (d) {
                                              return Container(
                                                color: Colors.white,
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .watch_later_outlined,
                                                          size: 18,
                                                        ),
                                                        TextHelper(
                                                          text: d.x,
                                                          width: 40,
                                                          fontweight:
                                                              FontWeight.w600,
                                                          textalign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 60,
                                                      child: Divider(),
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      spacing: 5,
                                                      children: [
                                                        Image(
                                                          image: const AssetImage(
                                                            "assets/booking.png",
                                                          ),
                                                          color: Colors
                                                              .blueGrey
                                                              .shade700,
                                                          width: 18,
                                                          height: 20,
                                                        ),
                                                        TextHelper(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          text: parseInt(
                                                            data: d.y,
                                                            defaultInt: 0,
                                                          ).toString(),
                                                          fontweight:
                                                              FontWeight.w600,
                                                          textalign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            tooltipColor: mainStore
                                                .theme
                                                .value
                                                .mediumShadeColor,
                                            borderColor: mainStore
                                                .theme
                                                .value
                                                .mediumShadeColor,
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              colors: [
                                                mainStore
                                                    .theme
                                                    .value
                                                    .lowShadeColor,
                                                mainStore
                                                    .theme
                                                    .value
                                                    .lowShadeColor,
                                              ],
                                            ),
                                            showBorder: false,
                                            showYAxis: true,
                                            dataSource: homeController
                                                .getHourlyBooking(),
                                            chartTitle: "Hourly Booking",
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: homeController.getTodaysBooking().map<Widget>((
                                            m,
                                          ) {
                                            return Obx(
                                              () => Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 8,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          homeController
                                                                  .selectedIndex
                                                                  .value ==
                                                              m.id
                                                          ? mainStore
                                                                .theme
                                                                .value
                                                                .HeadColor
                                                                .withAlpha(15)
                                                          : Colors.grey.shade50,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            homeController
                                                                    .selectedIndex
                                                                    .value ==
                                                                m.id
                                                            ? mainStore
                                                                  .theme
                                                                  .value
                                                                  .HeadColor
                                                                  .withAlpha(80)
                                                            : Colors
                                                                  .grey
                                                                  .shade200,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                MoonIcons
                                                                    .generic_ticket_24_regular,
                                                                size: 20,
                                                                color:
                                                                    homeController
                                                                            .selectedIndex
                                                                            .value ==
                                                                        m.id
                                                                    ? mainStore
                                                                          .theme
                                                                          .value
                                                                          .HeadColor
                                                                    : Colors
                                                                          .grey
                                                                          .shade700,
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: TextHelper(
                                                                  text: m
                                                                      .serviceName,
                                                                  fontweight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontsize: 13,
                                                                  color:
                                                                      homeController
                                                                              .selectedIndex
                                                                              .value ==
                                                                          m.id
                                                                      ? mainStore
                                                                            .theme
                                                                            .value
                                                                            .HeadColor
                                                                      : Colors
                                                                            .grey
                                                                            .shade900,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .blueGrey
                                                                .shade100,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                          ),
                                                          child: TextHelper(
                                                            text: m.totalBooked
                                                                .toString(),
                                                            fontsize: 12,
                                                            fontweight:
                                                                FontWeight.w700,
                                                            color: Colors
                                                                .blueGrey
                                                                .shade900,
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        ButtonHelperG(
                                                          onTap: () {
                                                            if (homeController
                                                                    .selectedIndex
                                                                    .value ==
                                                                m.id) {
                                                              homeController
                                                                      .selectedIndex
                                                                      .value =
                                                                  -1;
                                                            } else {
                                                              homeController
                                                                  .selectedIndex
                                                                  .value = m
                                                                  .id;
                                                            }
                                                          },
                                                          height: 32,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          margin: 0,
                                                          background: Colors
                                                              .transparent,
                                                          icon: Icon(
                                                            homeController
                                                                        .selectedIndex
                                                                        .value ==
                                                                    m.id
                                                                ? Icons
                                                                      .arrow_drop_up
                                                                : Icons
                                                                      .arrow_drop_down,
                                                            color: Colors
                                                                .blueGrey
                                                                .shade800,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (homeController
                                                          .selectedIndex
                                                          .value ==
                                                      m.id)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            top: 6,
                                                            bottom: 8,
                                                          ),
                                                      child: ConstrainedBox(
                                                        constraints:
                                                            const BoxConstraints(
                                                              maxHeight: 200,
                                                            ),
                                                        child: DataGridHelper3(
                                                          fontSize: 12,
                                                          rowHeight: 28,
                                                          headerColor: Colors
                                                              .grey
                                                              .shade100,
                                                          dataSource: m.slots
                                                              .map(
                                                                (m) =>
                                                                    m.toJSON(),
                                                              )
                                                              .toList(),
                                                          columnList: [
                                                            DataGridColumnModel3(
                                                              dataField: "slot",
                                                              title: "Time",
                                                              customCell: (c) {
                                                                return GestureDetector(
                                                                  onTap: () async {
                                                                    try {
                                                                      Loader.startLoading();
                                                                      final fb =
                                                                          Get.find<
                                                                            FB
                                                                          >();
                                                                      final db =
                                                                          await fb
                                                                              .getDB();
                                                                      final resp = await db
                                                                          .collection(
                                                                            'slots',
                                                                          )
                                                                          .doc(
                                                                            c.rowValue['slotId'],
                                                                          )
                                                                          .get();
                                                                      if (!resp
                                                                          .exists) {
                                                                        throw Exception(
                                                                          'No slot data found!',
                                                                        );
                                                                      }
                                                                      await slotDetailsController.getSlotDetails(
                                                                        selectedSlot:
                                                                            SlotModel.fromFirestore(
                                                                              resp,
                                                                            ),
                                                                      );
                                                                      Get.toNamed(
                                                                        '/slotdetailsreceptionist',
                                                                      );
                                                                    } catch (
                                                                      e
                                                                    ) {
                                                                      showAlert(
                                                                        "$e",
                                                                        AlertType
                                                                            .error,
                                                                      );
                                                                    } finally {
                                                                      Loader.stopLoading();
                                                                    }
                                                                  },
                                                                  child: TextHelper(
                                                                    text: c
                                                                        .cellValue,
                                                                    textalign:
                                                                        TextAlign
                                                                            .center,
                                                                    fontsize:
                                                                        12,
                                                                  ),
                                                                );
                                                              },
                                                              dataType:
                                                                  CellDataType3
                                                                      .string,
                                                            ),
                                                            DataGridColumnModel3(
                                                              dataField:
                                                                  "booked",
                                                              title: 'Booked',
                                                              dataType:
                                                                  CellDataType3
                                                                      .string,
                                                            ),
                                                            DataGridColumnModel3(
                                                              dataField:
                                                                  "totalAttendance",
                                                              title:
                                                                  'Attendance',
                                                              dataType:
                                                                  CellDataType3
                                                                      .string,
                                                            ),
                                                          ],
                                                          uniqueKey: UniqueKey()
                                                              .toString(),
                                                          width:
                                                              MediaQuery.sizeOf(
                                                                context,
                                                              ).width *
                                                              0.8,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

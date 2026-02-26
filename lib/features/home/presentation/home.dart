import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/Theme/theme.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/slot_manage/data/slot_making_model.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:moon_design/moon_design.dart';

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
  final SubscriptionController subscriptionController = Get.find<SubscriptionController>();
  final SlotDetailsController slotDetailsController = Get.find<SlotDetailsController>();

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
            return GetBuilder<SubscriptionController>(
              init: subscriptionController,
              autoRemove: false,
              builder: (subscriptionController) {
                return AppLoader(
                  child: Scaffold(
                    body: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    mainStore.theme.value = BergerTheme.themes[1];
                                    mainStore.update();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(color: mainStore.theme.value.HeadColor, borderRadius: BorderRadius.circular(40)),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(Icons.person_rounded, color: mainStore.theme.value.lowShadeColor.withAlpha(200), size: 24),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextHelper(text: "Hello, ${user.state?.name ?? ""}", fontsize: 14, fontweight: FontWeight.w600),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, size: 13, color: mainStore.theme.value.HeadColor),
                                        TextHelper(text: user.branch?.name ?? "", fontsize: 12, fontweight: FontWeight.w500),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ButtonHelperG(background: Colors.transparent, icon: Icon(Icons.search)),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                Wrap(
                                  children: [
                                    ButtonHelperG(
                                      onTap: () {
                                        Get.toNamed("/useradd");
                                      },
                                      height: 45,
                                      icon: Icon(MoonIcons.generic_user_24_regular, color: Colors.white, size: 28),
                                      label: TextHelper(text: "Add Member +", fontsize: 14, color: Colors.white, fontweight: FontWeight.w600),
                                      width: 150,
                                      // background: Colors.green.shade500,
                                    ),
                                    ButtonHelperG(
                                      withBorder: true,
                                      height: 45,
                                      type: ButtonHelperTypeG.outlined,
                                      icon: Icon(MoonIcons.generic_ticket_24_regular, color: mainStore.theme.value.HeadColor, size: 28),
                                      label: TextHelper(
                                        text: "Book a service",
                                        fontsize: 14,
                                        color: mainStore.theme.value.HeadColor,
                                        fontweight: FontWeight.w600,
                                      ),
                                      width: 150,
                                      background: mainStore.theme.value.secondaryColor.withAlpha(50),
                                    ),
                                    ButtonHelperG(
                                      onTap: () {
                                        Get.toNamed('/memberlist');
                                      },
                                      withBorder: true,
                                      height: 45,
                                      type: ButtonHelperTypeG.outlined,
                                      icon: Icon(MoonIcons.generic_users_24_regular, color: mainStore.theme.value.HeadColor, size: 28),
                                      label: TextHelper(text: "Member List", fontsize: 14, color: mainStore.theme.value.HeadColor, fontweight: FontWeight.w600),
                                      width: 150,
                                      background: mainStore.theme.value.secondaryColor.withAlpha(50),
                                    ),
                                    ButtonHelperG(
                                      onTap: () {
                                        Get.toNamed('/slotmanage');
                                      },
                                      withBorder: true,
                                      height: 45,
                                      type: ButtonHelperTypeG.outlined,
                                      icon: Icon(MoonIcons.generic_users_24_regular, color: mainStore.theme.value.HeadColor, size: 28),
                                      label: TextHelper(text: "Slot Manage", fontsize: 14, color: mainStore.theme.value.HeadColor, fontweight: FontWeight.w600),
                                      width: 150,
                                      background: mainStore.theme.value.secondaryColor.withAlpha(50),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextHelper(text: "Upcoming slots,", fontweight: FontWeight.w600, fontsize: 14),
                                    ButtonHelperG(
                                      onTap: () {
                                        Get.toNamed('/slotregister');
                                      },
                                      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                      label: TextHelper(text: 'View More', fontsize: 12, color: mainStore.theme.value.BackgroundColor),
                                      height: 26,
                                      width: 100,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 110,
                                  child: ListView.builder(
                                    itemCount: homeController.bookings.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (ctx, index) {
                                      final m = homeController.bookings[index];
                                      return GestureDetector(
                                        onTap: () async {
                                          try {
                                            Loader.startLoading();
                                            await slotDetailsController.getSlotDetails(selectedSlot: m);
                                            Get.toNamed('/slotdetailsreceptionist');
                                          } catch (e) {
                                            showAlert("$e", AlertType.error);
                                          } finally {
                                            Loader.stopLoading();
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: mainStore.theme.value.mediumShadeColor.withAlpha(50),
                                            border: Border.all(color: Colors.green.shade50),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
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
                                                        Icon(Icons.watch_later_outlined, size: 17, color: mainStore.theme.value.LightTextColor.withAlpha(150)),
                                                        TextHelper(
                                                          text: "${m.startTime} - ${m.endTime}",
                                                          width: 80,
                                                          fontsize: 12,
                                                          color: mainStore.theme.value.LightTextColor,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      spacing: 5,
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_month_rounded,
                                                          size: 17,
                                                          color: mainStore.theme.value.LightTextColor.withAlpha(150),
                                                        ),
                                                        TextHelper(
                                                          text: parseDateToString(
                                                            data: m.date,
                                                            formatDate: 'dd-MM-yyyy',
                                                            predefinedDateFormat: 'yyyy-MM-dd',
                                                            defaultValue: '',
                                                          ),
                                                          width: 80,
                                                          fontsize: 12,
                                                          color: mainStore.theme.value.LightTextColor,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                width: double.maxFinite,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: mainStore.theme.value.HeadColor.withAlpha(
                                                      getStatus(m).toLowerCase().contains('complete')
                                                          ? 140
                                                          : getStatus(m).toLowerCase().contains('ongoing')
                                                          ? 0
                                                          : 70,
                                                    ),
                                                  ),
                                                  child: TextHelper(
                                                    text: getStatus(m),
                                                    fontsize: 11.5,
                                                    padding: EdgeInsets.only(left: 10),
                                                    color: getStatus(m).toLowerCase().contains('ongoing')
                                                        ? mainStore.theme.value.HeadColor.withAlpha(200)
                                                        : mainStore.theme.value.BackgroundColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Container(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(color: mainStore.theme.value.secondaryColor.withAlpha(70)),
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              spacing: 5,
                                              children: [
                                                Image(image: AssetImage("assets/booking.png"), color: mainStore.theme.value.HeadColor, width: 20, height: 20),
                                                TextHelper(text: "Today's Booking", fontweight: FontWeight.w600),
                                              ],
                                            ),
                                            Divider(),
                                            SizedBox(
                                              height: 150,
                                              child: AreaChartHelper(
                                                // borderDrawMode: BorderDrawMode.top,
                                                customTooltip: (d) {
                                                  return Container(
                                                    color: Colors.white,
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(Icons.watch_later_outlined, size: 18),
                                                            TextHelper(text: d.x, width: 40, fontweight: FontWeight.w600, textalign: TextAlign.center),
                                                          ],
                                                        ),
                                                        SizedBox(width: 60, child: Divider()),
                                                        Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          spacing: 5,
                                                          children: [
                                                            Image(
                                                              image: AssetImage("assets/booking.png"),
                                                              color: Colors.blueGrey.shade700,
                                                              width: 18,
                                                              height: 20,
                                                            ),
                                                            TextHelper(
                                                              padding: EdgeInsets.zero,
                                                              text: parseInt(data: d.y, defaultInt: 0).toString(),

                                                              fontweight: FontWeight.w600,
                                                              textalign: TextAlign.center,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                // isHorizontal: false,
                                                tooltipColor: mainStore.theme.value.mediumShadeColor,
                                                borderColor: mainStore.theme.value.mediumShadeColor,
                                                gradient: LinearGradient(
                                                  begin: AlignmentGeometry.bottomCenter,
                                                  colors: [mainStore.theme.value.lowShadeColor, mainStore.theme.value.lowShadeColor],
                                                ),
                                                showBorder: false,
                                                showYAxis: true,
                                                dataSource: homeController.getHourlyBooking(),
                                                chartTitle: "Hourly Booking",
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: homeController.getTodaysBooking().map<Widget>((m) {
                                                  return Obx(
                                                    () => Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                spacing: 5,
                                                                children: [
                                                                  Icon(
                                                                    MoonIcons.generic_ticket_24_regular,
                                                                    color: homeController.selectedIndex.value == m.id
                                                                        ? mainStore.theme.value.HeadColor
                                                                        : Colors.grey.shade700,
                                                                  ),
                                                                  Expanded(
                                                                    child: TextHelper(
                                                                      text: m.serviceName,
                                                                      fontweight: FontWeight.w500,
                                                                      color: homeController.selectedIndex.value == m.id
                                                                          ? mainStore.theme.value.HeadColor
                                                                          : Colors.grey.shade900,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            TextHelper(
                                                              text: m.totalBooked.toString(),
                                                              fontsize: 14,
                                                              fontweight: FontWeight.w500,
                                                              color: homeController.selectedIndex.value == m.id
                                                                  ? mainStore.theme.value.HeadColor
                                                                  : Colors.grey.shade900,
                                                            ),
                                                            ButtonHelperG(
                                                              onTap: () {
                                                                if (homeController.selectedIndex.value == m.id) {
                                                                  homeController.selectedIndex.value = -1;
                                                                } else {
                                                                  homeController.selectedIndex.value = m.id;
                                                                }
                                                              },
                                                              height: 35,
                                                              padding: EdgeInsets.zero,
                                                              margin: 0,
                                                              background: Colors.transparent,
                                                              icon: Icon(
                                                                homeController.selectedIndex.value == m.id ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (homeController.selectedIndex.value == m.id)
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints(maxHeight: 200),
                                                            child: DataGridHelper3(
                                                              fontSize: 12,
                                                              rowHeight: 25,
                                                              headerColor: Colors.transparent,
                                                              // headerFontSize: 11,
                                                              dataSource: m.slots.map((m) => m.toJSON()).toList(),
                                                              columnList: [
                                                                DataGridColumnModel3(
                                                                  dataField: "slot",
                                                                  title: "Time",
                                                                  customCell: (c) {
                                                                    return GestureDetector(
                                                                      onTap: () async {
                                                                        try {
                                                                          Loader.startLoading();
                                                                          final fb = Get.find<FB>();
                                                                          final db = await fb.getDB();
                                                                          final resp = await db.collection('slots').doc(c.rowValue['slotId']).get();
                                                                          if (!resp.exists) {
                                                                            throw Exception('No slot data found!');
                                                                          }
                                                                          await slotDetailsController.getSlotDetails(
                                                                            selectedSlot: SlotModel.fromFirestore(resp),
                                                                          );
                                                                          Get.toNamed('/slotdetailsreceptionist');
                                                                        } catch (e) {
                                                                          showAlert("$e", AlertType.error);
                                                                        } finally {
                                                                          Loader.stopLoading();
                                                                        }
                                                                      },
                                                                      child: TextHelper(text: c.cellValue, textalign: TextAlign.center, fontsize: 12),
                                                                    );
                                                                  },
                                                                  dataType: CellDataType3.string,
                                                                ),
                                                                DataGridColumnModel3(dataField: "booked", title: 'Booked', dataType: CellDataType3.string),
                                                                DataGridColumnModel3(
                                                                  dataField: "totalAttendance",
                                                                  title: 'Attendance',
                                                                  dataType: CellDataType3.string,
                                                                ),
                                                              ],
                                                              uniqueKey: UniqueKey().toString(),
                                                              width: MediaQuery.sizeOf(context).width * 0.8,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Button Row
                              ],
                            ),
                          ),
                        ),
                      ],
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

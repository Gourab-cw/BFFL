import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/slot_details_trainer/controller/slot_details_controller.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:moon_design/moon_design.dart';

import '../../login/data/user.dart';
import '../../login/repository/authenticator.dart';
import '../controller/home_controller.dart';

class HomeTrainer extends StatefulWidget {
  const HomeTrainer({super.key});

  @override
  State<HomeTrainer> createState() => _HomeTrainerState();
}

class _HomeTrainerState extends State<HomeTrainer> {
  final MainStore mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final auth = Get.find<Authenticator>();
  final SubscriptionController subscriptionController = Get.find<SubscriptionController>();

  late final HomeController homeController;
  final Authenticator user = Get.find<Authenticator>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);

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
      await homeController.init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            Container(
                              decoration: BoxDecoration(color: Colors.green.shade300, borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(4),
                              child: Icon(Icons.person_rounded, color: Colors.green.shade900, size: 24),
                            ),
                            TextHelper(text: "Hello, ${user.state?.name ?? ""}", fontsize: 15, fontweight: FontWeight.w600),
                          ],
                        ),
                        ButtonHelperG(background: Colors.transparent, icon: Icon(Icons.notifications)),
                      ],
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            if (auth.state != null && auth.state!.userType == UserType.receptionist)
                              Wrap(
                                children: [
                                  ButtonHelperG(
                                    onTap: () {
                                      // homeController.init();
                                      // return;
                                      Get.toNamed("/useradd");
                                    },
                                    height: 45,
                                    icon: Icon(MoonIcons.generic_user_24_regular, color: Colors.white, size: 28),
                                    label: TextHelper(text: "Add Member +", fontsize: 14, color: Colors.white, fontweight: FontWeight.w600),
                                    width: 150,
                                    background: Colors.green.shade500,
                                  ),
                                  ButtonHelperG(
                                    withBorder: true,
                                    height: 45,
                                    type: ButtonHelperTypeG.outlined,
                                    icon: Icon(MoonIcons.generic_ticket_24_regular, color: Colors.green.shade900, size: 28),
                                    label: TextHelper(text: "Book a service", fontsize: 14, color: Colors.green.shade900, fontweight: FontWeight.w600),
                                    width: 150,
                                    background: Colors.lightGreenAccent.shade700,
                                  ),
                                  ButtonHelperG(
                                    onTap: () {
                                      Get.toNamed('/memberlist');
                                    },
                                    withBorder: true,
                                    height: 45,
                                    type: ButtonHelperTypeG.outlined,
                                    icon: Icon(MoonIcons.generic_users_24_regular, color: Colors.green.shade900, size: 28),
                                    label: TextHelper(text: "Member List", fontsize: 14, color: Colors.green.shade900, fontweight: FontWeight.w600),
                                    width: 150,
                                    background: Colors.lightGreenAccent.shade700,
                                  ),
                                  ButtonHelperG(
                                    onTap: () {
                                      Get.toNamed('/slotmanage');
                                    },
                                    withBorder: true,
                                    height: 45,
                                    type: ButtonHelperTypeG.outlined,
                                    icon: Icon(MoonIcons.generic_users_24_regular, color: Colors.green.shade900, size: 28),
                                    label: TextHelper(text: "Slot Manage", fontsize: 14, color: Colors.green.shade900, fontweight: FontWeight.w600),
                                    width: 150,
                                    background: Colors.lightGreenAccent.shade700,
                                  ),
                                ],
                              ),
                            // const SizedBox(height: 30),
                            TextHelper(text: "Upcoming slots,", fontweight: FontWeight.w600, fontsize: 14, color: Colors.blueGrey.shade800),
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
                                        final slotCtrl = Get.find<SlotDetailsController>();
                                        slotCtrl.slot = m;
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
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: 5),
                                      child: Badge(
                                        backgroundColor: Colors.blueGrey,
                                        isLabelVisible: m.bookingCount > 0,
                                        label: Text(m.bookingCount.toString()),
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
                                      border: Border.all(color: Colors.green.shade50),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          spacing: 5,
                                          children: [
                                            Image(image: AssetImage("assets/booking.png"), color: Colors.blueGrey.shade700, width: 20, height: 20),
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
                                                        Image(image: AssetImage("assets/booking.png"), color: Colors.blueGrey.shade700, width: 18, height: 20),
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
                                            tooltipColor: Colors.green.shade300,
                                            borderColor: Colors.green.shade300,
                                            gradient: LinearGradient(
                                              begin: AlignmentGeometry.bottomCenter,
                                              colors: [Colors.green.shade50, Colors.green.shade50],
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
                                                                color: homeController.selectedIndex.value == m.id ? Colors.green : Colors.grey.shade700,
                                                              ),
                                                              Expanded(
                                                                child: TextHelper(
                                                                  text: m.serviceName,
                                                                  fontweight: FontWeight.w500,
                                                                  color: homeController.selectedIndex.value == m.id ? Colors.green : Colors.grey.shade900,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        TextHelper(
                                                          text: m.totalBooked.toString(),
                                                          fontsize: 14,
                                                          fontweight: FontWeight.w500,
                                                          color: homeController.selectedIndex.value == m.id ? Colors.green : Colors.grey.shade900,
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
                                                          icon: Icon(homeController.selectedIndex.value == m.id ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                                        ),
                                                      ],
                                                    ),
                                                    if (homeController.selectedIndex.value == m.id)
                                                      ConstrainedBox(
                                                        constraints: BoxConstraints(maxHeight: 200),
                                                        child: DataGridHelper3(
                                                          fontSize: 11,
                                                          rowHeight: 25,
                                                          headerColor: Colors.transparent,
                                                          // headerFontSize: 11,
                                                          dataSource: m.slots.map((m) => m.toJSON()).toList(),
                                                          columnList: [
                                                            DataGridColumnModel3(dataField: "slot", dataType: CellDataType3.string),
                                                            DataGridColumnModel3(dataField: "booked", dataType: CellDataType3.string),
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
  }
}

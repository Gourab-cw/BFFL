import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/home/controller/admin_home_controller.dart';
import 'package:healthandwellness/features/home/presentation/admin_sub_ui/admin_dashboard_card.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_register/controller/slot_register_controller.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final mainStore = Get.find<MainStore>();
  final auth = Get.find<Authenticator>();
  final adminHomeController = Get.find<AdminHomeController>();
  final slotRegisterController = Get.find<SlotRegisterController>();
  late Future<int> _getDashboardData;
  late Future<int> _getDashboardDataActiveSubs;
  late Future<int> _getDashboardDataTodaySession;
  late Future<int> _getDashboardDataBookingCount;
  late Future<int> _getDashboardDataServiceCount;
  late Future<List<ChartData>> _getDashboardDataSessionGraph;

  void settingFetchingService() {
    setState(() {
      _getDashboardData = adminHomeController.getDashboardData();
      _getDashboardDataActiveSubs = adminHomeController.getDashboardDataActiveSubs();
      _getDashboardDataTodaySession = adminHomeController.getDashboardDataTodaySession();
      _getDashboardDataSessionGraph = adminHomeController.getDashboardDataSessionGraph();
      _getDashboardDataBookingCount = adminHomeController.getDashboardDataBookingCount();
      _getDashboardDataServiceCount = adminHomeController.getDashboardDataServiceCount();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    settingFetchingService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (auth.state == null) {
      return Center(child: Text("Not Authenticate"));
    }
    return GetBuilder<AdminHomeController>(
      init: adminHomeController,
      autoRemove: false,
      builder: (adminHomeController) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHelper(text: 'Overview', fontsize: 11, color: mainStore.theme.value.HeadColor.withAlpha(250)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [TextHelper(text: 'Welcome, ${auth.state!.name}', fontweight: FontWeight.w600, fontsize: 16)],
                        ),
                      ],
                    ),
                    ButtonHelperG(
                      onTap: () {
                        settingFetchingService();
                      },
                      width: 30,
                      height: 30,
                      background: mainStore.theme.value.mediumShadeColor,
                      icon: Icon(Icons.refresh, size: 18),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Wrap(
                          runSpacing: 0,
                          spacing: 35,
                          runAlignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: [
                            FutureBuilder(
                              future: _getDashboardData,
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
                                  content = 'Error';
                                } else {
                                  content = parseString(data: asyncSnapshot.data, defaultValue: '0');
                                }
                                return AdminDashboardCard(
                                  onTap: () {
                                    Get.toNamed('/memberlist');
                                  },
                                  icon: Icon(MoonIcons.generic_users_24_regular),
                                  enabled: waiting,
                                  iconBgColor: Colors.purple.shade50,
                                  title: 'Total Members',
                                  content: content,
                                );
                              },
                            ),
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
                                  content = 'Error';
                                } else {
                                  content = parseString(data: asyncSnapshot.data, defaultValue: '0');
                                }
                                return AdminDashboardCard(
                                  icon: Icon(FontAwesomeIcons.certificate, size: 12, color: Colors.blue.shade600),
                                  enabled: waiting,
                                  iconBgColor: Colors.blue.shade50,
                                  title: 'Active Subs',
                                  content: content,
                                );
                              },
                            ),
                            FutureBuilder(
                              future: _getDashboardDataTodaySession,
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
                                  content = 'Error';
                                } else {
                                  content = parseString(data: asyncSnapshot.data, defaultValue: '0');
                                }
                                return AdminDashboardCard(
                                  onTap: () {
                                    Get.toNamed('/dailyschedule');
                                  },
                                  icon: Icon(FontAwesomeIcons.calendarPlus, size: 16, color: Colors.orange.shade600),
                                  enabled: waiting,
                                  iconBgColor: Colors.orange.shade50,
                                  title: "Today's Session",
                                  content: content,
                                );
                              },
                            ),
                            FutureBuilder(
                              future: _getDashboardDataServiceCount,
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
                                  content = 'Error';
                                } else {
                                  content = parseString(data: asyncSnapshot.data, defaultValue: '0');
                                }
                                return AdminDashboardCard(
                                  onTap: () {
                                    Get.toNamed('/memberlist');
                                  },
                                  icon: Icon(FontAwesomeIcons.ticket, size: 16, color: Colors.blueAccent.shade700),
                                  enabled: waiting,
                                  iconBgColor: Colors.blueAccent.shade100.withAlpha(50),
                                  title: "Total Service",
                                  content: content,
                                );
                              },
                            ),
                            FutureBuilder(
                              future: _getDashboardDataBookingCount,
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
                                  content = 'Error';
                                } else {
                                  content = parseString(data: asyncSnapshot.data, defaultValue: '0');
                                }
                                return AdminDashboardCard(
                                  onTap: () {
                                    slotRegisterController.selectedDate = adminHomeController.dashboardDate;
                                    Get.toNamed('/slotregister');
                                  },
                                  icon: Icon(FontAwesomeIcons.calendarPlus, size: 16, color: Colors.pink.shade600),
                                  enabled: waiting,
                                  iconBgColor: Colors.pink.shade50,
                                  title: "Booking Count",
                                  content: content,
                                  extra: FutureBuilder(
                                    future: _getDashboardDataSessionGraph,
                                    builder: (context, asyncSnapshot) {
                                      List<ChartData> data = [];
                                      bool waiting = false;
                                      if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                        waiting = true;
                                      } else {
                                        waiting = false;
                                      }
                                      if (asyncSnapshot.hasError) {
                                        showAlert('${asyncSnapshot.error}', AlertType.error);
                                      } else if (asyncSnapshot.data != null) {
                                        data = asyncSnapshot.data!;
                                      }
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          ButtonHelperG(
                                            onTap: () async {
                                              await showDatePickerHelper(
                                                context: context,
                                                onValueChange: (date) {
                                                  adminHomeController.dashboardDate = date;
                                                  adminHomeController.update();
                                                  setState(() {
                                                    _getDashboardDataBookingCount = adminHomeController.getDashboardDataBookingCount();
                                                    _getDashboardDataSessionGraph = adminHomeController.getDashboardDataSessionGraph();
                                                  });
                                                },
                                                selectedDateRange: adminHomeController.dashboardDate,
                                              );
                                            },
                                            label: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextHelper(
                                                  text: adminHomeController.dashboardDate.start == adminHomeController.dashboardDate.end
                                                      ? DateFormat('dd-MM-yy').format(adminHomeController.dashboardDate.start)
                                                      : '${DateFormat('dd-MM-yy').format(adminHomeController.dashboardDate.start)} - ${DateFormat('dd-MM-yy').format(adminHomeController.dashboardDate.end)}',
                                                  fontsize: 10,
                                                  width: 115,
                                                  padding: EdgeInsets.zero,
                                                  textalign: TextAlign.right,
                                                  isWrap: true,
                                                ),
                                                Icon(MoonIcons.time_calendar_24_regular, color: Colors.pink.shade700, size: 20),
                                              ],
                                            ),
                                            margin: 0,
                                            width: 135,
                                            padding: EdgeInsets.zero,
                                            height: 25,
                                            background: Colors.transparent,
                                          ),
                                          SizedBox(
                                            width: 120,
                                            height: 50,
                                            child: ClipRRect(
                                              child: Skeletonizer(
                                                enabled: waiting,
                                                child: AreaChartHelper(
                                                  borderColor: Colors.pink.shade300,
                                                  borderDrawMode: BorderDrawMode.top,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [Colors.pink.shade50, Colors.white],
                                                  ),
                                                  dataSource: data,
                                                  enableTooltip: false,
                                                  chartTitle: '',
                                                  showToolTip: false,
                                                  showBorder: false,
                                                  showXAxis: false,
                                                  showYAxis: false,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            FutureBuilder(
                              future: _getDashboardDataBookingCount,
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
                                  content = 'Error';
                                } else {
                                  content = currenyFormater(value: asyncSnapshot.data, withDrCr: false);
                                }
                                return AdminDashboardCard(
                                  icon: Icon(FontAwesomeIcons.moneyBill1, size: 16, color: Colors.green.shade600),
                                  enabled: waiting,
                                  iconBgColor: Colors.green.shade50,
                                  title: "Revenue",
                                  content: content,
                                  contentFontSize: 14,
                                  extra: Container(
                                    width: 125,
                                    child: FutureBuilder(
                                      future: _getDashboardDataSessionGraph,
                                      builder: (context, asyncSnapshot) {
                                        List<ChartData> data = [];
                                        bool waiting = false;
                                        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                                          waiting = true;
                                        } else {
                                          waiting = false;
                                        }
                                        if (asyncSnapshot.hasError) {
                                          showAlert('${asyncSnapshot.error}', AlertType.error);
                                        } else if (asyncSnapshot.data != null) {
                                          data = asyncSnapshot.data!;
                                        }
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            ButtonHelperG(
                                              onTap: () async {
                                                await showDatePickerHelper(
                                                  context: context,
                                                  onValueChange: (date) {
                                                    adminHomeController.dashboardDate = date;
                                                    adminHomeController.update();
                                                    setState(() {
                                                      _getDashboardDataBookingCount = adminHomeController.getDashboardDataBookingCount();
                                                      _getDashboardDataSessionGraph = adminHomeController.getDashboardDataSessionGraph();
                                                    });
                                                  },
                                                  selectedDateRange: adminHomeController.dashboardDate,
                                                );
                                              },
                                              label: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextHelper(
                                                    text: adminHomeController.dashboardDate.start == adminHomeController.dashboardDate.end
                                                        ? DateFormat('dd-MM-yy').format(adminHomeController.dashboardDate.start)
                                                        : '${DateFormat('dd-MM-yy').format(adminHomeController.dashboardDate.start)} - ${DateFormat('dd-MM-yy').format(adminHomeController.dashboardDate.end)}',
                                                    fontsize: 10,
                                                    width: 100,
                                                    padding: EdgeInsets.zero,
                                                    textalign: TextAlign.right,
                                                    isWrap: true,
                                                  ),
                                                  Icon(MoonIcons.time_calendar_24_regular, color: Colors.green.shade700, size: 20),
                                                ],
                                              ),
                                              margin: 0,
                                              width: 135,
                                              padding: EdgeInsets.zero,
                                              height: 25,
                                              background: Colors.transparent,
                                            ),
                                            SizedBox(
                                              width: 135,
                                              height: 50,
                                              child: ClipRRect(
                                                child: Skeletonizer(
                                                  enabled: waiting,
                                                  child: AreaChartHelper(
                                                    borderColor: Colors.green.shade300,
                                                    borderDrawMode: BorderDrawMode.top,
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [Colors.green.shade100, Colors.white],
                                                    ),
                                                    dataSource: data,
                                                    enableTooltip: false,
                                                    chartTitle: '',
                                                    showToolTip: false,
                                                    showBorder: false,
                                                    showXAxis: false,
                                                    showYAxis: false,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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

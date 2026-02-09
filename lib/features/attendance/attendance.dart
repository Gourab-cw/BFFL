import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/daterangepicker.dart';
import 'package:healthandwellness/features/attendance/controller/attendance_controller.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:intl/intl.dart';

import '../../core/utility/app_loader.dart';
import '../../core/utility/helper.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final appLoaderController = Get.find<AppLoaderController>();
  final mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final auth = Get.find<Authenticator>();
  final Stream timeStream = Stream.periodic(const Duration(seconds: 1), (v) {
    return DateTime.now();
  });
  late final brodcastTime = timeStream.asBroadcastStream();
  late final AttendanceController attendanceStore;

  String getKmMeter(double meter) {
    if (meter > 999) {
      String dis = '';
      double remainder = meter % 1000;
      double val = (meter / 1000).roundToDouble();
      dis += "$val Km";
      if (remainder > 0) {
        dis += " ${remainder.round()} M";
      }
      return dis;
    } else {
      return '${parseString(data: meter, defaultValue: '0.0')} meters';
    }
  }

  Future<void> submitAttendance() async {}

  String getFormatedTime(String time) {
    String time0 = time;
    time0 = parseDateToString(data: time, formatDate: 'dd-MM-yyyy hh:mm a', predefinedDateFormat: 'yyyy-MM-dd hh:mm:ss', defaultValue: '');
    return time0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    if (!Get.isRegistered<AttendanceController>()) {
      Get.lazyPut(() => AttendanceController(), fenix: true);
    }
    attendanceStore = Get.find<AttendanceController>();
    getLocationPermission(context);
    Future(() async {
      try {
        await attendanceStore.haveAttendance();
        await attendanceStore.getAttendanceList();
      } catch (e) {
        showAlert("$e", AlertType.error);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding;
    return GetBuilder<AttendanceController>(
      init: attendanceStore,
      autoRemove: false,
      builder: (attendanceStore) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: safePadding.top, left: safePadding.left, bottom: safePadding.bottom, right: safePadding.right),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              if (!attendanceStore.todayHaveAttendance)
                ButtonHelperG(
                  width: 210,
                  onTap: () async {
                    loader.startLoading();
                    try {
                      await attendanceStore.giveAttendance();
                    } catch (e) {
                      showAlert("$e", AlertType.error);
                    } finally {
                      loader.stopLoading();
                    }
                  },
                  icon: Icon(Icons.check, color: Colors.white, size: 18),
                  label: TextHelper(text: "Mark today's attendance", color: Colors.white),
                ),
              TextHelper(text: "Attendance List", fontsize: 16, fontweight: FontWeight.w600),
              SizedBox(height: 15),
              DateRangePicker(
                width: 210,
                selectedDateRange: attendanceStore.range,
                withBorder: true,
                height: 40,
                onValueChange: (v) async {
                  attendanceStore.range = v;
                  try {
                    await attendanceStore.getAttendanceList();
                  } catch (e) {
                    showAlert("$e", AlertType.error);
                  }
                  attendanceStore.update();
                },
              ),
              SizedBox(height: 5),
              Expanded(
                child: Center(
                  child: DataGridHelper3(
                    headerColor: Colors.green.shade100,
                    withBorder: true,
                    dataSource: attendanceStore.getAttendanceDatasource(),
                    columnList: [
                      DataGridColumnModel3(
                        dataField: "createdAt",
                        dataType: CellDataType3.string,
                        title: "Date",
                        customCell: (c) {
                          return TextHelper(text: DateFormat("dd-MM-yyyy").format((c.cellValue as Timestamp).toDate()), textalign: TextAlign.center);
                        },
                      ),
                      DataGridColumnModel3(
                        dataField: "createdAt",
                        dataType: CellDataType3.string,
                        title: "Time",
                        customCell: (c) {
                          return TextHelper(text: DateFormat("hh:mm a").format((c.cellValue as Timestamp).toDate()), textalign: TextAlign.center);
                        },
                      ),
                      DataGridColumnModel3(dataField: "branchName", dataType: CellDataType3.string, title: "Branch"),
                    ],
                    uniqueKey: UniqueKey().toString(),
                    width: MediaQuery.sizeOf(context).width - 10,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

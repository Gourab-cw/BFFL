import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/staff/controller/staff_controller.dart';

import '../../login/data/user.dart';
import 'helper_ui/active_inactive_popup.dart';

class Staff extends StatefulWidget {
  const Staff({super.key});

  @override
  State<Staff> createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  final mainStore = Get.find<MainStore>();
  final staffController = Get.find<StaffController>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        await staffController.getStaffList();
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StaffController>(
      init: staffController,
      autoRemove: false,
      builder: (staffController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Staff"),
            actions: [
              ButtonHelperG(
                onTap: () async {
                  try {
                    Loader.startLoading();
                    await staffController.getStaffList();
                  } catch (e) {
                    showAlert("$e", AlertType.error);
                  } finally {
                    Loader.stopLoading();
                  }
                },
                shadow: [],
                icon: Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    List<Map<String, dynamic>> staffs = staffController.staffList.map((m) => m.toJSON()).toList();
                    return Center(
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * .98,
                        height: MediaQuery.sizeOf(context).height * .85,
                        // color: Colors.red,
                        child: DataGridHelper3(
                          fontSize: 11.5,
                          headerColor: mainStore.theme.value.mediumShadeColor,
                          dataSource: staffs,
                          withBorder: true,
                          columnList: [
                            DataGridColumnModel3(
                              dataField: 'name',
                              showFilter: true,
                              textAlign: CellTextAlignment3.left,
                              title: 'Name',
                              customCell: (c) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextHelper(text: '${c.cellValue}', textalign: TextAlign.left, fontsize: 11.5),
                                    TextHelper(text: '${c.rowValue['mail']}', textalign: TextAlign.left, fontsize: 9),
                                  ],
                                );
                              },
                              dataType: CellDataType3.string,
                            ),
                            DataGridColumnModel3(
                              dataField: 'branchId',
                              showFilter: true,
                              customCell: (v) {
                                return TextHelper(
                                  text: staffController.branchList.firstWhereOrNull((f) => f.id == v.cellValue)?.name ?? "",
                                  textalign: TextAlign.center,
                                  fontsize: 11.5,
                                );
                              },
                              customFilterCellText: (v) {
                                return staffController.branchList.firstWhereOrNull((f) => f.id == v)?.name ?? "";
                              },
                              title: 'Branch',
                              dataType: CellDataType3.string,
                            ),
                            DataGridColumnModel3(
                              dataField: 'userType',
                              width: 90,
                              showFilter: true,
                              customFilterCellText: (v) {
                                return (userTypeMap[v]?.name ?? "").toUpperCase();
                              },
                              customCell: (v) {
                                return TextHelper(text: (userTypeMap[v.cellValue]?.name ?? "").toUpperCase(), textalign: TextAlign.center, fontsize: 9.5);
                              },
                              title: 'Type',
                              dataType: CellDataType3.string,
                            ),
                            DataGridColumnModel3(
                              width: 50,
                              dataField: 'isActive',
                              customCell: (v) {
                                return ButtonHelperG(
                                  onTap: () async {
                                    await makeActiveInactive(context, staffController.staffList[v.rowIndex], staffController);
                                  },
                                  background: Colors.transparent,
                                  icon: Icon(Icons.circle, size: 16, color: v.cellValue ? Colors.green : Colors.red),
                                );
                              },
                              title: '',
                              dataType: CellDataType3.string,
                            ),
                          ],
                          uniqueKey: UniqueKey().toString(),
                          width: MediaQuery.sizeOf(context).width * .98,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

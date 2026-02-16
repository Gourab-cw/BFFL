import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/member_approve/controller/member_approve_controller.dart';

import '../../members/controller/member_controller.dart';

class MemberApproveRegister extends StatefulWidget {
  const MemberApproveRegister({super.key});

  @override
  State<MemberApproveRegister> createState() => _MemberApproveRegisterState();
}

class _MemberApproveRegisterState extends State<MemberApproveRegister> {
  final loader = Get.find<AppLoaderController>();
  final mainStore = Get.find<MainStore>();
  final memberApproveCtrl = Get.find<MemberApproveController>();
  final memberController = Get.find<MemberController>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        loader.startLoading();
        await memberApproveCtrl.getApprovalUserList();
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
    return GetBuilder(
      init: memberApproveCtrl,
      autoRemove: false,
      builder: (memberApproveCtrl) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper(text: "Pending Approval", fontsize: 15, fontweight: FontWeight.w600),
                  ButtonHelperG(
                    width: 100,
                    background: Colors.blueGrey.shade500,
                    onTap: () async {
                      try {
                        loader.startLoading();
                        await memberApproveCtrl.getApprovalUserList();
                      } catch (e) {
                        showAlert("$e", AlertType.error);
                      } finally {
                        loader.stopLoading();
                      }
                    },
                    height: 35,
                    label: TextHelper(text: "Refresh", color: Colors.white, fontsize: 12),
                    icon: Icon(Icons.refresh, color: Colors.white, size: 18),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: DataGridHelper3(
                    headerColor: Colors.grey.shade300,
                    columnSpacing: 1,
                    fontSize: 11.5,
                    withBorder: true,
                    showAlternateColor: true,
                    borderColor: Colors.grey.shade100,
                    dataSource: memberApproveCtrl.list.map((m) => m.toJSON()).toList(),
                    columnList: [
                      DataGridColumnModel3(dataField: 'name', dataType: CellDataType3.string, title: "Name"),
                      DataGridColumnModel3(dataField: 'address', dataType: CellDataType3.string, title: "Address"),
                      DataGridColumnModel3(dataField: 'branchId', dataType: CellDataType3.string, title: "Branch"),
                      DataGridColumnModel3(
                        dataField: 'isApproved',
                        width: 160,
                        dataType: CellDataType3.string,
                        title: "",
                        customCell: (c) {
                          bool isApproved = parseBool(data: makeMapSerialize(c.cellValue)['isApproved'], defaultValue: false);
                          return isApproved
                              ? TextHelper(text: "Approved", color: Colors.grey.shade500)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ButtonHelperG(
                                      onTap: () {
                                        UserG? user = memberApproveCtrl.list.firstWhereOrNull((f) => f.id == c.rowValue['id']);
                                        if (user != null) {
                                          memberController.selectedUser = memberApproveCtrl.list.firstWhere((f) => f.id == c.rowValue['id']);
                                          memberController.update();
                                          Get.toNamed('/memberdetails');
                                        }
                                      },
                                      margin: 2,
                                      shadow: [],
                                      background: Colors.blueGrey.shade100,
                                      width: 60,
                                      label: TextHelper(text: 'Details', fontsize: 11),
                                    ),
                                    ButtonHelperG(
                                      onTap: () async {
                                        UserG? user = memberApproveCtrl.list.firstWhereOrNull((f) => f.id == c.rowValue['id']);
                                        if (user != null) {
                                          try {
                                            loader.startLoading();
                                            await memberApproveCtrl.approveMember(user);
                                          } catch (e) {
                                            showAlert("$e", AlertType.error);
                                          } finally {
                                            loader.stopLoading();
                                          }
                                        }
                                      },
                                      margin: 2,
                                      shadow: [],
                                      background: Colors.lightGreen.shade200,
                                      width: 70,
                                      label: TextHelper(text: 'Approve', fontsize: 11),
                                    ),
                                  ],
                                );
                        },
                      ),
                    ],
                    uniqueKey: UniqueKey().toString(),
                    width: MediaQuery.sizeOf(context).width - 25,
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

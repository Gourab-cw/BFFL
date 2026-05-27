import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_details_controller.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../../controller/member_controller.dart';

class MemberBookingHistory extends StatefulWidget {
  const MemberBookingHistory({super.key});

  @override
  State<MemberBookingHistory> createState() => _MemberBookingHistoryState();
}

class _MemberBookingHistoryState extends State<MemberBookingHistory> {
  final userSubController = Get.find<UserSubscriptionController>();
  final userSubDetailsController = Get.find<UserSubscriptionDetailsController>();
  final auth = Get.find<Authenticator>();
  final mainStore = Get.find<MainStore>();
  final subController = Get.find<SubscriptionController>();
  final loader = Get.find<AppLoaderController>();
  final MemberController memberController = Get.find<MemberController>();

  bool withAppBar = parseBool(data: Get.parameters["withAppBar"], defaultValue: false);
  bool withFilter = true;

  Widget getTypeWidget(UserSubscription us) {
    if (us.isPaidSubscription) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(color: Colors.green.shade200, borderRadius: BorderRadius.circular(10)),
        child: TextHelper(text: 'Paid Service', fontsize: 10, fontweight: FontWeight.w600),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(color: Colors.amber.shade200, borderRadius: BorderRadius.circular(10)),
      child: TextHelper(text: 'Trial', fontsize: 10, fontweight: FontWeight.w600),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      if (!withAppBar) {
        return;
      }
      try {
        loader.startLoading();
        await userSubController.getSubscriptionList(null);
      } catch (e) {
        showAlert('$e', AlertType.error);
      } finally {
        loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      init: subController,
      autoRemove: false,
      builder: (context) {
        return GetBuilder<UserSubscriptionController>(
          init: userSubController,
          autoRemove: false,
          builder: (userSubController) {
            return AppLoader(
              child: Scaffold(
                appBar: withAppBar
                    ? AppBar(
                        title: Text("Subscriptions"),
                        actions: [
                          if (withAppBar)
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Row(
                                spacing: 5,
                                children: [
                                  Transform.scale(
                                    scale: 0.8,
                                    child: MoonSwitch(
                                      value: withFilter,
                                      onChanged: (v) {
                                        setState(() {
                                          withFilter = v;
                                        });
                                      },
                                      activeTrackColor: mainStore.theme.value.secondaryColor,
                                      switchSize: MoonSwitchSize.xs,
                                    ),
                                  ),
                                  TextHelper(text: "Active Only", color: mainStore.theme.value.DarkTextColor),
                                ],
                              ),
                            ),
                          if (withAppBar)
                            ButtonHelperG(
                              onTap: () async {
                                try {
                                  loader.startLoading();
                                  await userSubController.getSubscriptionList(null);
                                } catch (e) {
                                  showAlert('$e', AlertType.error);
                                } finally {
                                  loader.stopLoading();
                                }
                              },
                              margin: 0,
                              shadow: [],
                              background: getMainStore().theme.value.BackgroundColor,
                              icon: Icon(Icons.refresh, color: getMainStore().theme.value.HeadColor),
                            ),
                        ],
                      )
                    : null,
                body: Column(
                  children: [
                    if (!withAppBar)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (memberController.selectedUser != null &&
                              memberController.selectedUser!.isApproved &&
                              auth.state != null &&
                              auth.state!.userType != UserType.member)
                            ButtonHelperG(
                              onTap: () {
                                userSubController.user = memberController.selectedUser!.toJSON();
                                Get.toNamed('/usersubscriptionadd');
                              },
                              width: 80,
                              label: TextHelper(
                                text: "   + Create\nsubscription",
                                fontsize: 11.5,
                                isWrap: true,
                                textalign: TextAlign.justify,
                                color: Colors.white,
                              ),
                            ),
                          if (memberController.selectedUser != null &&
                              memberController.selectedUser!.isApproved &&
                              auth.state != null &&
                              auth.state!.userType != UserType.member)
                            ButtonHelperG(
                              background: mainStore.theme.value.lowShadeColor,
                              shadow: [],
                              onTap: () async {
                                try {
                                  loader.startLoading();
                                  await userSubController.getSubscriptionList(memberController.selectedUser!.id);
                                } catch (e) {
                                  showAlert("$e", AlertType.error);
                                } finally {
                                  loader.stopLoading();
                                }
                              },
                              width: 40,
                              label: Icon(Icons.refresh, color: mainStore.theme.value.HeadColor),
                            ),
                        ],
                      ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (userSubController.subscriptionList.isEmpty) {
                            return Center(
                              child: TextHelper(text: "No Subscription Found!", textalign: TextAlign.center),
                            );
                          }
                          List<UserSubscription> subs = userSubController.subscriptionList;
                          if (withFilter && withAppBar) {
                            int now = parseInt(data: DateFormat("yyyy-MM-dd").format(DateTime.now()).replaceAll('-', ''));
                            subs = userSubController.subscriptionList.where((f) {
                              return parseInt(data: (f.startDate.split(' ').firstOrNull ?? "").replaceAll('-', '')) <= now &&
                                  parseInt(data: (f.endDate.split(' ').firstOrNull ?? "").replaceAll('-', '')) >= now &&
                                  f.isActive;
                            }).toList();
                          }
                          return ListView.builder(
                            itemCount: subs.length,
                            itemBuilder: (_, index) {
                              UserSubscription us = subs[index];
                              return GestureDetector(
                                onTap: () {
                                  userSubDetailsController.selectedSubscription = us;
                                  Get.toNamed('/userSubscriptionDetails');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: mainStore.theme.value.lowShadeColor, borderRadius: BorderRadiusGeometry.circular(10)),
                                    child: Row(
                                      spacing: 4,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.ad_units_sharp, color: Colors.blueGrey.shade800),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                spacing: 10,
                                                children: [
                                                  TextHelper(text: us.name, fontweight: FontWeight.w600, fontsize: 12),
                                                  Builder(
                                                    builder: (context) {
                                                      String text = subController.list.firstWhereOrNull((sc) => sc.id == us.subscriptionId)?.name ?? "";
                                                      if (text != "") {
                                                        text = "( $text )";
                                                      }
                                                      return TextHelper(text: text, fontweight: FontWeight.w400, fontsize: 10.5);
                                                    },
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TextHelper(
                                                    text:
                                                        'Validity: ${parseDateToString(data: us.startDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: '')}  -  ${parseDateToString(data: us.endDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: '')}',
                                                    fontsize: 10,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [TextHelper(text: us.userName, fontsize: 10)],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            getTypeWidget(us),
                                            TextHelper(
                                              text: us.isActive == false ? 'Not Active' : 'Active',
                                              fontsize: 10,
                                              color: us.isActive == false ? Colors.red.shade600 : Colors.grey.shade600,
                                            ),
                                            TextHelper(
                                              text: us.dueAmount > 0 ? 'Due Amount : ${currenyFormater(value: us.dueAmount, withDrCr: false)}' : 'Paid',
                                              fontsize: 10,
                                              color: us.dueAmount > 0 ? Colors.red.shade600 : Colors.grey.shade600,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
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

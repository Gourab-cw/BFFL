import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';

import '../../controller/member_controller.dart';

class MemberBookingHistory extends StatefulWidget {
  const MemberBookingHistory({super.key});

  @override
  State<MemberBookingHistory> createState() => _MemberBookingHistoryState();
}

class _MemberBookingHistoryState extends State<MemberBookingHistory> {
  final userSubController = Get.find<UserSubscriptionController>();
  final auth = Get.find<Authenticator>();
  final mainStore = Get.find<MainStore>();
  final subController = Get.find<SubscriptionController>();
  final loader = Get.find<AppLoaderController>();
  final MemberController memberController = Get.find<MemberController>();

  Widget getTypeWidget(UserSubscription us) {
    if (us.isPaidSubscription) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(color: Colors.green.shade200, borderRadius: BorderRadius.circular(10)),
        child: TextHelper(text: 'Paid Service', fontsize: 12, fontweight: FontWeight.w600),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(color: Colors.amber.shade200, borderRadius: BorderRadius.circular(10)),
      child: TextHelper(text: 'Trial', fontsize: 12, fontweight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserSubscriptionController>(
      init: userSubController,
      autoRemove: false,
      builder: (userSubController) {
        return Column(
          children: [
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
                    label: TextHelper(text: "   + Create\nsubscription", fontsize: 11.5, isWrap: true, textalign: TextAlign.justify, color: Colors.white),
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
              child: ListView.builder(
                itemCount: userSubController.subscriptionList.length,
                itemBuilder: (_, index) {
                  UserSubscription us = userSubController.subscriptionList[index];
                  return Padding(
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
                                Wrap(
                                  children: [
                                    TextHelper(text: us.name, fontweight: FontWeight.w600),
                                    TextHelper(
                                      text: subController.list.firstWhereOrNull((sc) => sc.id == us.subscriptionId)?.name ?? "",
                                      fontweight: FontWeight.w400,
                                      fontsize: 11,
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextHelper(
                                      text:
                                          'Start: ${parseDateToString(data: us.startDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: '')}',
                                      fontsize: 11,
                                    ),
                                  ],
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
                                fontsize: 11,
                                color: us.isActive == false ? Colors.red.shade600 : Colors.grey.shade600,
                              ),
                              TextHelper(
                                text: us.dueAmount > 0 ? 'Due Amount : ${currenyFormater(value: us.dueAmount, withDrCr: false)}' : 'Paid',
                                fontsize: 11,
                                color: us.dueAmount > 0 ? Colors.red.shade600 : Colors.grey.shade600,
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
          ],
        );
      },
    );
  }
}

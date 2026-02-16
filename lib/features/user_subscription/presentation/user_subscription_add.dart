import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/async_select.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/presentation/sub_screen/trail_sub.dart';
import 'package:moon_design/moon_design.dart';

class UserSubscriptionAdd extends StatefulWidget {
  const UserSubscriptionAdd({super.key});

  @override
  State<UserSubscriptionAdd> createState() => _UserSubscriptionAddState();
}

class _UserSubscriptionAddState extends State<UserSubscriptionAdd> {
  final UserSubscriptionController userSubscriptionController = Get.find<UserSubscriptionController>();
  final loader = Get.find<AppLoaderController>();

  List<SelectItem> getSubscriptions() {
    List<UserSubscriptionType> list = UserSubscriptionType.values;
    List<SelectItem> ll = [];
    for (int i = 0; i < list.length; i++) {
      ll.add(SelectItem(id: i, value: list[i].name.toUpperCase()));
    }
    return ll;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserSubscriptionController>(
      init: userSubscriptionController,
      autoRemove: false,
      builder: (userSubscriptionController) {
        return Scaffold(
          appBar: AppBar(
            title: TextHelper(text: "Create Subscription", fontsize: 15, fontweight: FontWeight.w600),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    TextHelper(text: "Member :", fontweight: FontWeight.w600, width: 60),
                    SizedBox(
                      width: (MediaQuery.sizeOf(context).width - 102) > 300 ? 300 : MediaQuery.sizeOf(context).width - 102,
                      child: AsyncSelect(
                        parentHeight: 40,
                        withBorder: true,
                        value: userSubscriptionController.user,
                        onValueChange: (v) {
                          userSubscriptionController.user = makeMapSerialize(v);
                          userSubscriptionController.update();
                        },
                        uniqueKey: UniqueKey().toString(),
                        callContent: userSubscriptionController.getMembers,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      TextHelper(text: "Subscription Type :", fontweight: FontWeight.w600, width: 130),
                      Wrap(
                        spacing: 20,
                        children: [
                          ...UserSubscriptionType.values.map((m) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MoonCheckbox(
                                  activeColor: Colors.lightGreen,
                                  value: userSubscriptionController.subscriptionType == m,
                                  onChanged: (v) {
                                    userSubscriptionController.subscriptionType = m;
                                    userSubscriptionController.update();
                                  },
                                ),
                                TextHelper(text: m.name.toUpperCase(), fontsize: 12),
                              ],
                            );
                          }),
                        ],
                      ),
                      if (userSubscriptionController.subscriptionType != null) Expanded(child: TrailSub()),
                      if (userSubscriptionController.subscriptionType != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonHelperG(
                              onTap: () async {
                                try {
                                  loader.startLoading();
                                  await userSubscriptionController.saveUserSubscription();
                                  userSubscriptionController.subDataGridData = [];
                                  userSubscriptionController.subscriptionType = null;
                                  userSubscriptionController.user = {};
                                  userSubscriptionController.update();
                                  showAlert("Success", AlertType.success);
                                } catch (e) {
                                  showAlert("$e", AlertType.error);
                                } finally {
                                  loader.stopLoading();
                                }
                              },
                              width: 100,
                              label: TextHelper(text: 'Save', color: Colors.white),
                            ),
                          ],
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/async_select.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/presentation/sub_screen/trail_sub.dart';

class UserSubscriptionAdd extends StatefulWidget {
  const UserSubscriptionAdd({super.key});

  @override
  State<UserSubscriptionAdd> createState() => _UserSubscriptionAddState();
}

class _UserSubscriptionAddState extends State<UserSubscriptionAdd> {
  final UserSubscriptionController userSubscriptionController = Get.find<UserSubscriptionController>();
  final loader = Get.find<AppLoaderController>();
  final mainStore = Get.find<MainStore>();

  List<SelectItem> getSubscriptions() {
    List<UserSubscriptionType> list = UserSubscriptionType.values;
    List<SelectItem> ll = [];
    for (int i = 0; i < list.length; i++) {
      ll.add(SelectItem(id: i, value: list[i].name.toUpperCase()));
    }
    return ll;
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        Loader.startLoading();
        await userSubscriptionController.getVoucher();
        await userSubscriptionController.loadChargesLedgers();
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
    return GetBuilder<UserSubscriptionController>(
      init: userSubscriptionController,
      autoRemove: false,
      builder: (userSubscriptionController) {
        return Scaffold(
          appBar: AppBar(title: Text("Create Subscription")),
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
                      Expanded(child: TrailSub()),
                      if (userSubscriptionController.allSubscriptions.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonHelperG(
                              onTap: () async {
                                try {
                                  loader.startLoading();
                                  await userSubscriptionController.saveUserSubscription();
                                  userSubscriptionController.allSubscriptions = [];
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

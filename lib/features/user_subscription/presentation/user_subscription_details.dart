import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_details_controller.dart';
import 'package:healthandwellness/features/user_subscription/presentation/sub_screen/payment_card_view.dart';
import 'package:healthandwellness/features/user_subscription/presentation/sub_screen/session_card_view.dart';

class UserSubscriptionDetails extends StatefulWidget {
  const UserSubscriptionDetails({super.key});

  @override
  State<UserSubscriptionDetails> createState() => _UserSubscriptionDetailsState();
}

class _UserSubscriptionDetailsState extends State<UserSubscriptionDetails> with SingleTickerProviderStateMixin {
  final UserSubscriptionDetailsController userSubscriptionDetailsController = Get.find<UserSubscriptionDetailsController>();
  final sc = Get.find<SubscriptionController>();
  final mainStore = Get.find<MainStore>();
  final double width = 75;

  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      tabController = TabController(length: 2, vsync: this);
    });
    Future(() async {
      try {
        Loader.startLoading();
        await userSubscriptionDetailsController.initDataLoader();
      } catch (e) {
        showAlert('$e', AlertType.error);
      } finally {
        Loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: userSubscriptionDetailsController,
      autoRemove: false,
      builder: (userSubscriptionDetailsController) {
        final userSubscription = userSubscriptionDetailsController.selectedSubscription;
        if (userSubscription == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Subscription Details')),
            body: Center(child: Text("No subscription found!")),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('Subscription Details')),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 5,
                children: [
                  Row(
                    children: [
                      TextHelper(text: 'ID :', width: width),
                      TextHelper(text: userSubscription.name, fontweight: FontWeight.w600),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'Validity :', width: width),
                      TextHelper(
                        text:
                            '${parseDateToString(data: userSubscription.startDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: '')} - ${parseDateToString(data: userSubscription.endDate, formatDate: 'dd-MM-yyyy', predefinedDateFormat: 'yyyy-MM-dd', defaultValue: '')}',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'Service :', width: width),
                      TextHelper(text: sc.list.firstWhereOrNull((s) => s.id == userSubscription.subscriptionId)?.name ?? ""),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'Sessions :', width: width),
                      TextHelper(text: userSubscription.totalSessions.toString()),
                      userSubscription.remainingSessions > 0
                          ? TextHelper(text: ' ( ${userSubscription.remainingSessions.toString()} left ) ')
                          : TextHelper(text: ' ( All sessions used ) '),
                    ],
                  ),
                  Row(
                    children: [
                      TextHelper(text: 'Amount :', width: width),
                      TextHelper(
                        text: currenyFormater(value: userSubscription.netAmount, withDrCr: false),
                        fontweight: FontWeight.w600,
                      ),
                      userSubscription.dueAmount > 0
                          ? TextHelper(
                              text: ' ( ${currenyFormater(value: userSubscription.dueAmount, withDrCr: false)} due ) ',
                              fontweight: FontWeight.w600,
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  Divider(),
                  TabBar(
                    controller: tabController,
                    indicatorColor: mainStore.theme.value.HeadColor,
                    labelColor: mainStore.theme.value.HeadColor,
                    tabs: [
                      Tab(text: 'Sessions', height: 30),
                      Tab(text: 'Payments', height: 30),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        Container(
                          child: ListView.builder(
                            itemCount: userSubscriptionDetailsController.sessions.length,
                            itemBuilder: (_, index) {
                              final session = userSubscriptionDetailsController.sessions[index];
                              return SessionCardView(sessionModel: session, subscriptionId: userSubscription.id, subscriptionNo: userSubscription.name);
                            },
                          ),
                        ),
                        ListView.builder(
                          itemCount: userSubscriptionDetailsController.payments.length,
                          itemBuilder: (_, index) {
                            final payment = userSubscriptionDetailsController.payments[index];
                            return PaymentCardView(payment: payment);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

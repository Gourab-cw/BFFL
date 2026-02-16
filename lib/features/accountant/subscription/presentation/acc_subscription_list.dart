import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/features/accountant/subscription/controller/acc_subscription_controller.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../../../../core/utility/helper.dart';
import '../../../user_subscription/data/user_subscription.dart';

class AccSubscriptionList extends StatefulWidget {
  const AccSubscriptionList({super.key});

  @override
  State<AccSubscriptionList> createState() => _AccSubscriptionListState();
}

class _AccSubscriptionListState extends State<AccSubscriptionList> {
  final accSubController = Get.find<AccSubscriptionController>();
  final subController = Get.find<SubscriptionController>();
  final loader = Get.find<AppLoaderController>();
  Widget getTypeWidget(UserSubscription us) {
    switch (us.type) {
      case UserSubscriptionType.trial:
        return Container(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: BoxDecoration(color: Colors.amber.shade200, borderRadius: BorderRadius.circular(10)),
          child: TextHelper(text: 'Trial', fontsize: 12, fontweight: FontWeight.w600),
        );
      case UserSubscriptionType.dayWise:
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(color: Colors.green.shade200, borderRadius: BorderRadius.circular(10)),
          child: TextHelper(text: 'Day Wise', fontsize: 12, fontweight: FontWeight.w600),
        );
      case UserSubscriptionType.slotWise:
        return Container(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          decoration: BoxDecoration(color: Colors.green.shade200, borderRadius: BorderRadius.circular(10)),
          child: TextHelper(text: 'Slot Wise', fontsize: 12, fontweight: FontWeight.w600),
        );
    }
    return Container();
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        loader.startLoading();
        await accSubController.getList();
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
    return GetBuilder<AccSubscriptionController>(
      init: accSubController,
      autoRemove: false,
      builder: (accSubController) {
        return Scaffold(
          appBar: AppBar(
            title: TextHelper(text: "Subscriptions", fontsize: 15, fontweight: FontWeight.w600),
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextBox(
                      leading: Icon(MoonIcons.generic_search_24_regular, color: Colors.grey),
                      placeholder: 'Search...',
                    ),
                  ),
                  ButtonHelperG(
                    background: Colors.blueGrey.shade100,
                    shadow: [],
                    onTap: () async {
                      try {
                        loader.startLoading();
                        await accSubController.getList();
                      } catch (e) {
                        showAlert("$e", AlertType.error);
                      } finally {
                        loader.stopLoading();
                      }
                    },
                    width: 40,
                    label: Icon(Icons.refresh, color: Colors.green.shade800),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: accSubController.list.length,
                  itemBuilder: (_, index) {
                    UserSubscription us = accSubController.list[index];
                    return GestureDetector(
                      onTap: () async {
                        try{
                          loader.startLoading();
                          await accSubController.getDetails(us);
                          Get.toNamed('/accsubscriptiondetails');
                        }catch(e){
                          showAlert("$e", AlertType.error);
                        }finally{
                          loader.stopLoading();
                        }

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadiusGeometry.circular(10)),
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
                                  TextHelper(text: 'Created At: ${DateFormat('dd-MM-yyyy').format(us.createdAt)}', fontsize: 11, color: Colors.grey.shade600),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

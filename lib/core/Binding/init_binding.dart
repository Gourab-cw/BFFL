import 'package:get/get.dart';

import '../../features/Service/controller/service_controller.dart';
import '../../features/calendar_report/controller/calendar_report_controller.dart';
import '../../features/home/controller/member_home_controller.dart';
import '../../features/slot_details_trainer/controller/slot_details_controller.dart';
import '../../features/subscriptions/controller/subscription_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    Get.lazyPut(() => MemberHomeController(), fenix: true);
    Get.lazyPut(() => SubscriptionController(), fenix: true);
    Get.lazyPut(() => ServiceController(), fenix: true);
    Get.lazyPut(() => CalenderReportController(), fenix: true);
    Get.lazyPut(() => SlotDetailsController(), fenix: true);
  }
}

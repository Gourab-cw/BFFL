import 'package:get/get.dart';

import '../../features/Service/controller/service_controller.dart';
import '../../features/accountant/subscription/controller/acc_subscription_controller.dart';
import '../../features/calendar_report/controller/calendar_report_controller.dart';
import '../../features/home/controller/member_home_controller.dart';
import '../../features/member_approve/controller/member_approve_controller.dart';
import '../../features/members/controller/member_controller.dart';
import '../../features/slot_details_trainer/controller/slot_details_controller.dart';
import '../../features/subscriptions/controller/subscription_controller.dart';
import '../../features/user_subscription/controller/user_subscription_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AccSubscriptionController(), fenix: true);
    Get.lazyPut(() => MemberController(), fenix: true);
    Get.lazyPut(() => MemberApproveController(), fenix: true);
    Get.lazyPut(() => MemberHomeController(), fenix: true);
    Get.lazyPut(() => SubscriptionController(), fenix: true);
    Get.lazyPut(() => ServiceController(), fenix: true);
    Get.lazyPut(() => CalenderReportController(), fenix: true);
    Get.lazyPut(() => SlotDetailsController(), fenix: true);
    Get.lazyPut(() => UserSubscriptionController(), fenix: true);
  }
}

import 'package:get/get.dart';
import 'package:healthandwellness/core/voucher/controller/voucher_controller.dart';
import 'package:healthandwellness/features/staff/controller/staff_controller.dart';

import '../../features/Payment/controller/payment_controller.dart';
import '../../features/Service/controller/service_controller.dart';
import '../../features/accountant/history/controller/accountant_history_controller.dart';
import '../../features/accountant/subscription/controller/acc_subscription_controller.dart';
import '../../features/calendar_report/controller/calendar_report_controller.dart';
import '../../features/home/controller/admin_home_controller.dart';
import '../../features/home/controller/member_home_controller.dart';
import '../../features/member_approve/controller/member_approve_controller.dart';
import '../../features/members/controller/member_controller.dart';
import '../../features/receptionist/schedule/controller/daily_schedule_controller.dart';
import '../../features/slot_details_trainer/controller/slot_details_controller.dart';
import '../../features/slot_details_trainer/controller/slot_details_register_controller.dart';
import '../../features/slot_register/controller/slot_register_controller.dart';
import '../../features/subscriptions/controller/subscription_controller.dart';
import '../../features/user_subscription/controller/user_subscription_controller.dart';
import '../branch/controller/branch_controller.dart';

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
    Get.lazyPut(() => SlotDetailsTrainerController(), fenix: true);
    Get.lazyPut(() => DailyScheduleController(), fenix: true);
    Get.lazyPut(() => SlotRegisterController(), fenix: true);
    Get.lazyPut(() => AdminHomeController(), fenix: true);
    Get.lazyPut(() => BranchController(), fenix: true);
    Get.lazyPut(() => VoucherController(), fenix: true);
    Get.lazyPut(() => AccountantHistoryController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => StaffController(), fenix: true);
  }
}

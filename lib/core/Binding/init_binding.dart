import 'package:get/get.dart';

import '../../features/Service/controller/service_controller.dart';
import '../../features/calendar_report/controller/calendar_report_controller.dart';
import '../../features/subscriptions/controller/subscription_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => SubscriptionController(), fenix: true);
    Get.lazyPut(() => ServiceController(), fenix: true);
    Get.lazyPut(() => CalenderReportController(), fenix: true);
  }
}

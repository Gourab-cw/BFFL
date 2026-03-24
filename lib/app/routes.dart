import 'package:get/get.dart';
import 'package:healthandwellness/core/Parent%20Screen/parent_screen.dart';
import 'package:healthandwellness/core/Picklist/picklist_provider.dart';
import 'package:healthandwellness/features/home/presentation/home.dart';
import 'package:healthandwellness/features/login/presentation/login.dart';
import 'package:healthandwellness/features/members/presentation/member_details.dart';
import 'package:healthandwellness/features/members/presentation/members.dart';
import 'package:healthandwellness/features/slot_manage/controller/slot_manage_controller.dart';

import '../features/Payment/presentation/payment_details.dart';
import '../features/Service/presentation/service_details_view.dart';
import '../features/Service/presentation/service_view.dart';
import '../features/accountant/history/presentation/accountant_history.dart';
import '../features/accountant/subscription/presentation/acc_subscription_details.dart';
import '../features/member_approve/presentation/member_approve_register.dart';
import '../features/members/controller/member_controller.dart';
import '../features/members/presentation/member_session_details.dart';
import '../features/receptionist/schedule/presentation/daily_schedule.dart';
import '../features/slot_details_recptionist/presentation/slot_details_receptionist.dart';
import '../features/slot_details_trainer/presentation/slot_details_register.dart';
import '../features/slot_details_trainer/presentation/slot_details_trainer_view.dart';
import '../features/slot_manage/presentation/slot_manage.dart';
import '../features/slot_register/presentation/slot_register.dart';
import '../features/staff/presentation/staff.dart';
import '../features/staff_register/presentation/staff_register.dart';
import '../features/subscriptions/controller/subscription_controller.dart';
import '../features/user_add/controller/new_user_form_controller.dart';
import '../features/user_add/presentation/user_add.dart';
import '../features/user_subscription/presentation/user_subscription_add.dart';
import '../features/user_subscription/presentation/user_subscription_details.dart';

final List<GetPage<dynamic>> routes = [
  GetPage(name: "/login", page: () => Login()),
  GetPage(name: "/home", page: () => Home(), bindings: []),
  GetPage(name: "/slotdetailstrainerview", page: () => SlotDetailsTrainerView(), bindings: []),
  GetPage(name: "/servicedetailsview", page: () => ServiceDetailsView(), bindings: []),
  GetPage(name: "/membersessiondetails", page: () => MemberSessionDetails(), bindings: []),
  GetPage(name: "/serviceview", page: () => ServiceView(), bindings: []),
  GetPage(name: "/", page: () => ParentScreen(), bindings: [NewUserFormControllerBinding(), PickListBinding()]),
  GetPage(name: "/useradd", page: () => UserAdd(), binding: NewUserFormControllerBinding()),
  GetPage(name: "/memberlist", page: () => Members(), binding: MemberControllerBinding()),
  GetPage(name: "/memberdetails", page: () => MemberDetails(), binding: MemberControllerBinding()),
  GetPage(name: "/slotmanage", page: () => SlotManage(), bindings: [SlotControllerBinding(), SubscriptionControllerBinding()]),
  GetPage(name: "/usersubscriptionadd", page: () => UserSubscriptionAdd()),
  GetPage(name: "/accsubscriptiondetails", page: () => AccSubscriptionDetails()),
  GetPage(name: "/slotdetailsregister", page: () => SlotDetailsRegister()),
  GetPage(name: "/slotdetailsreceptionist", page: () => SlotDetailsReceptionist()),
  GetPage(name: "/slotregister", page: () => SlotRegister()),
  GetPage(name: "/staffregister", page: () => StaffRegister()),
  GetPage(name: "/dailyschedule", page: () => DailySchedule()),
  GetPage(name: "/memberapproveregister", page: () => MemberApproveRegister()),
  GetPage(name: "/paymentDetails", page: () => PaymentDetails()),
  GetPage(name: "/staff", page: () => Staff()),
  GetPage(name: "/accountantHistory", page: () => AccountantHistory()),
  GetPage(name: "/userSubscriptionDetails", page: () => UserSubscriptionDetails()),
];

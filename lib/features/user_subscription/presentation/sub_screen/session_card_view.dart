import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/session_model.dart';
import 'package:healthandwellness/features/home/controller/member_home_controller.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';

import '../../../Service/data/service.dart';
import '../../../members/controller/member_controller.dart';

class SessionCardView extends StatefulWidget {
  final SessionModel sessionModel;
  final String subscriptionNo;
  final String subscriptionId;
  const SessionCardView({super.key, required this.sessionModel, required this.subscriptionNo, required this.subscriptionId});

  @override
  State<SessionCardView> createState() => _SessionCardViewState();
}

class _SessionCardViewState extends State<SessionCardView> {
  final mainStore = Get.find<MainStore>();
  final auth = Get.find<Authenticator>();
  final fb = Get.find<FB>();
  final sc = Get.find<SubscriptionController>();
  final memberHomeController = Get.find<MemberHomeController>();
  final memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    SessionModel session = widget.sessionModel;
    return CardHelper(
      onTap: () async {
        // if (auth.state != null && auth.state!.userType == UserType.member) {
        if (memberController.selectedUser == null) {
          showAlert("No member selected", AlertType.error);
          return;
        }
        final db = await fb.getDB();
        final trainerSnap = await db.collection('User').doc(session.trainerId).get();
        if (!trainerSnap.exists) {
          showAlert("Trainer not found", AlertType.error);
          return;
        }
        final trainer = UserG.fromJSON(makeMapSerialize(trainerSnap.data()));
        ServiceModel? sm = sc.list.firstWhereOrNull((f) => f.id == session.serviceId);
        session = session.copyWith(
          serviceId: sm?.id ?? "",
          serviceName: sm?.name ?? "",
          subscriptionNo: widget.subscriptionNo,
          subscriptionId: widget.subscriptionId,
          trainerName: trainer.name,
          trainerId: trainer.id,
          memberName: memberController.selectedUser!.name,
          memberId: memberController.selectedUser!.id,
          memberContact1: memberController.selectedUser!.mobile,
        );
        memberHomeController.selectedBooking = session;
        Get.toNamed('/membersessiondetails');
        // } else {
        //   try {
        //     final slotCtrl = Get.find<SlotDetailsController>();
        //     slotCtrl.slot = session;
        //     await slotCtrl.getSlotDetails();
        //     Get.toNamed('/slotdetailstrainerview');
        //   } catch (e) {
        //     showAlert("$e", AlertType.error);
        //   } finally {
        //     loader.stopLoading();
        //   }
        // }
      },
      height: 70,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3, offset: Offset(1, 1))],
      backgroundColor: Colors.white,
      child: Column(
        spacing: 4,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 4,
                children: [
                  TextHelper(text: 'Service:', width: 50),
                  TextHelper(
                    text: sc.list.firstWhereOrNull((f) => f.id == session.serviceId)?.name ?? "",
                    fontsize: 12,
                    fontweight: FontWeight.w600,
                    color: mainStore.theme.value.BottomNavColor.withAlpha(180),
                  ),
                ],
              ),
              Row(
                spacing: 4,
                children: [
                  TextHelper(text: 'Session Time:', width: 95),
                  TextHelper(
                    text: parseDateToString(data: session.startTime, formatDate: 'HH:mm', predefinedDateFormat: 'HH:mm', defaultValue: ''),
                    fontsize: 12,
                    fontweight: FontWeight.w600,
                    color: mainStore.theme.value.LightTextColor.withAlpha(180),
                    width: 40,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(color: mainStore.theme.value.BottomNavColor.withAlpha(150), borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: TextHelper(text: session.hasAttend ? 'Attended' : 'Not Attended', fontsize: 11, color: mainStore.theme.value.DarkTextColor),
              ),
              Row(
                spacing: 4,
                children: [
                  TextHelper(text: 'Booked at: '),
                  TextHelper(
                    text: parseDateToString(
                      data: session.createdAt,
                      formatDate: 'dd-MM-yyyy HH:mm a',
                      predefinedDateFormat: 'yyyy-MM-dd HH:mm:ss',
                      defaultValue: '',
                    ),
                    fontsize: 12,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

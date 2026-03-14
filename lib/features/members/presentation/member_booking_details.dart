import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/members/controller/member_controller.dart';

class MemberBookingDetails extends StatefulWidget {
  const MemberBookingDetails({super.key});

  @override
  State<MemberBookingDetails> createState() => _MemberBookingDetailsState();
}

class _MemberBookingDetailsState extends State<MemberBookingDetails> {
  final mainStore = Get.find<MainStore>();
  final memberController = Get.find<MemberController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberController>(
      builder: (memberController) {
        return Scaffold(
          appBar: AppBar(title: Text("Booking Details")),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper(text: 'ID :', width: 80),
                  TextHelper(text: 'ID'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextHelper(text: 'Service :', width: 80),
                  TextHelper(text: 'ID'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

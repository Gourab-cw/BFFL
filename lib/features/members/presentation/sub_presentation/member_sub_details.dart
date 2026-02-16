import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';

import '../../../../core/utility/app_loader.dart';
import '../../controller/member_controller.dart';

class MemberSubDetails extends StatefulWidget {
  const MemberSubDetails({super.key});

  @override
  State<MemberSubDetails> createState() => _MemberSubDetailsState();
}

class _MemberSubDetailsState extends State<MemberSubDetails> {
  final MemberController memberController = Get.find<MemberController>();
  final loader = Get.find<AppLoaderController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemberController>(
      init: memberController,
      autoRemove: false,
      builder: (memberController) {
        UserG? user = memberController.selectedUser;
        if (user == null) {
          return Container(child: Center(child: Text("no user found")));
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    TextHelper(text: "User service category :", width: 180, fontweight: FontWeight.w600),
                    Wrap(
                      spacing: 10,
                      children: [
                        ...user.services.map(
                          ((m) => Container(
                            width: 95,
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                            child: TextHelper(text: m, fontsize: 10.5, textalign: TextAlign.center),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    TextHelper(text: "Any Medical Condition :", width: 180, fontweight: FontWeight.w600),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                      child: TextHelper(
                        text: parseString(data: user.medicalCondition, defaultValue: ""),
                        fontsize: 12,
                        isWrap: true,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    TextHelper(text: "Any Medication :", width: 180, fontweight: FontWeight.w600),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                      child: TextHelper(
                        text: parseString(data: user.medication, defaultValue: ""),
                        fontsize: 12,
                        isWrap: true,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    TextHelper(text: "Any Specific Diet :", width: 180, fontweight: FontWeight.w600),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                      child: TextHelper(
                        text: parseString(data: user.diet, defaultValue: ""),
                        fontsize: 12,
                        isWrap: true,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 3,
                  children: [
                    TextHelper(text: "Referred By :", width: 180, fontweight: FontWeight.w600),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
                      child: TextHelper(
                        text: parseString(data: user.referredByName, defaultValue: ""),
                        fontsize: 12,
                        isWrap: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

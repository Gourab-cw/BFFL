import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:moon_design/moon_design.dart';

import '../../login/repository/user_notifier.dart';

class Home extends ConsumerStatefulWidget {
  Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final MainStore mainStore = Get.find<MainStore>();
  final UserNotifier user = Get.find<UserNotifier>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.green.shade300, borderRadius: BorderRadius.circular(40)),
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.person_rounded, color: Colors.green.shade900, size: 24),
                  ),
                  TextHelper(text: "Hello, ${user.state?.name ?? ""}", fontsize: 15, fontweight: FontWeight.w600),
                ],
              ),
              ButtonHelperG(background: Colors.transparent, icon: Icon(Icons.notifications)),
            ],
          ),

          // Button Row
          Wrap(
            children: [
              ButtonHelperG(
                onTap: () {
                  Get.toNamed("/useradd");
                },
                height: 45,
                icon: Icon(MoonIcons.generic_user_24_regular, color: Colors.green.shade900, size: 28),
                label: TextHelper(text: "Add Member +", fontsize: 14, color: Colors.green.shade900, fontweight: FontWeight.w600),
                width: 200,
                background: Colors.lightGreenAccent.shade700,
              ),
              ButtonHelperG(
                withBorder: true,
                height: 45,
                type: ButtonHelperTypeG.outlined,
                icon: Icon(MoonIcons.generic_ticket_24_regular, color: Colors.green.shade900, size: 28),
                label: TextHelper(text: "Book a service", fontsize: 14, color: Colors.green.shade900, fontweight: FontWeight.w600),
                width: 200,
                background: Colors.lightGreenAccent.shade700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/app/provider.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';

import '../../../core/widget/bottom_nav_bar.dart';


class Home extends ConsumerStatefulWidget {
   Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final MainStore mainStore = Get.find<MainStore>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return AppLoader(child: Scaffold(
      bottomNavigationBar: BottomNavbar(),
      body: Padding(
        padding: EdgeInsets.only(
          top: safePadding.top,
          bottom: safePadding.bottom,
          left: safePadding.left+5,
          right: safePadding.right+5,
        ),
        child: Column(
          children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        borderRadius: BorderRadius.circular(40)
                      ),
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.person_rounded,color: Colors.green.shade900,size: 24,)),
                    TextHelper(text: "Hello, ${user?.name ?? ""}",fontsize: 15,fontweight: FontWeight.w600,),
                  ],
                ),
                ButtonHelperG(
                  background: Colors.transparent,
                  icon: Icon(Icons.notifications),
                )
              ],)
          ],
        ),
      ),
    ));
  }
}

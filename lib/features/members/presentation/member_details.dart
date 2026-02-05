import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/features/members/controller/member_controller.dart';
import 'package:moon_design/moon_design.dart';

import '../../../core/utility/helper.dart';
import '../../login/data/user.dart';

class MemberDetails extends StatefulWidget {
  const MemberDetails({super.key});

  @override
  State<MemberDetails> createState() => _MemberDetailsState();
}

class _MemberDetailsState extends State<MemberDetails> {
  final MemberController memberController = Get.find<MemberController>();
  final loader = Get.find<AppLoaderController>();
  final fb = Get.find<FB>();

  void makeApproveHandler(UserG user) async {
    try {
      loader.startLoading();
      await memberController.makeApprove(user, await fb.getDB());
      memberController.selectedUser = user.copyWith(isApproved: true);
      int index = memberController.members.indexWhere((m) => m.id == user.id);
      if (index != -1) {
        memberController.members[index] = user.copyWith(isApproved: true);
      }
      memberController.update();
      setState(() {});
    } catch (e) {
      showAlert("$e", AlertType.error);
    } finally {
      loader.stopLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    final UserG? user = memberController.selectedUser;

    return GetBuilder<MemberController>(
      init: memberController,
      autoRemove: false,
      builder: (memberController) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: TextHelper(text: "Member Details", fontsize: 15, fontweight: FontWeight.w600),
            ),
            body: Center(
              child: TextHelper(text: "No user found!", fontsize: 20, textalign: TextAlign.center),
            ),
          );
        }
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(
              title: TextHelper(text: "Member Details", fontsize: 15, fontweight: FontWeight.w600),
            ),
            body: Padding(
              padding: EdgeInsets.only(left: safePadding.left + 10, top: safePadding.top, bottom: safePadding.bottom, right: safePadding.right + 10),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(user.profileImage.isNotEmpty ? 5 : 8),
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10, offset: Offset(2, 2), spreadRadius: 1)],
                            color: Colors.green.shade50,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            clipBehavior: Clip.antiAlias,
                            child: user.profileImage.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: user.profileImage,
                                    progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                    errorWidget: (context, url, error) => Icon(MoonIcons.generic_user_24_regular),
                                    fit: BoxFit.cover,
                                  )
                                : Icon(MoonIcons.generic_user_24_regular),
                          ),
                        ),
                        if (!user.isApproved) Positioned(right: -5, top: -10, child: Icon(Icons.close, color: Colors.redAccent.shade100)),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextHelper(text: user.name, textalign: TextAlign.center, fontweight: FontWeight.w600),
                        TextHelper(text: "${user.address} ${user.city} ${user.state} ${user.country}", isWrap: true, textalign: TextAlign.center, fontsize: 12),
                        TextHelper(
                          text: "${user.mobile} ${user.mobile1.isNotEmpty ? ' / ${user.mobile1}' : ''}",
                          isWrap: true,
                          textalign: TextAlign.center,
                          fontsize: 12,
                        ),
                      ],
                    ),
                    Divider(),
                    if (!user.isApproved)
                      Column(
                        spacing: 10,
                        children: [
                          TextHelper(text: "User has not been approved", textalign: TextAlign.center, fontsize: 16, color: Colors.redAccent.shade100),
                          ButtonHelperG(
                            onTap: () {
                              makeApproveHandler(user);
                            },
                            width: 110,
                            label: TextHelper(text: "Mark as approved", fontsize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/features/members/controller/member_controller.dart';
import 'package:healthandwellness/features/members/presentation/sub_presentation/member_booking_history.dart';
import 'package:healthandwellness/features/members/presentation/sub_presentation/member_sub_details.dart';
import 'package:healthandwellness/features/user_subscription/controller/user_subscription_controller.dart';
import 'package:moon_design/moon_design.dart';

import '../../../core/Picklist/picklist_provider.dart';
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
  final picklist = Get.find<PickListNotifier>();
  final userSubController = Get.find<UserSubscriptionController>();

  final fb = Get.find<FB>();

  bool isExpanded = false;

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
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        picklist.getPickLists();
        if (memberController.selectedUser != null) {
          userSubController.getSubscriptionList(memberController.selectedUser!.id);
        }
      } catch (e) {
        showAlert("$e", AlertType.error);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    final UserG? user = memberController.selectedUser;
    final double subTextSize = 11.4;
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
              padding: EdgeInsets.only(left: safePadding.left, top: safePadding.top, bottom: safePadding.bottom, right: safePadding.right),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flex(
                              mainAxisSize: MainAxisSize.max,
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(user.profileImage.isNotEmpty ? 5 : 8),
                                  width: isExpanded ? 120 : 40,
                                  height: isExpanded ? 120 : 40,
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
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                CircularProgressIndicator(value: downloadProgress.progress),
                                            errorWidget: (context, url, error) => Icon(MoonIcons.generic_user_24_regular),
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(MoonIcons.generic_user_24_regular),
                                  ),
                                ),
                                SizedBox(
                                  width: isExpanded ? MediaQuery.sizeOf(context).width - 150 : MediaQuery.sizeOf(context).width - 60,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: isExpanded ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          if (isExpanded) TextHelper(text: "Name :", fontweight: FontWeight.w600, width: 60, fontsize: 12),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextHelper(text: user.name, textalign: TextAlign.left, fontweight: FontWeight.w600),
                                              if (!isExpanded)
                                                TextHelper(text: user.address, textalign: TextAlign.left, fontsize: 11, fontweight: FontWeight.w400),
                                            ],
                                          ),
                                          Spacer(),
                                          if (!user.isApproved && !isExpanded)
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ButtonHelperG(
                                                  margin: 0,
                                                  onTap: () {
                                                    makeApproveHandler(user);
                                                  },
                                                  width: 110,
                                                  height: 35,
                                                  label: TextHelper(text: "Make Approved", fontsize: 11, color: Colors.white),
                                                ),
                                                TextHelper(
                                                  width: 80,
                                                  text: "Not Approved",
                                                  textalign: TextAlign.center,
                                                  fontsize: 10.5,
                                                  color: Colors.redAccent.shade200,
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      if (isExpanded)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                TextHelper(text: "Address :", fontweight: FontWeight.w600, width: 60, fontsize: subTextSize),
                                                Expanded(
                                                  child: TextHelper(
                                                    text: "${user.address} ${user.city} ${user.state} ${user.country}",
                                                    isWrap: true,
                                                    textalign: TextAlign.start,
                                                    fontsize: subTextSize,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                TextHelper(text: "Mobile :", fontweight: FontWeight.w600, width: 60, fontsize: subTextSize),
                                                TextHelper(
                                                  text: "${user.mobile} ${user.mobile1.isNotEmpty ? ' / ${user.mobile1}' : ''}",
                                                  isWrap: true,
                                                  textalign: TextAlign.center,
                                                  fontsize: subTextSize,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                TextHelper(text: "Mail :", fontweight: FontWeight.w600, width: 60, fontsize: subTextSize),
                                                TextHelper(text: user.mail, isWrap: true, textalign: TextAlign.center, fontsize: subTextSize),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    TextHelper(text: "Age :", fontweight: FontWeight.w600, width: 60, fontsize: subTextSize),
                                                    TextHelper(text: user.age, isWrap: true, textalign: TextAlign.center, fontsize: subTextSize),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    TextHelper(text: "Blood Group :", fontweight: FontWeight.w600, width: 80, fontsize: subTextSize),
                                                    TextHelper(
                                                      text: picklist.getBloodGroupPicklist().firstWhereOrNull((f) => f['id'] == user.bgId)?['name'] ?? "",
                                                      isWrap: true,
                                                      textalign: TextAlign.center,
                                                      fontsize: subTextSize,
                                                      width: 45,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    TextHelper(text: "Gender :", fontweight: FontWeight.w600, width: 60, fontsize: subTextSize),
                                                    TextHelper(
                                                      text: picklist.getGenderPicklist().firstWhereOrNull((f) => f['id'] == user.genderId)?['name'] ?? "",
                                                      isWrap: true,
                                                      textalign: TextAlign.center,
                                                      fontsize: subTextSize,
                                                      width: 45,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    TextHelper(text: "Height :", fontweight: FontWeight.w600, width: 80, fontsize: subTextSize),
                                                    TextHelper(text: user.height, isWrap: true, textalign: TextAlign.center, fontsize: subTextSize, width: 45),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                TextHelper(text: "Body Weight :", fontweight: FontWeight.w600, width: 80, fontsize: subTextSize),
                                                TextHelper(text: user.bodyWeight, isWrap: true, textalign: TextAlign.center, fontsize: subTextSize),
                                              ],
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Divider(),
                          if (!user.isApproved && isExpanded)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 10,
                              children: [
                                TextHelper(text: "Not approved", textalign: TextAlign.center, fontsize: 14, color: Colors.redAccent.shade100),
                                ButtonHelperG(
                                  onTap: () {
                                    makeApproveHandler(user);
                                  },
                                  width: 110,
                                  label: TextHelper(text: "Make Approved", fontsize: 11, color: Colors.white),
                                ),
                              ],
                            ),
                          TabBar(
                            tabs: [
                              Tab(child: Text('Details', style: TextStyle(fontSize: 12))),
                              Tab(child: Text('Booking History', style: TextStyle(fontSize: 12))),
                              Tab(child: Text('Payment Details', style: TextStyle(fontSize: 12))),
                            ],
                          ),
                          Expanded(child: TabBarView(children: [MemberSubDetails(), MemberBookingHistory(), Container()])),
                        ],
                      ),
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

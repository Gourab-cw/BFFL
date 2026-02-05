import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/members/controller/member_controller.dart';
import 'package:moon_design/moon_design.dart';

import '../../../core/utility/firebase_service.dart';
import '../../../core/utility/helper.dart';

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final MainStore mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final FB fb = Get.find<FB>();
  final MemberController memberController = Get.find<MemberController>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      loader.startLoading();
      await memberController.fetchMembers(await fb.getDB());
      loader.stopLoading();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    return GetBuilder<MemberController>(
      init: memberController,
      autoRemove: false,
      builder: (memberController) {
        return Scaffold(
          appBar: AppBar(
            title: TextHelper(text: "Member List", fontsize: 15, fontweight: FontWeight.w600),
          ),
          body: Padding(
            padding: EdgeInsets.only(left: safePadding.left + 10, top: safePadding.top, bottom: safePadding.bottom, right: safePadding.right + 10),
            child: Column(
              spacing: 10,
              children: [
                const SizedBox(height: 5),
                Obx(
                  () => TextBox(
                    borderRadius: 40,
                    leftPadding: 20,
                    placeholder: "Search member",
                    fontSize: 13,
                    leading: Icon(MoonIcons.generic_search_24_regular, color: Colors.grey),
                    controller: memberController.search,
                    onValueChange: (v) async {
                     try{
                       await memberController.searchMembers(await fb.getDB());
                     }catch(e){
                       showAlert("$e", AlertType.error);
                     }
                    },
                    trailing: !memberController.isSearching.value
                        ? null
                        : SizedBox(
                            height: 38,
                            width: 40,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey, padding: EdgeInsets.all(8)),
                          ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: memberController.members.length,
                    itemBuilder: (ctx, index) {
                      UserG user = memberController.members[index];
                      return GestureDetector(
                        onTap: () {
                          memberController.selectedUser = user;
                          memberController.update();
                          Get.toNamed('/memberdetails');
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: !user.isApproved ? Colors.blueGrey.shade100.withAlpha(100) : Colors.green.shade100.withAlpha(60),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            spacing: 5,
                            children: [
                              Container(
                                padding: EdgeInsets.all(user.profileImage.isNotEmpty ? 1 : 8),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: user.isApproved ? Colors.green.shade200 : Colors.blueGrey.shade200.withAlpha(100),
                                ),
                                child: user.profileImage.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: user.profileImage,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              CircularProgressIndicator(value: downloadProgress.progress, color: Colors.grey, padding: EdgeInsets.all(10)),
                                          errorWidget: (context, url, error) => Icon(MoonIcons.generic_user_24_regular),

                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(MoonIcons.generic_user_24_regular),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextHelper(text: user.name, fontsize: 13, fontweight: FontWeight.w500),
                                    TextHelper(text: "${user.address}, ${user.pincode}, ${user.city}", fontsize: 11.5, color: Colors.blueGrey.shade500),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

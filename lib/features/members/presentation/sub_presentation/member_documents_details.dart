import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../app/mainstore.dart';
import '../../../../core/utility/app_loader.dart';
import '../../../../core/utility/firebase_service.dart';
import '../../../../core/utility/helper.dart';
import '../../../login/data/user.dart';
import '../../controller/member_controller.dart';

class MemberDocumentsDetails extends StatefulWidget {
  const MemberDocumentsDetails({super.key});

  @override
  State<MemberDocumentsDetails> createState() => _MemberDocumentsDetailsState();
}

class _MemberDocumentsDetailsState extends State<MemberDocumentsDetails> {
  final MemberController memberController = Get.find<MemberController>();
  final mainStore = Get.find<MainStore>();
  final auth = Get.find<Authenticator>();
  final loader = Get.find<AppLoaderController>();
  Future<void> showImage(dynamic data) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: MediaQuery.of(context).size.height - 90,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Builder(
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: getMainStore().theme.value.lowShadeColor),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonHelperG(
                            onTap: () {
                              goBack(context);
                            },
                            borderRadius: 30,
                            width: 22,
                            height: 22,
                            background: getMainStore().theme.value.HeadColor,
                            icon: Icon(Icons.close, color: Colors.white, size: 12),
                          ),
                          if (data is XFile)
                            ButtonHelperG(
                              onTap: () {
                                memberController.selectedUser!.documents.remove(data);
                                memberController.update();
                                goBack(context);
                              },
                              borderRadius: 5,
                              width: 82,
                              height: 32,
                              background: getMainStore().theme.value.HeadColor.withAlpha(40),
                              label: TextHelper(text: "Delete"),
                              icon: Icon(Icons.delete, color: getMainStore().theme.value.HeadColor, size: 20),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 140,
                        child: data is String
                            ? PhotoView(
                                imageProvider: NetworkImage(data),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 4,
                              )
                            : data is XFile
                            ? PhotoView(
                                imageProvider: FileImage(File(data.path)),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 4,
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> chooseImage() async {
    if (memberController.selectedUser == null) {
      return;
    }
    ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
    if (images.isEmpty) {
      return;
    }
    for (final image in images) {
      if (!memberController.selectedUser!.documents.any((a) => a == image.path)) {
        memberController.selectedUser!.documents.add(image);
      }
    }
    memberController.update();
  }

  Future<void> updateUserDocumentImage(XFile data) async {
    try {
      if (memberController.selectedUser == null) {
        return;
      }
      loader.startLoading();
      await memberController.updateMembersDocumentImage(data, await Get.find<FB>().getDB());
    } catch (e) {
      showAlert("$e", AlertType.error);
    } finally {
      loader.stopLoading();
    }
  }

  bool canAddDocument() {
    final user = auth.state;
    if (user == null) {
      return false;
    }
    if (user.userType == UserType.branchManager || user.userType == UserType.admin || user.userType == UserType.receptionist) {
      return true;
    } else {
      return false;
    }
  }

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
        int i = 0;
        return Container(
          padding: EdgeInsets.all(10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (canAddDocument())
                GestureDetector(
                  onTap: () async {
                    try {
                      await chooseImage();
                    } catch (e) {
                      showAlert('$e', AlertType.error);
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(color: getMainStore().theme.value.mediumShadeColor, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 18),
                        TextHelper(text: "Add", textalign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ...user.documents.map((m) {
                if (m is String && m.isNotEmpty) {
                  i++;
                  return GestureDetector(
                    onTap: () {
                      showImage(m);
                    },
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: EdgeInsets.all(3),
                        width: 90,
                        height: 80,
                        // child: Text("data"),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4,
                          children: [
                            SizedBox(
                              width: 12,
                              height: 8,
                              child: TextHelper(
                                text: "${i.toString()} .",
                                fontsize: 11,
                                color: getMainStore().theme.value.HeadColor,
                                fontweight: FontWeight.w600,
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: m,
                                fit: BoxFit.fill,
                                height: 80,
                                width: 70,
                                placeholder: (context, url) => Center(child: Transform.scale(scale: 0.6, child: CircularProgressIndicator())),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (m is XFile) {
                  i++;
                  return GestureDetector(
                    onTap: () {
                      showImage(m);
                    },
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: EdgeInsets.all(3),
                        width: 90,
                        height: 80,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  SizedBox(
                                    width: 12,
                                    height: 8,
                                    child: TextHelper(
                                      text: "${i.toString()} .",
                                      fontsize: 11,
                                      color: getMainStore().theme.value.HeadColor,
                                      fontweight: FontWeight.w600,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(File(m.path), fit: BoxFit.fill, height: 80, width: 70),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            updateUserDocumentImage(m);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 65,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withAlpha(200),
                                              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.upload, color: getMainStore().theme.value.HeadColor, size: 18),
                                                TextHelper(
                                                  text: "Upload",
                                                  fontsize: 10,
                                                  fontweight: FontWeight.w600,
                                                  color: getMainStore().theme.value.HeadColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -10,
                              right: -10,
                              child: ButtonHelperG(
                                onTap: () {
                                  memberController.selectedUser!.documents.remove(m);
                                  memberController.update();
                                },
                                borderRadius: 5,
                                width: 22,
                                height: 22,
                                background: getMainStore().theme.value.HeadColor.withAlpha(40),
                                icon: Icon(Icons.delete, color: getMainStore().theme.value.HeadColor, size: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
            ],
          ),
        );
      },
    );
  }
}

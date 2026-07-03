import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../../../app/mainstore.dart';
import '../../../core/utility/helper.dart';
import '../../login/data/user.dart';
import '../controller/new_user_form_controller.dart';

class DocumentSection extends StatefulWidget {
  const DocumentSection({super.key});

  @override
  State<DocumentSection> createState() => _DocumentSectionState();
}

class _DocumentSectionState extends State<DocumentSection> {
  final NewUserFormController c = Get.find<NewUserFormController>();
  final auth = Get.find<Authenticator>();

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
                          ButtonHelperG(
                            onTap: () {
                              c.documents.remove(data);
                              c.update();
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
    ImagePicker picker = ImagePicker();
    List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
    if (images.isEmpty) {
      return;
    }
    for (final image in images) {
      if (!c.documents.any((a) => a == image.path)) {
        c.documents.add(image);
      }
    }
    c.update();
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
    if (!canAddDocument()) {
      return SizedBox.shrink();
    }
    return Column(
      spacing: 5,
      children: [
        TextHelper(text: "Documents", fontweight: FontWeight.w600),
        Row(
          children: [
            GestureDetector(
              onTap: () async {
                try {
                  await chooseImage();
                } catch (e) {
                  showAlert('$e', AlertType.error);
                }
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(color: getMainStore().theme.value.mediumShadeColor.withAlpha(100), borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.image, size: 20, color: getMainStore().theme.value.secondaryColor),
                      Icon(Icons.add, size: 15, color: getMainStore().theme.value.secondaryColor.withAlpha(200)),
                    ],
                  ),
                ),
              ),
            ),
            GetBuilder<NewUserFormController>(
              init: c,
              autoRemove: false,
              builder: (c) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Row(
                      children: c.documents.map((cItem) {
                        if (cItem is String) {
                          return GestureDetector(
                            onTap: () async {
                              await showImage(cItem);
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: 70,
                                  height: 70,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: getMainStore().theme.value.mediumShadeColor.withAlpha(100),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network(cItem),
                                ),
                                Positioned(
                                  top: -10,
                                  right: -10,
                                  child: ButtonHelperG(
                                    onTap: () {
                                      c.documents.remove(cItem);
                                      c.update();
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
                          );
                        }
                        if (cItem is XFile) {
                          return GestureDetector(
                            onTap: () async {
                              await showImage(cItem);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              // padding: EdgeInsets.all(5),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: getMainStore().theme.value.mediumShadeColor.withAlpha(100),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.file(File(cItem.path), fit: BoxFit.fill, width: 70),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -10,
                                    child: ButtonHelperG(
                                      onTap: () {
                                        c.documents.remove(cItem);
                                        c.update();
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
                          );
                        }
                        return SizedBox.shrink();
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

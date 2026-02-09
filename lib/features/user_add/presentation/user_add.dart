import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/Picklist/picklist_provider.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/user_add/controller/new_user_form_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

class UserAdd extends StatefulWidget {
  const UserAdd({super.key});

  @override
  State<UserAdd> createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  final NewUserFormController c = Get.find<NewUserFormController>();
  final AppLoaderController loaderController = Get.find<AppLoaderController>();
  final PickListNotifier picklistNotifierRef = Get.find<PickListNotifier>();
  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        loaderController.startLoading();
        await picklistNotifierRef.getPickLists();
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        loaderController.stopLoading();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade300,
          title: TextHelper(text: "Add Member", fontsize: 18),
          actions: [
            ButtonHelperG(
              onTap: () async {
                try {
                  loaderController.startLoading();
                  await c.saveNewMember();
                  showAlert("Successful", AlertType.success);
                } catch (e) {
                  showAlert("$e", AlertType.error);
                } finally {
                  loaderController.stopLoading();
                }
              },
              width: 80,
              shadow: [],
              background: Colors.white,
              label: TextHelper(text: "Save", fontsize: 14),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: GetBuilder<PickListNotifier>(
            init: picklistNotifierRef,
            autoRemove: false,
            builder: (picklistNotifierRef) {
              return GetBuilder<NewUserFormController>(
                init: c,
                autoRemove: false,
                builder: (c) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            ImagePicker picker = ImagePicker();
                            XFile? image;
                            if (GetPlatform.isWindows) {
                              FilePickerResult? f = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);
                              if (f != null && f.xFiles.isNotEmpty) {
                                image = f.xFiles[0];
                              }
                            } else {
                              image = await picker.pickImage(
                                source: ImageSource.camera,
                                maxHeight: 1020,
                                maxWidth: 1380,
                                imageQuality: 80,
                                preferredCameraDevice: CameraDevice.front,
                              );
                            }
                            if (image != null) {
                              c.image = image;
                              c.update();
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            clipBehavior: Clip.hardEdge,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(color: Colors.green.shade50),
                              child: c.image == null
                                  ? Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera_alt, color: Colors.grey[700]),
                                          TextHelper(text: "Click to select image", textalign: TextAlign.center),
                                        ],
                                      ),
                                    )
                                  : Image.file(File(c.image!.path), fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Divider(color: Colors.blueGrey.shade100),
                        MoonAccordion(
                          autofocus: false,
                          hasContentOutside: true,
                          propagateGesturesToChild: true,
                          expandedBackgroundColor: Colors.green.shade100,
                          backgroundColor: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(0),
                          showBorder: false,
                          childrenPadding: EdgeInsets.all(10),
                          shadows: [],
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(MoonIcons.generic_user_24_regular),
                              TextHelper(text: "Member Info", fontsize: 14, fontweight: FontWeight.w600),
                            ],
                          ),
                          children: [
                            Row(
                              children: [
                                TextHelper(text: "Name :", width: 50, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.name, placeholder: "", width: 260),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "DOB :", width: 50, fontsize: 13, fontweight: FontWeight.w600),
                                DatePickerHelper(
                                  height: 40,
                                  withBorder: true,
                                  width: 140,
                                  dateFormat: 'dd-MM-yyyy',
                                  value: parseStringToEmptyDate(data: c.dob, predefinedDateFormat: "dd-MM-yyyy", defaultValue: null),
                                  onValueChange: (v) {
                                    c.dob = v;
                                    DateTime? d = parseStringToEmptyDate(data: v, predefinedDateFormat: "dd-MM-yyyy", defaultValue: null);
                                    if (d != null) {
                                      c.age.text = (DateTime.now().difference(d).inDays / 365).toStringAsFixed(0);
                                    }
                                    c.update();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Age :", width: 50, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(
                                  controller: c.age,
                                  placeholder: "",
                                  width: 140,
                                  keyboard: TextInputType.numberWithOptions(),
                                  onValueChange: (v) {
                                    int age = parseInt(data: v, defaultInt: 0);
                                    if (age > 0) {
                                      DateTime dob = DateTime(DateTime.now().year - age, 1, 1);
                                      c.dob = DateFormat('yyyy-MM-dd').format(dob);
                                      c.update();
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  TextHelper(text: "Gender :", width: 90, fontsize: 13, fontweight: FontWeight.w600),
                                  SizedBox(
                                    width: 140,
                                    child: DropDownHelperG(
                                      height: 40,
                                      leading: SizedBox.shrink(),
                                      uniqueKey: UniqueKey().toString(),
                                      placeHolder: "",
                                      value: c.genderId,
                                      onValueChange: (v) {
                                        c.genderId = v;
                                        c.update();
                                      },
                                      items: picklistNotifierRef.getGenderPicklist(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  TextHelper(text: "Blood Group :", width: 90, fontsize: 13, fontweight: FontWeight.w600),
                                  SizedBox(
                                    width: 140,
                                    child: DropDownHelperG(
                                      height: 40,
                                      leading: SizedBox.shrink(),
                                      uniqueKey: UniqueKey().toString(),
                                      value: c.bloodGroupId,
                                      onValueChange: (v) {
                                        c.bloodGroupId = v;
                                        c.update();
                                      },
                                      items: picklistNotifierRef.getBloodGroupPicklist(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Height :", width: 90, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.height, placeholder: "", showAlwaysLabel: true, width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Body Weight :", width: 90, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.weight, placeholder: "", width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Divider(),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Email :", width: 90, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.email, placeholder: "", width: 240),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Contact No. :", width: 90, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.mobile, placeholder: "", width: 240),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Emergency No. :", width: 90, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.mobile1, placeholder: "", showAlwaysLabel: true, width: 240),
                              ],
                            ),
                          ],
                        ),
                        MoonAccordion(
                          hasContentOutside: true,
                          propagateGesturesToChild: true,
                          expandedBackgroundColor: Colors.green.shade100,
                          backgroundColor: Colors.blueGrey.shade50,
                          borderRadius: BorderRadius.circular(0),
                          showBorder: false,
                          childrenPadding: EdgeInsets.all(10),
                          showDivider: true,
                          shadows: [],
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(MoonIcons.generic_home_24_regular),
                              TextHelper(text: "Member Address", fontsize: 14, fontweight: FontWeight.w600),
                            ],
                          ),
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextHelper(text: "Address :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                SizedBox(
                                  height: 100,
                                  width: 250,
                                  child: TextAreaBox(height: 100, borderRadius: BorderRadius.circular(8), controller: c.address, placeholder: ""),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Pincode :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.pincode, placeholder: "", width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "City :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.city, placeholder: "", width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "State :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.state, placeholder: "", width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Nationality :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.nationality, placeholder: "", width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Country :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.country, placeholder: "", width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Profession :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.profession, placeholder: "", width: 140),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  TextHelper(text: "Marital Status :", width: 100, fontsize: 13, fontweight: FontWeight.w600),
                                  SizedBox(
                                    width: 140,
                                    child: DropDownHelperG(
                                      height: 40,
                                      leading: SizedBox.shrink(),
                                      uniqueKey: UniqueKey().toString(),
                                      placeHolder: "",
                                      value: c.maritalStatusId,
                                      onValueChange: (v) {
                                        c.maritalStatusId = v;
                                        c.update();
                                      },
                                      dropDownPosition: MoonDropdownAnchorPosition.top,
                                      followerAnchor: Alignment.bottomCenter,
                                      items: picklistNotifierRef.getMaritalStatusPicklist(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        MoonAccordion(
                          hasContentOutside: true,
                          expandedBackgroundColor: Colors.green.shade100,
                          backgroundColor: Colors.blueGrey.shade50,
                          propagateGesturesToChild: true,
                          borderRadius: BorderRadius.circular(0),
                          showBorder: false,
                          childrenPadding: EdgeInsets.all(10),
                          shadows: [],
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(MoonIcons.generic_info_24_regular),
                              TextHelper(text: "Member Details", fontsize: 14, fontweight: FontWeight.w600),
                            ],
                          ),
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextHelper(text: "Which BFLL service you would like to go for?", fontsize: 13, fontweight: FontWeight.w600),
                                Wrap(
                                  spacing: 20,
                                  runSpacing: 10,
                                  children: [
                                    ...picklistNotifierRef.getUserServicePicklist().map((m) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          MoonCheckbox(
                                            activeColor: Colors.green,
                                            value: c.services.contains(parseString(data: m["id"], defaultValue: "")),
                                            onChanged: (v) {
                                              String data = parseString(data: m["id"], defaultValue: "");
                                              if (parseBool(data: v, defaultValue: false)) {
                                                !c.services.contains(data) ? c.services.add(data) : null;
                                              } else {
                                                c.services.contains(data) ? c.services.remove(data) : null;
                                              }
                                              c.update();
                                            },
                                          ),
                                          TextHelper(
                                            text: parseString(data: m["name"], defaultValue: ""),
                                            fontsize: 12.5,
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              spacing: 2,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextHelper(
                                  text: "Do you have any existing medical condition? If yes, please provide details.",
                                  isWrap: true,
                                  fontsize: 13,
                                  fontweight: FontWeight.w600,
                                ),
                                TextAreaBox(controller: c.medicalCondition, placeholder: "", height: 80, borderRadius: BorderRadius.circular(8)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              spacing: 2,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextHelper(
                                  text: "Do you follow any medication? If yes please provide details.",
                                  isWrap: true,
                                  fontsize: 13,
                                  fontweight: FontWeight.w600,
                                ),
                                TextAreaBox(controller: c.medication, placeholder: "", height: 80, borderRadius: BorderRadius.circular(8)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              spacing: 2,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextHelper(
                                  text: "Do you have any physical exercise? If yes please provide details.",
                                  isWrap: true,
                                  fontsize: 13,
                                  fontweight: FontWeight.w600,
                                ),
                                TextAreaBox(controller: c.physicalExercise, placeholder: "", height: 80, borderRadius: BorderRadius.circular(8)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2,
                              children: [
                                TextHelper(
                                  text: "Do you have experience any specific diet? If so, please provide details :",
                                  isWrap: true,
                                  fontsize: 13,
                                  fontweight: FontWeight.w600,
                                ),
                                TextAreaBox(controller: c.diet, placeholder: "", height: 80, borderRadius: BorderRadius.circular(8)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  TextHelper(text: "Referred By :", width: 140, fontsize: 13, fontweight: FontWeight.w600),
                                  SizedBox(
                                    width: 240,
                                    child: DropDownHelperG(
                                      height: 40,
                                      leading: SizedBox.shrink(),
                                      uniqueKey: UniqueKey().toString(),
                                      placeHolder: "",
                                      value: c.referredById,
                                      onValueChange: (v) {
                                        c.referredById = v;
                                        c.update();
                                      },
                                      dropDownPosition: MoonDropdownAnchorPosition.top,
                                      followerAnchor: Alignment.bottomCenter,
                                      items: picklistNotifierRef.getReferredPicklist(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextHelper(text: "Referred By Name :", width: 140, fontsize: 13, fontweight: FontWeight.w600),
                                TextBox(controller: c.referredByName, placeholder: "", width: 240),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

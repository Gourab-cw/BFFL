import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/slot_details_trainer/controller/slot_details_controller.dart';

import '../../login/data/user.dart';
import '../../slot_manage/data/slot_making_model.dart';

Future<void> trainerChangePopup({required BuildContext context, required SlotModel slot, required String serviceName}) async {
  final mainStore = Get.find<MainStore>();
  final slotDetailsController = Get.find<SlotDetailsController>();
  final AppLoaderController loader = Get.find<AppLoaderController>();
  final remarks = TextEditingController();
  showAdaptiveDialog(
    context: context,
    builder: (_) {
      String selectedTrainer = '';
      String selectedTrainerName = '';
      String selectedTrainerToken = '';
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
          width: 300,
          height: 350,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHelper(text: "Trainer Change", fontweight: FontWeight.w600, fontsize: 14),
                        TextHelper(text: "Select a trainer to continue", fontsize: 11, color: mainStore.theme.value.LightTextColor.withAlpha(180)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close, color: mainStore.theme.value.HeadColor, size: 16),
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                      future: Future(() async {
                        final sc = Get.find<SlotDetailsController>();
                        List<UserG> users = await sc.getOtherTrainers(slot);
                        return users;
                      }),
                      builder: (ctx, data) {
                        if (data.connectionState == ConnectionState.waiting) {
                          return TextHelper(text: "Please wait..");
                        }
                        if (data.hasData && data.data != null) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: data.data!.map<Widget>((user) {
                                  return ListTile(
                                    title: TextHelper(text: user.name, color: user.id == selectedTrainer ? mainStore.theme.value.BackgroundColor : null),
                                    leading: Icon(
                                      FontAwesomeIcons.userDoctor,
                                      color: user.id == selectedTrainer ? mainStore.theme.value.BackgroundColor : null,
                                      size: 16,
                                    ),
                                    selected: user.id == selectedTrainer,
                                    selectedTileColor: mainStore.theme.value.HeadColor.withAlpha(180),
                                    onTap: () {
                                      setState(() {
                                        selectedTrainer = user.id;
                                        selectedTrainerName = user.name;
                                        selectedTrainerToken = user.token;
                                      });
                                    },
                                  );
                                }).toList(),
                              );
                            },
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                Divider(),
                TextBox(labelText: "Remarks", showAlwaysLabel: true, controller: remarks),
                ButtonHelperG(
                  onTap: () async {
                    if (selectedTrainer.isEmpty) {
                      showAlert("Please select a trainer to continue!", AlertType.error);
                      return;
                    }
                    if (remarks.text.isEmpty) {
                      showAlert("Please enter remarks!", AlertType.error);
                      return;
                    }
                    try {
                      loader.startLoading();
                      await slotDetailsController.updateSlotData(slot, serviceName, selectedTrainer, selectedTrainerName, selectedTrainerToken, remarks.text);
                    } catch (e) {
                      showAlert("$e", AlertType.error);
                    } finally {
                      loader.stopLoading();
                    }
                  },
                  height: 32,
                  label: TextHelper(text: "Update", color: mainStore.theme.value.BackgroundColor),
                  width: 120,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

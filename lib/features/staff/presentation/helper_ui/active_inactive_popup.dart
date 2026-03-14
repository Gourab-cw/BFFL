import 'package:flutter/material.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/data/user.dart';
import 'package:healthandwellness/features/staff/controller/staff_controller.dart';

import '../../../../core/utility/app_loader.dart';

Future<void> makeActiveInactive(BuildContext context, UserG user, StaffController staffController) async {
  await showAdaptiveDialog(
    context: context,
    builder: (_) {
      return AppLoader(
        child: Dialog(
          child: SizedBox(
            height: 150,
            width: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextHelper(text: 'Change user status', textalign: TextAlign.center, fontweight: FontWeight.w600),
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextHelper(text: 'Status : ', textalign: TextAlign.center, fontsize: 12),

                      TextHelper(text: user.isActive ? 'Active' : 'Inactive', textalign: TextAlign.center, fontsize: 13, fontweight: FontWeight.w600),
                      const SizedBox(width: 10),
                      Icon(Icons.circle, color: user.isActive ? Colors.green : Colors.red, size: 13),
                    ],
                  ),
                  Spacer(),
                  ButtonHelperG(
                    width: 100,
                    height: 30,
                    onTap: () async {
                      try {
                        Loader.startLoading();
                        await staffController.makeActiveInactive(user);
                        goBack(context);
                      } catch (e) {
                        showAlert('$e', AlertType.error);
                      } finally {
                        Loader.stopLoading();
                      }
                    },
                    label: TextHelper(text: "Change", color: getMainStore().theme.value.DarkTextColor),
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

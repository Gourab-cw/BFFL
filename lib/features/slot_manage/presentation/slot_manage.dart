import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/Datagrid3.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/slot_manage/controller/slot_manage_controller.dart';
import 'package:healthandwellness/features/slot_manage/presentation/slot_add_popup.dart';
import 'package:healthandwellness/features/slot_manage/presentation/slot_add_popup_weekly.dart';
import 'package:healthandwellness/features/subscriptions/controller/subscription_controller.dart';
import 'package:intl/intl.dart';

import '../../../core/utility/app_loader.dart';
import '../../../core/utility/helper.dart';
import '../../Service/data/service.dart';

class SlotManage extends StatefulWidget {
  const SlotManage({super.key});

  @override
  State<SlotManage> createState() => _SlotManageState();
}

class _SlotManageState extends State<SlotManage> {
  final MainStore mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final fb = Get.find<FB>();
  final Authenticator authenticator = Get.find<Authenticator>();
  final SlotController slotController = Get.find<SlotController>();
  final SubscriptionController subscriptionController =
      Get.find<SubscriptionController>();

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      loader.startLoading();
      try {
        await subscriptionController.fetchSubscription(await fb.getDB());
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        loader.stopLoading();
      }
    });
    super.initState();
  }

  Future<void> handleFillSlotClick() async {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    await showAdaptiveDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: isMobile ? screenWidth * 0.9 : 360,
            padding: EdgeInsets.all(isMobile ? 14.0 : 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF4F46E5),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Quick Fill Slots',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Choose a template to populate slots',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => goBack(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF94A3B8),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),
                _buildFillOptionCard(
                  icon: Icons.calendar_month_rounded,
                  iconColor: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFF0F9FF),
                  title: 'Fill From Last Month',
                  subtitle: 'Copy all slot schedules from previous month',
                  onTap: () async {
                    try {
                      loader.startLoading();
                      await slotController.slotDataFeelFromLastMonth();
                      subscriptionController.update();
                      goBack(context);
                    } catch (e) {
                      showAlert('$e', AlertType.error);
                    } finally {
                      loader.stopLoading();
                    }
                  },
                ),
                const SizedBox(height: 10),
                _buildFillOptionCard(
                  icon: Icons.date_range_rounded,
                  iconColor: const Color(0xFF10B981),
                  bgColor: const Color(0xFFECFDF5),
                  title: 'Fill From Last Weeks',
                  subtitle: 'Duplicate recurring weekly slot structure',
                  onTap: () async {
                    goBack(context);
                    await slotAddPopupWeekly(context);
                  },
                ),
                const SizedBox(height: 10),
                _buildFillOptionCard(
                  icon: Icons.event_repeat_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  bgColor: const Color(0xFFF5F3FF),
                  title: 'Fill From a Specific Date',
                  subtitle: 'Copy slots directly from any target date',
                  onTap: () async {
                    goBack(context);
                    await slotAddPopupByDate(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFillOptionCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 650;

    return GetBuilder<SlotController>(
      init: slotController,
      autoRemove: false,
      builder: (slotController) {
        return AppLoader(
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              // backgroundColor: const Color(0xFF0F172A),
              elevation: 0,
              title: Row(
                children: [
                  const Icon(
                    Icons.edit_calendar_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Slot Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 16 : 18,
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ButtonHelperG(
                    onTap: () async {
                      loader.startLoading();
                      try {
                        final db = await fb.getDB();
                        await slotController.saveSlots(
                          db,
                          authenticator.state!,
                        );
                        slotController.slots = [];
                        await slotController.slotDataFeel();
                        slotController.update();
                        showAlert(
                          "Slots saved successfully!",
                          AlertType.success,
                        );
                      } catch (e) {
                        showAlert("$e", AlertType.error);
                      } finally {
                        loader.stopLoading();
                      }
                    },
                    icon: const Icon(
                      Icons.save_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    label: TextHelper(
                      text: "Save",
                      color: Colors.white,
                      fontsize: isMobile ? 12 : 13,
                      fontweight: FontWeight.w600,
                    ),
                    background: const Color(0xFF2563EB),
                    shadow: [],
                    height: 34,
                    width: isMobile ? 74 : 90,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(
                left: safePadding.left + (isMobile ? 8 : 12),
                top: safePadding.top + (isMobile ? 8 : 12),
                bottom: safePadding.bottom + (isMobile ? 8 : 12),
                right: safePadding.right + (isMobile ? 8 : 12),
              ),
              child: Column(
                children: [
                  // --- TOP CONTROL CARD (RESPONSIVE) ---
                  Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isMobile) ...[
                          // --- MOBILE CONTROLS LAYOUT ---
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: DropDownHelperG(
                                  uniqueKey: "MonthPick",
                                  showLabelAlways: false,
                                  height: 36,
                                  showClearText: false,
                                  valueKey: "id",
                                  displayKey: "value",
                                  isSearchEnable: true,
                                  lightModeBackgroundColor: Colors.white,
                                  value: slotController.month == null
                                      ? {}
                                      : {
                                          "id": slotController.month?.month,
                                          "value": DateFormat(
                                            "MMMM",
                                          ).format(slotController.month!),
                                        },
                                  onValueChange: (v) {
                                    slotController.month = DateTime(
                                      slotController.month?.year ??
                                          DateTime.now().year,
                                      parseInt(data: v['id'], defaultInt: 1),
                                      1,
                                    );
                                    slotController.update();
                                  },
                                  items: List.generate(
                                    12,
                                    (index) => ({
                                      "id": index + 1,
                                      "value": DateFormat(
                                        "MMMM",
                                      ).format(DateTime(2026, index + 1)),
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                flex: 2,
                                child: DropDownHelperG(
                                  uniqueKey: "YearPick",
                                  showLabelAlways: false,
                                  height: 36,
                                  showClearText: false,
                                  valueKey: "id",
                                  displayKey: "value",
                                  isSearchEnable: true,
                                  lightModeBackgroundColor: Colors.white,
                                  value: slotController.month == null
                                      ? {}
                                      : {
                                          "id": slotController.month?.year,
                                          "value": slotController.month?.year,
                                        },
                                  onValueChange: (v) {
                                    slotController.month = DateTime(
                                      parseInt(data: v['id']),
                                      parseInt(
                                        data: slotController.month?.month,
                                        defaultInt: 1,
                                      ),
                                      1,
                                    );
                                    slotController.update();
                                  },
                                  items: List.generate(
                                    200,
                                    (index) => ({
                                      "id": 2000 + index,
                                      "value": DateFormat(
                                        "yyyy",
                                      ).format(DateTime(2000 + index, 1)),
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              ButtonHelperG(
                                onTap: () async {
                                  try {
                                    loader.startLoading();
                                    await slotController.slotDataFeel();
                                  } catch (e) {
                                    showAlert("$e", AlertType.error);
                                  } finally {
                                    loader.stopLoading();
                                  }
                                },
                                height: 36,
                                width: 72,
                                icon: const Icon(
                                  Icons.cloud_download_rounded,
                                  color: Colors.white,
                                  size: 14,
                                ),
                                label: TextHelper(
                                  text: "Slots",
                                  color: Colors.white,
                                  fontsize: 11.5,
                                  fontweight: FontWeight.w600,
                                ),
                                background: const Color(0xFF0284C7),
                                margin: 0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ButtonHelperG(
                            onTap: () async {
                              await handleFillSlotClick();
                            },
                            height: 36,
                            width: double.infinity,
                            margin: 0,
                            type: ButtonHelperTypeG.outlined,
                            icon: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Color(0xFF4F46E5),
                              size: 15,
                            ),
                            label: TextHelper(
                              text: "Quick Fill Slots Template",
                              // color: const Color(0xFF4F46E5),
                              fontsize: 12,
                              fontweight: FontWeight.w600,
                            ),
                            // borderColor: const Color(0xFF6366F1),
                            background: const Color(0xFFEEF2FF),
                          ),
                          const SizedBox(height: 8),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextBox(
                                  height: 36,
                                  labelText: "Start",
                                  showAlwaysLabel: true,
                                  fontSize: 11.5,
                                  backgroundColor: Colors.white,
                                  onTap: () async {
                                    DateTime date =
                                        slotController.dailyStart ??
                                        DateTime.now();
                                    TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      helpText: "Day Start Time",
                                      initialTime: TimeOfDay(
                                        hour: date.hour,
                                        minute: date.minute,
                                      ),
                                      initialEntryMode:
                                          TimePickerEntryMode.inputOnly,
                                    );
                                    if (time != null) {
                                      slotController.dailyStart = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                      );
                                      slotController.update();
                                    }
                                  },
                                  readonly: true,
                                  initialValue:
                                      slotController.dailyStart == null
                                      ? ""
                                      : DateFormat(
                                          'HH:mm',
                                        ).format(slotController.dailyStart!),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 12,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: TextBox(
                                  height: 36,
                                  labelText: "End",
                                  showAlwaysLabel: true,
                                  fontSize: 11.5,
                                  backgroundColor: Colors.white,
                                  onTap: () async {
                                    DateTime date =
                                        slotController.dailyEnd ??
                                        DateTime.now();
                                    TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                        hour: date.hour,
                                        minute: date.minute,
                                      ),
                                      initialEntryMode:
                                          TimePickerEntryMode.inputOnly,
                                      orientation: Orientation.portrait,
                                      helpText: "Day End Time",
                                    );
                                    if (time != null) {
                                      slotController.dailyEnd = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                      );
                                      slotController.update();
                                    }
                                  },
                                  readonly: true,
                                  initialValue: slotController.dailyEnd == null
                                      ? ""
                                      : DateFormat(
                                          'HH:mm',
                                        ).format(slotController.dailyEnd!),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                flex: 3,
                                child: TextBox(
                                  trailing: TextHelper(
                                    text: "m ",
                                    fontsize: 10,
                                    color: const Color(0xFF64748B),
                                  ),
                                  height: 36,
                                  labelText: "Interval",
                                  controller: slotController.period,
                                  showAlwaysLabel: true,
                                  fontSize: 11.5,
                                  backgroundColor: Colors.white,
                                  keyboard:
                                      const TextInputType.numberWithOptions(),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          // --- DESKTOP / TABLET CONTROLS LAYOUT ---
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 18,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextHelper(
                                text: "Month:",
                                fontweight: FontWeight.w600,
                                fontsize: 13,
                                color: const Color(0xFF334155),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 125,
                                child: DropDownHelperG(
                                  uniqueKey: "MonthPick",
                                  showLabelAlways: false,
                                  height: 35,
                                  showClearText: false,
                                  valueKey: "id",
                                  displayKey: "value",
                                  isSearchEnable: true,
                                  lightModeBackgroundColor: Colors.white,
                                  value: slotController.month == null
                                      ? {}
                                      : {
                                          "id": slotController.month?.month,
                                          "value": DateFormat(
                                            "MMMM",
                                          ).format(slotController.month!),
                                        },
                                  onValueChange: (v) {
                                    slotController.month = DateTime(
                                      slotController.month?.year ??
                                          DateTime.now().year,
                                      parseInt(data: v['id'], defaultInt: 1),
                                      1,
                                    );
                                    slotController.update();
                                  },
                                  items: List.generate(
                                    12,
                                    (index) => ({
                                      "id": index + 1,
                                      "value": DateFormat(
                                        "MMMM",
                                      ).format(DateTime(2026, index + 1)),
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 90,
                                child: DropDownHelperG(
                                  uniqueKey: "YearPick",
                                  showLabelAlways: false,
                                  height: 35,
                                  showClearText: false,
                                  valueKey: "id",
                                  displayKey: "value",
                                  isSearchEnable: true,
                                  lightModeBackgroundColor: Colors.white,
                                  value: slotController.month == null
                                      ? {}
                                      : {
                                          "id": slotController.month?.year,
                                          "value": slotController.month?.year,
                                        },
                                  onValueChange: (v) {
                                    slotController.month = DateTime(
                                      parseInt(data: v['id']),
                                      parseInt(
                                        data: slotController.month?.month,
                                        defaultInt: 1,
                                      ),
                                      1,
                                    );
                                    slotController.update();
                                  },
                                  items: List.generate(
                                    200,
                                    (index) => ({
                                      "id": 2000 + index,
                                      "value": DateFormat(
                                        "yyyy",
                                      ).format(DateTime(2000 + index, 1)),
                                    }),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ButtonHelperG(
                                onTap: () async {
                                  try {
                                    loader.startLoading();
                                    await slotController.slotDataFeel();
                                  } catch (e) {
                                    showAlert("$e", AlertType.error);
                                  } finally {
                                    loader.stopLoading();
                                  }
                                },
                                height: 35,
                                width: 80,
                                icon: const Icon(
                                  Icons.cloud_download_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                label: TextHelper(
                                  text: "Slots",
                                  color: Colors.white,
                                  fontsize: 12,
                                  fontweight: FontWeight.w600,
                                ),
                                background: const Color(0xFF0284C7),
                                margin: 0,
                              ),
                              const Spacer(),
                              ButtonHelperG(
                                onTap: () async {
                                  await handleFillSlotClick();
                                },
                                height: 35,
                                width: 105,
                                margin: 0,
                                type: ButtonHelperTypeG.outlined,
                                icon: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Color(0xFF4F46E5),
                                  size: 15,
                                ),
                                label: TextHelper(
                                  text: "Fill Slots",
                                  // color: const Color(0xFF4F46E5),
                                  fontsize: 12,
                                  fontweight: FontWeight.w600,
                                ),
                                // borderColor: const Color(0xFF6366F1),
                                background: const Color(0xFFEEF2FF),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.schedule_rounded,
                                  size: 18,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextHelper(
                                text: "Operating Hours:",
                                fontweight: FontWeight.w600,
                                fontsize: 13,
                                color: const Color(0xFF334155),
                              ),
                              const SizedBox(width: 12),
                              TextBox(
                                height: 35,
                                labelText: "Start",
                                showAlwaysLabel: true,
                                fontSize: 12,
                                width: 85,
                                backgroundColor: Colors.white,
                                onTap: () async {
                                  DateTime date =
                                      slotController.dailyStart ??
                                      DateTime.now();
                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    helpText: "Day Start Time",
                                    initialTime: TimeOfDay(
                                      hour: date.hour,
                                      minute: date.minute,
                                    ),
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                  );
                                  if (time != null) {
                                    slotController.dailyStart = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                    slotController.update();
                                  }
                                },
                                readonly: true,
                                initialValue: slotController.dailyStart == null
                                    ? ""
                                    : DateFormat(
                                        'HH:mm',
                                      ).format(slotController.dailyStart!),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              TextBox(
                                height: 35,
                                labelText: "End",
                                showAlwaysLabel: true,
                                fontSize: 12,
                                width: 85,
                                backgroundColor: Colors.white,
                                onTap: () async {
                                  DateTime date =
                                      slotController.dailyEnd ?? DateTime.now();
                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                      hour: date.hour,
                                      minute: date.minute,
                                    ),
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                    orientation: Orientation.portrait,
                                    helpText: "Day End Time",
                                  );
                                  if (time != null) {
                                    slotController.dailyEnd = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      time.hour,
                                      time.minute,
                                    );
                                    slotController.update();
                                  }
                                },
                                readonly: true,
                                initialValue: slotController.dailyEnd == null
                                    ? ""
                                    : DateFormat(
                                        'HH:mm',
                                      ).format(slotController.dailyEnd!),
                              ),
                              const SizedBox(width: 16),
                              TextBox(
                                trailing: TextHelper(
                                  text: "mins ",
                                  fontsize: 11,
                                  color: const Color(0xFF64748B),
                                ),
                                height: 35,
                                labelText: "Interval",
                                controller: slotController.period,
                                showAlwaysLabel: true,
                                fontSize: 12,
                                backgroundColor: Colors.white,
                                width: 90,
                                keyboard:
                                    const TextInputType.numberWithOptions(),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --- DATA GRID SCHEDULE MATRIX ---
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: GetBuilder<SubscriptionController>(
                        init: subscriptionController,
                        autoRemove: false,
                        builder: (subscriptionController) {
                          final branch = authenticator.branch;
                          if (branch == null) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.storefront_outlined,
                                    size: 36,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  const SizedBox(height: 8),
                                  TextHelper(
                                    text: 'No branch details found!',
                                    fontsize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ],
                              ),
                            );
                          }
                          return DataGridHelper3(
                            dataSource: slotController.slotData,
                            columnFixCount: 1,
                            withBorder: true,
                            showAlternateColor: true,
                            headerColor: const Color(0xFFF1F5F9),
                            columnSpacing: 1,
                            rowHeight: 115,
                            columnList: slotController.slotData.isEmpty
                                ? []
                                : slotController.slotData[0].keys.toList().sublist(1).map((
                                    k,
                                  ) {
                                    return DataGridColumnModel3(
                                      dataField: k,
                                      dataType: CellDataType3.string,
                                      title: "Time",
                                      width: 105,
                                      customHeaderCell: (c) {
                                        if (c.cellIndex == 0) {
                                          return Container(
                                            color: const Color(0xFF0F172A),
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.schedule_rounded,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                TextHelper(
                                                  text: "Time",
                                                  color: Colors.white,
                                                  fontweight: FontWeight.bold,
                                                  fontsize: 13,
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          final dayDate = DateTime(
                                            slotController.month!.year,
                                            slotController.month!.month,
                                            parseInt(
                                              data: c.cellValue,
                                              defaultInt: 1,
                                            ),
                                          );
                                          final dayOfWeek = DateFormat(
                                            "EEE",
                                          ).format(dayDate);
                                          final isSunday = dayOfWeek == "Sun";
                                          final isSaturday = dayOfWeek == "Sat";

                                          return Container(
                                            decoration: BoxDecoration(
                                              color: isSunday
                                                  ? const Color(0xFFFFF1F2)
                                                  : isSaturday
                                                  ? const Color(0xFFF8FAFC)
                                                  : const Color(0xFFF1F5F9),
                                              border: isSunday
                                                  ? const Border(
                                                      bottom: BorderSide(
                                                        color: Color(
                                                          0xFFF43F5E,
                                                        ),
                                                        width: 2,
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextHelper(
                                                  text: c.cellValue,
                                                  textalign: TextAlign.center,
                                                  fontsize: 14,
                                                  fontweight: FontWeight.bold,
                                                  color: isSunday
                                                      ? const Color(0xFFE11D48)
                                                      : const Color(0xFF1E293B),
                                                ),
                                                const SizedBox(height: 2),
                                                TextHelper(
                                                  text: dayOfWeek,
                                                  textalign: TextAlign.center,
                                                  color: isSunday
                                                      ? const Color(0xFFBE123C)
                                                      : isSaturday
                                                      ? const Color(0xFF475569)
                                                      : const Color(0xFF64748B),
                                                  fontsize: 11,
                                                  fontweight: FontWeight.w600,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                      customCell: (c) {
                                        if (c.cellIndex == 0) {
                                          return Container(
                                            color: const Color(0xFFF8FAFC),
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextHelper(
                                                  text:
                                                      "${c.rowValue['startTime']} - ${c.rowValue['endTime']}",
                                                  textalign: TextAlign.center,
                                                  fontsize: 11.5,
                                                  fontweight: FontWeight.w600,
                                                  color: const Color(
                                                    0xFF334155,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          String date = DateFormat('yyyy-MM-dd')
                                              .format(
                                                DateTime(
                                                  slotController.month!.year,
                                                  slotController.month!.month,
                                                  parseInt(
                                                    data: c.cellIndex
                                                        .toString(),
                                                  ),
                                                ),
                                              );
                                          int holidayIndex = slotController
                                              .holidayList
                                              .indexWhere(
                                                (h) => h.holidayDate == date,
                                              );

                                          if (holidayIndex != -1) {
                                            return Container(
                                              margin: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFEF3C7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFDE68A,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.event_busy_rounded,
                                                      color: Color(0xFFD97706),
                                                      size: 16,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    TextHelper(
                                                      text: slotController
                                                          .holidayList[holidayIndex]
                                                          .holidayName,
                                                      color: const Color(
                                                        0xFFB45309,
                                                      ),
                                                      fontweight:
                                                          FontWeight.bold,
                                                      fontsize: 11,
                                                      textalign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          int startTime = parseInt(
                                            data: c.rowValue['startTime']
                                                .toString()
                                                .replaceAll(':', ''),
                                            defaultInt: 0,
                                          );
                                          int endTime = parseInt(
                                            data: c.rowValue['endTime']
                                                .toString()
                                                .replaceAll(':', ''),
                                            defaultInt: 0,
                                          );

                                          int lunchStartTime = parseInt(
                                            data: branch.lunchStart.replaceAll(
                                              ':',
                                              '',
                                            ),
                                            defaultInt: 0,
                                          );
                                          int lunchEndTime = parseInt(
                                            data: branch.lunchEnd.replaceAll(
                                              ':',
                                              '',
                                            ),
                                            defaultInt: 0,
                                          );

                                          if (startTime >= lunchStartTime &&
                                              endTime <= lunchEndTime) {
                                            return Container(
                                              margin: const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFE4E6),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFECDD3,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.restaurant_rounded,
                                                      color: Color(0xFFE11D48),
                                                      size: 16,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    TextHelper(
                                                      text: 'Lunch Break',
                                                      color: Color(0xFFBE123C),
                                                      fontweight:
                                                          FontWeight.bold,
                                                      fontsize: 11,
                                                      textalign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          return InkWell(
                                            onTap: () {
                                              slotAddPopup(
                                                context,
                                                data: SlotAddData(
                                                  columnName: k,
                                                  rowIndex: c.rowIndex,
                                                  startTime:
                                                      c.rowValue['startTime'],
                                                  endTime:
                                                      c.rowValue['endTime'],
                                                  time:
                                                      "${c.rowValue['startTime']} - ${c.rowValue['endTime']}",
                                                  date: DateTime(
                                                    slotController.month!.year,
                                                    slotController.month!.month,
                                                    parseInt(
                                                      data: k,
                                                      defaultInt: 1,
                                                    ),
                                                  ),
                                                ),
                                                slotController: slotController,
                                                subscriptionController:
                                                    subscriptionController,
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              padding: const EdgeInsets.all(4),
                                              child: Builder(
                                                builder: (context) {
                                                  List<ServiceModel>
                                                  services = slotController
                                                      .getSelectedService(
                                                        DateFormat(
                                                          'yyyy-MM-dd',
                                                        ).format(
                                                          DateTime(
                                                            slotController
                                                                .month!
                                                                .year,
                                                            slotController
                                                                .month!
                                                                .month,
                                                            parseInt(
                                                              data: k,
                                                              defaultInt: 1,
                                                            ),
                                                          ),
                                                        ),
                                                        parseString(
                                                          data: c
                                                              .rowValue['startTime'],
                                                          defaultValue: "",
                                                        ),
                                                        parseString(
                                                          data: c
                                                              .rowValue['endTime'],
                                                          defaultValue: "",
                                                        ),
                                                        subscriptionController,
                                                      );
                                                  List<String>
                                                  membersName = slotController
                                                      .slots
                                                      .where(
                                                        (w) =>
                                                            w.date == date &&
                                                            w.startTime ==
                                                                c.rowValue['startTime'] &&
                                                            w.endTime ==
                                                                c.rowValue['endTime'],
                                                      )
                                                      .expand(
                                                        (e) => e.sessions
                                                            .where(
                                                              (s) =>
                                                                  s.memberName !=
                                                                  null,
                                                            )
                                                            .map(
                                                              (s) =>
                                                                  s.memberName!,
                                                            ),
                                                      )
                                                      .toList();

                                                  bool isMoreThenThreeService =
                                                      services.length > 3;
                                                  bool isMoreThenThreeMembers =
                                                      membersName.length > 3;
                                                  int leftMembers =
                                                      membersName.length - 3;
                                                  int leftService =
                                                      services.length - 3;

                                                  final displayServices =
                                                      services.sublist(
                                                        0,
                                                        isMoreThenThreeService
                                                            ? 3
                                                            : services.length,
                                                      );
                                                  final displayMembers =
                                                      membersName.sublist(
                                                        0,
                                                        isMoreThenThreeMembers
                                                            ? 3
                                                            : membersName
                                                                  .length,
                                                      );

                                                  if (services.isEmpty &&
                                                      membersName.isEmpty) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                        border: Border.all(
                                                          color: const Color(
                                                            0xFFF1F5F9,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .add_circle_outline_rounded,
                                                              size: 14,
                                                              color: Color(
                                                                0xFFCBD5E1,
                                                              ),
                                                            ),
                                                            SizedBox(width: 4),
                                                            Text(
                                                              "+ Add",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                color: Color(
                                                                  0xFF94A3B8,
                                                                ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      // --- SERVICES SECTION ---
                                                      if (displayServices
                                                          .isNotEmpty) ...[
                                                        Row(
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .fitness_center_rounded,
                                                              size: 10,
                                                              color: Color(
                                                                0xFF64748B,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              "Services",
                                                              style: TextStyle(
                                                                fontSize: 9.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                  0xFF475569,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Wrap(
                                                          spacing: 3,
                                                          runSpacing: 3,
                                                          children: [
                                                            ...displayServices.map<
                                                              Widget
                                                            >((m) {
                                                              final nameTag =
                                                                  m.name.length >
                                                                      2
                                                                  ? m.name
                                                                        .substring(
                                                                          0,
                                                                          2,
                                                                        )
                                                                  : m.name;
                                                              return Container(
                                                                height: 22,
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          6,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFFEEF2FF,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        11,
                                                                      ),
                                                                  border: Border.all(
                                                                    color: const Color(
                                                                      0xFFC7D2FE,
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      nameTag,
                                                                      style: const TextStyle(
                                                                        fontSize:
                                                                            9.5,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Color(
                                                                          0xFF4338CA,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    if (m.isNewSlot ==
                                                                        true) ...[
                                                                      const SizedBox(
                                                                        width:
                                                                            2,
                                                                      ),
                                                                      InkWell(
                                                                        onTap: () {
                                                                          final start = parseString(
                                                                            data:
                                                                                c.rowValue['startTime'],
                                                                            defaultValue:
                                                                                "",
                                                                          );
                                                                          final end = parseString(
                                                                            data:
                                                                                c.rowValue['endTime'],
                                                                            defaultValue:
                                                                                "",
                                                                          );
                                                                          final dateStr =
                                                                              DateFormat(
                                                                                'yyyy-MM-dd',
                                                                              ).format(
                                                                                DateTime(
                                                                                  slotController.month!.year,
                                                                                  slotController.month!.month,
                                                                                  parseInt(
                                                                                    data: k,
                                                                                    defaultInt: 1,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                          slotController.slots.removeWhere(
                                                                            (
                                                                              s,
                                                                            ) =>
                                                                                s.startTime ==
                                                                                    start &&
                                                                                s.endTime ==
                                                                                    end &&
                                                                                s.serviceId ==
                                                                                    m.id &&
                                                                                s.date ==
                                                                                    dateStr,
                                                                          );
                                                                          slotController
                                                                              .update();
                                                                        },
                                                                        child: const Icon(
                                                                          Icons
                                                                              .close_rounded,
                                                                          size:
                                                                              12,
                                                                          color: Color(
                                                                            0xFF6366F1,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ],
                                                                ),
                                                              );
                                                            }).toList(),
                                                            if (isMoreThenThreeService)
                                                              Container(
                                                                height: 22,
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFFE0E7FF,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        11,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "+$leftService",
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                        0xFF3730A3,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                      ],

                                                      // --- MEMBERS SECTION ---
                                                      if (displayMembers
                                                          .isNotEmpty) ...[
                                                        Row(
                                                          children: const [
                                                            Icon(
                                                              Icons
                                                                  .people_alt_rounded,
                                                              size: 10,
                                                              color: Color(
                                                                0xFF64748B,
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              "Members",
                                                              style: TextStyle(
                                                                fontSize: 9.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Color(
                                                                  0xFF475569,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 3,
                                                        ),
                                                        Wrap(
                                                          spacing: 3,
                                                          runSpacing: 3,
                                                          children: [
                                                            ...displayMembers.map<
                                                              Widget
                                                            >((m) {
                                                              final nameTag =
                                                                  m.length > 2
                                                                  ? m.substring(
                                                                      0,
                                                                      2,
                                                                    )
                                                                  : m;
                                                              return Container(
                                                                height: 22,
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          6,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFFFEF3C7,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        11,
                                                                      ),
                                                                  border: Border.all(
                                                                    color: const Color(
                                                                      0xFFFDE68A,
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    nameTag,
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          9.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                        0xFFB45309,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            if (isMoreThenThreeMembers)
                                                              Container(
                                                                height: 22,
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          5,
                                                                    ),
                                                                decoration: BoxDecoration(
                                                                  color: const Color(
                                                                    0xFFFDE68A,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        11,
                                                                      ),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "+$leftMembers",
                                                                    style: const TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Color(
                                                                        0xFF92400E,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  }).toList(),
                            uniqueKey: UniqueKey().toString(),
                            width: isMobile
                                ? (screenWidth - (isMobile ? 16 : 24))
                                : (screenWidth * 0.8),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

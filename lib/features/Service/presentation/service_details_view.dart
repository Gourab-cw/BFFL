import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/async_select.dart';
import 'package:healthandwellness/features/Service/controller/service_controller.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import '../../../core/utility/app_loader.dart';
import '../../../core/utility/helper.dart';
import '../data/service.dart';

class ServiceDetailsView extends StatefulWidget {
  const ServiceDetailsView({super.key});

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  final mainStore = Get.find<MainStore>();
  final loader = Get.find<AppLoaderController>();
  final auth = Get.find<Authenticator>();
  final service = Get.find<ServiceController>();

  double? height = 30;

  @override
  void initState() {
    // TODO: implement initState
    Future(() async {
      try {
        loader.startLoading();
        if (service.selectedService != null && auth.state != null) {
          await service.getServiceDetails(service.selectedService!.id, auth.state!.branchId);
        }
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        loader.stopLoading();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    service.selectedDate = null;
    service.slots = [];
    service.selectedSlot = null;
    service.selectedMember = {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return GetBuilder<ServiceController>(
      init: service,
      autoRemove: false,
      builder: (service) {
        final ServiceModel? s = service.selectedService;
        if (s == null) {
          return Scaffold(
            appBar: AppBar(
              title: TextHelper(text: "Details", fontsize: 15, fontweight: FontWeight.w600),
            ),
            body: Center(
              child: TextHelper(text: "No service found!", fontsize: 20, textalign: TextAlign.center),
            ),
          );
        }
        return AppLoader(
          child: Scaffold(
            appBar: AppBar(
              title: TextHelper(text: "Details", fontsize: 15, fontweight: FontWeight.w600),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: safePadding.left + 10, top: safePadding.top, bottom: safePadding.bottom, right: safePadding.right + 10),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: s.image.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: s.image,
                              progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Icon(Icons.health_and_safety_rounded),
                              height: 160,
                              fit: BoxFit.cover,
                            )
                          : Icon(MoonIcons.generic_user_24_regular),
                    ),
                    const SizedBox(height: 10),
                    TextHelper(text: s.name, fontweight: FontWeight.w600, fontsize: 15),
                    Container(
                      decoration: height == 30 ? null : BoxDecoration(color: Colors.blueGrey.shade50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AnimatedContainer(
                              height: height,
                              decoration: BoxDecoration(),
                              clipBehavior: Clip.antiAlias,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastEaseInToSlowEaseOut,
                              child: TextHelper(text: s.description, textalign: TextAlign.left, isWrap: height == 30 ? false : true, fontsize: 12),
                            ),
                          ),
                          ButtonHelperG(
                            onTap: () {
                              setState(() {
                                height = ((height == 30) ? null : 30);
                              });
                            },
                            background: Colors.transparent,
                            margin: 0,
                            padding: EdgeInsets.all(3),
                            width: 30,
                            height: 30,
                            icon: Icon(height == 30 ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextHelper(text: "Slot Booking", color: Colors.green, fontweight: FontWeight.w600, fontsize: 14),
                    Divider(),
                    TextHelper(
                      text: "Select Date",
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blueGrey.shade700,
                      fontsize: 13,
                      fontweight: FontWeight.w600,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                          monthTextStyle: TextStyle(fontSize: 11),
                          yearTextStyle: TextStyle(fontSize: 11),
                          allowSameValueSelection: true,
                          animateToDisplayedMonthDate: true,
                          calendarType: CalendarDatePicker2Type.single,
                          calendarViewMode: CalendarDatePicker2Mode.day,
                          daySplashColor: Colors.green.shade50,
                          selectedDayHighlightColor: Colors.green.shade300,
                          firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(2090),
                          dayBuilder:
                              ({
                                required DateTime date, // Changed from dynamic dateToBuild
                                TextStyle? textStyle, // This must be included
                                BoxDecoration? decoration,
                                bool? isSelected,
                                bool? isDisabled,
                                bool? isToday,
                              }) {
                                return Center(
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: parseBool(data: isSelected, defaultValue: false) ? Colors.green.shade50 : Colors.transparent,
                                    ),
                                    child: Center(
                                      child: TextHelper(
                                        text: date.day.toString(),
                                        textalign: TextAlign.center,
                                        color: isDisabled == true
                                            ? Colors.blueGrey.shade200
                                            : isSelected == true
                                            ? Colors.green.shade700
                                            : service.haveSlot(DateFormat('yyyy-MM-dd').format(date)) == true
                                            ? Colors.blue
                                            : service.haveSlot(DateFormat('yyyy-MM-dd').format(date)) == null
                                            ? Colors.blueGrey.shade600
                                            : Colors.red.shade600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                          selectedDayTextStyle: TextStyle(color: Colors.green),
                          firstDayOfWeek: 1,
                        ),
                        value: [service.selectedDate],
                        onValueChanged: (v) {
                          if (v.isNotEmpty) {
                            service.selectedSlot = null;
                            service.selectedDate = v.first;
                            service.update();
                          }
                        },
                      ),
                    ),
                    if (service.selectedDate != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            TextHelper(text: "Morning slots", fontweight: FontWeight.w600, fontsize: 14),
                            ...service.getSelectedDaySlots(DateFormat('yyyy-MM-dd').format(service.selectedDate!)).map((m) {
                              return Opacity(
                                opacity: service.availableSlot(m) ? 1 : 0.4,
                                child: GestureDetector(
                                  onTap: () {
                                    if (!service.availableSlot(m)) {
                                      return;
                                    }
                                    service.selectedSlot = m;
                                    service.update();
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: service.selectedSlot?.id == m.id ? Colors.green.shade100 : Colors.white,
                                      border: Border.all(color: Colors.black45),
                                    ),
                                    child: TextHelper(text: "${m.startTime} - ${m.endTime}", width: 100, textalign: TextAlign.center),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    if (service.selectedDate != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            TextHelper(text: "Afternoon slots", fontweight: FontWeight.w600, fontsize: 14),
                            ...service.getSelectedAfterNoonSlots(DateFormat('yyyy-MM-dd').format(service.selectedDate!)).map((m) {
                              return Opacity(
                                opacity: service.availableSlot(m) ? 1 : 0.4,
                                child: GestureDetector(
                                  onTap: () {
                                    if (!service.availableSlot(m)) return;
                                    service.selectedSlot = m;
                                    service.update();
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: service.selectedSlot?.id == m.id ? Colors.green.shade100 : Colors.white,
                                      border: Border.all(color: Colors.black45),
                                    ),
                                    child: TextHelper(text: "${m.startTime} - ${m.endTime}", width: 100, textalign: TextAlign.center),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    if (service.selectedDate != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            TextHelper(text: "Evening slots", fontweight: FontWeight.w600, fontsize: 14),
                            ...service.getSelectedEveSlots(DateFormat('yyyy-MM-dd').format(service.selectedDate!)).map((m) {
                              return Opacity(
                                opacity: service.availableSlot(m) ? 1 : 0.4,
                                child: GestureDetector(
                                  onTap: () {
                                    if (!service.availableSlot(m)) return;
                                    service.selectedSlot = m;
                                    service.update();
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: service.selectedSlot?.id == m.id ? Colors.green.shade100 : Colors.white,
                                      border: Border.all(color: Colors.black45),
                                    ),
                                    child: TextHelper(text: "${m.startTime} - ${m.endTime}", width: 100, textalign: TextAlign.center),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    if (service.selectedDate != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            TextHelper(text: "Member :", width: 60, fontweight: FontWeight.w600),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width - 120 > 300 ? 300 : MediaQuery.sizeOf(context).width - 120,
                              child: AsyncSelect(
                                backgroundColor: Colors.green.shade50,
                                parentHeight: 40,
                                onValueChange: (v) {
                                  service.selectedMember = makeMapSerialize(v);
                                  service.update();
                                },
                                customComponent: (d) => Container(
                                  margin: EdgeInsets.all(5),
                                  color: Colors.grey.shade200,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextHelper(
                                        text: parseString(data: d["name"], defaultValue: ""),
                                        fontweight: FontWeight.w500,
                                      ),
                                      TextHelper(
                                        text: parseString(data: d["address"], defaultValue: ""),
                                        fontsize: 11,
                                        color: Colors.blueGrey.shade500,
                                      ),
                                    ],
                                  ),
                                ),
                                dropDownPosition: MoonDropdownAnchorPosition.top,
                                value: service.selectedMember,
                                uniqueKey: UniqueKey().toString(),
                                callContent: service.getMemberList,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    ButtonHelperG(
                      onTap: () async {
                        if (service.selectedDate == null) {
                          showAlert("Select a date to continue!", AlertType.error);
                          return;
                        }
                        if (service.selectedMember.isEmpty) {
                          showAlert("Select a member to continue!", AlertType.error);
                          return;
                        }
                        if (service.selectedSlot == null) {
                          showAlert("Select a slot to continue!", AlertType.error);
                          return;
                        }
                        try {
                          loader.startLoading();
                          await service.bookSlot();
                          service.selectedDate = null;
                          service.selectedSlot = null;
                          service.selectedMember = {};
                          service.update();
                        } catch (e) {
                          showAlert("$e", AlertType.error);
                        } finally {
                          loader.stopLoading();
                        }
                      },
                      width: 200,
                      label: TextHelper(text: "Book Appointment", color: Colors.white),
                    ),
                    const SizedBox(height: 30),
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

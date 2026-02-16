import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/async_select.dart';
import 'package:healthandwellness/features/Service/controller/service_controller.dart';
import 'package:healthandwellness/features/home/controller/member_home_controller.dart';
import 'package:healthandwellness/features/login/data/user.dart';
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
  final memberHomeController = Get.find<MemberHomeController>();
  final loader = Get.find<AppLoaderController>();
  final auth = Get.find<Authenticator>();
  final service = Get.find<ServiceController>();

  bool makingBooking = false;
  bool isReschedule = parseBool(data: Get.parameters['isReschedule'], defaultValue: false);
  double? height = 30;

  Future<void> bookingFetching() async {
    try {
      loader.startLoading();
      if (service.selectedService != null && auth.state != null) {
        await service.getServiceDetails(service.selectedService!.id, auth.state!.branchId);
      }
      if (auth.state != null) {
        service.selectedMember = {"id": auth.state!.id, "name": auth.state!.name, "value": auth.state!.name};
        service.update();
        setState(() {
          makingBooking = true;
        });
      }
    } catch (e) {
      showAlert("$e", AlertType.error);
    } finally {
      loader.stopLoading();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() {
      if (isReschedule) {
        bookingFetching();
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
                    Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: s.trainerId.length,
                      itemBuilder: (_, index) {
                        final trainerId = s.trainerId[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Icon(FontAwesomeIcons.userDoctor, color: Colors.grey.shade700, size: 18),
                              TextHelper(
                                text: service.trainers.firstWhereOrNull((se) => se.id == trainerId)?.name ?? "",
                                fontweight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      decoration: BoxDecoration(color: height == 30 ? null : Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(10)),
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
                    const SizedBox(height: 4),
                    Row(
                      spacing: 5,
                      children: [
                        TextHelper(text: "Per Session :", width: 80, fontweight: FontWeight.w600),
                        TextHelper(text: currenyFormater(value: s.amount, withDrCr: false), width: 200),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      spacing: 5,
                      children: [
                        TextHelper(text: "Package :", width: 80, fontweight: FontWeight.w600),
                        TextHelper(text: currenyFormater(value: s.totalAmount, withDrCr: false), width: 200),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      spacing: 5,
                      children: [
                        TextHelper(text: "Period:", width: 80, fontweight: FontWeight.w600),
                        TextHelper(text: "${s.totalDays} Days", width: 180),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (!makingBooking)
                      ButtonHelperG(
                        margin: 40,
                        width: 120,
                        onTap: () async {
                          await bookingFetching();
                        },
                        label: TextHelper(text: "Make Booking", color: Colors.white),
                      ),
                    if (makingBooking)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                      opacity: service.availableSlot(m, withRescheduleData: service.selectedReschedule) == true ? 1 : 0.4,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (service.availableSlot(m, withRescheduleData: service.selectedReschedule) != true) {
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
                                            border: Border.all(
                                              color: service.availableSlot(m, withRescheduleData: service.selectedReschedule) == null
                                                  ? Colors.red
                                                  : Colors.black45,
                                            ),
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
                                      opacity: service.availableSlot(m, withRescheduleData: service.selectedReschedule) == true ? 1 : 0.4,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (service.availableSlot(m, withRescheduleData: service.selectedReschedule) != true) return;
                                          service.selectedSlot = m;
                                          service.update();
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: service.selectedSlot?.id == m.id ? Colors.green.shade100 : Colors.white,
                                            border: Border.all(
                                              color: service.availableSlot(m, withRescheduleData: service.selectedReschedule) == null
                                                  ? Colors.red
                                                  : Colors.black45,
                                            ),
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
                                      opacity: service.availableSlot(m, withRescheduleData: service.selectedReschedule) == true ? 1 : 0.4,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (service.availableSlot(m, withRescheduleData: service.selectedReschedule) != true) return;
                                          service.selectedSlot = m;
                                          service.update();
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: service.selectedSlot?.id == m.id ? Colors.green.shade100 : Colors.white,
                                            border: Border.all(
                                              color: service.availableSlot(m, withRescheduleData: service.selectedReschedule) == null
                                                  ? Colors.red
                                                  : Colors.black45,
                                            ),
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
                          if (service.selectedDate != null && auth.state!.userType != UserType.member)
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
                                      disabled: auth.state?.userType == UserType.member,
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
                                await service.bookSlot(reschedule: service.selectedReschedule);
                                service.selectedDate = null;
                                service.selectedSlot = null;
                                if (auth.state!.userType == UserType.member) {
                                  service.selectedMember = {'id': auth.state!.id, 'name': auth.state!.name, 'value': auth.state!.name};
                                } else {
                                  service.selectedMember = {};
                                }
                                service.update();
                                await memberHomeController.getBookings();
                                if (isReschedule) {
                                  goBack(context);
                                  goBack(context);
                                }
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

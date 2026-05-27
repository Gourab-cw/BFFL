import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';

import 'helper.dart';

// class DateRangePicker extends StatefulHookWidget {
//   DateTimeRange? selectedDateRange;
//   final Function(DateTimeRange)? onValueChange;
//   final String dateFormat;
//   final double width;
//   final double height;
//   final double borderRadius;
//   final String? placeholder;
//   final bool withBorder;
//   final bool autofocus;
//   final Color backgroundColor;
//   Widget? leading;
//   final Widget? leadingIcon;
//   bool disable;
//   DateRangePicker(
//       {super.key,
//       this.selectedDateRange,
//       this.onValueChange,
//       this.width = 200,
//       this.height = 50,
//       this.borderRadius = 8,
//       this.leading,
//         this.backgroundColor = Colors.white,
//       this.withBorder = false,
//       this.disable = false,
//       this.autofocus = false,
//       this.leadingIcon = const Icon(MoonIcons.time_calendar_24_regular),
//       this.placeholder = "Select Date Range",
//       this.dateFormat = "dd-MM-yyyy"});
//
//   @override
//   State<DateRangePicker> createState() => _DateRangePickerState();
// }
//
// class _DateRangePickerState extends State<DateRangePicker> {
//   // String data = "Select Date Range";
//   DateTimeRange? selectedDateRange;
//   TextEditingController textboxcontroller = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     if (widget.selectedDateRange == null) {
//     } else {
//       setState(() {
//         if (DateFormat('dd-MM-yyyy').format(widget.selectedDateRange!.start) ==
//             DateFormat('dd-MM-yyyy').format(widget.selectedDateRange!.end)) {
//           textboxcontroller.text =
//               DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end);
//         } else {
//           textboxcontroller.text =
//               "${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.start)}   -   ${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end)}";
//         }
//       });
//     }
//     // if (widget.placeholder != null) {
//     //   setState(() {
//     //     data = widget.placeholder!;
//     //   });
//     // }
//     super.initState();
//   }
//
//   showDatePicker(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (context) => Center(
//               child: Material(
//                 borderRadius: BorderRadius.circular(widget.borderRadius),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       // color: Colors.black,
//                       borderRadius: BorderRadius.circular(widget.borderRadius)),
//                   width: 350,
//                   height: 450,
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       const Text(
//                         "Select Date Range",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                       CalendarDatePicker2(
//                         config: CalendarDatePicker2Config(
//                           allowSameValueSelection: true,
//                           animateToDisplayedMonthDate: true,
//                           calendarType: CalendarDatePicker2Type.range,
//                           calendarViewMode: CalendarDatePicker2Mode.day,
//                           firstDayOfWeek: 1,
//                         ),
//                         value: widget.selectedDateRange != null
//                             ? [widget.selectedDateRange!.start, widget.selectedDateRange!.end]
//                             : [DateTime.now()],
//                         onValueChanged: (value) {
//                           if (value.length > 1) {
//                             setState(() {
//                               selectedDateRange = DateTimeRange(
//                                   start: DateTime.parse(value[0].toString()),
//                                   end: DateTime.parse(value[1].toString()));
//                             });
//                           }
//                         },
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           MoonTextButton(
//                             onTap: () {
//                               if (widget.onValueChange != null) {
//                                 setState(() {
//                                   widget.selectedDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
//                                 });
//                                 // print(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
//                                 widget.onValueChange!(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
//                               }
//                               goBack(context);
//                             },
//                             label: const Text("Select Today"),
//                           ),
//                           MoonTextButton(
//                             onTap: () {
//                               if (selectedDateRange != null &&
//                                   widget.onValueChange != null) {
//                                 setState(() {
//                                   widget.selectedDateRange = selectedDateRange;
//                                 });
//                                 widget.onValueChange!(selectedDateRange!);
//                               }
//                               goBack(context);
//                             },
//                             label: const Text("Ok"),
//                           ),
//                           MoonTextButton(
//                             onTap: () => goBack(context),
//                             label: const Text("Cancel"),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     useEffect(() {
//       if (widget.selectedDateRange == null) {
//       } else {
//         setState(() {
//           if (DateFormat('dd-MM-yyyy')
//                   .format(widget.selectedDateRange!.start) ==
//               DateFormat('dd-MM-yyyy').format(widget.selectedDateRange!.end)) {
//             textboxcontroller.text =
//                 DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end);
//           } else {
//             textboxcontroller.text =
//                 "${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.start)} - ${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end)}";
//           }
//         });
//       }
//       return null;
//     }, [widget.selectedDateRange]);
//     return Row(
//       children: [
//         widget.leading ?? Container(),
//         MouseRegion(
//           cursor: SystemMouseCursors.click,
//           child: TextBox(
//             height: widget.height,
//             width: widget.width + 20,
//             onValueChange: (v) {},
//             onTap: () {
//               if (!widget.disable) showDatePicker(context);
//             },
//             autofocus: widget.autofocus,
//             readonly: true,
//             leading: widget.leadingIcon,
//             withBorder: widget.withBorder,
//             controller: textboxcontroller,
//             placeholder: widget.placeholder,
//             backgroundColor: widget.backgroundColor,
//             // padding: EdgeInsets.only(left: 20),
//             // alignment: Alignment.centerLeft,
//           ),
//         ),
//       ],
//     );
//   }
// }

class DateRangePicker extends StatefulHookWidget {
  DateTimeRange? selectedDateRange;
  final Function(DateTimeRange)? onValueChange;
  final String dateFormat;
  final double width;
  final double height;
  final String? placeholder;
  final bool withBorder;
  final bool autofocus;
  final bool withSingleSelect;
  final Color backgroundColor;
  Color? fontColor;
  Widget? leading;
  DateTime? firstDate;
  DateTime? lastDate;
  bool withClear;
  final Widget? leadingIcon;
  bool disable;
  DateRangePicker({
    super.key,
    this.selectedDateRange,
    this.onValueChange,
    this.width = 200,
    this.height = 50,
    this.leading,
    this.backgroundColor = Colors.white,
    this.withBorder = false,
    this.disable = false,
    this.firstDate,
    this.lastDate,
    this.fontColor,
    this.withClear = false,
    this.autofocus = false,
    this.withSingleSelect = false,
    this.leadingIcon = const Icon(MoonIcons.time_calendar_24_regular),
    this.placeholder = "Select Date Range",
    this.dateFormat = "dd-MM-yyyy",
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  // String data = "Select Date Range";
  DateTimeRange? selectedDateRange;
  TextEditingController textboxcontroller = TextEditingController();
  TextEditingController fromDateCtrl = TextEditingController();
  TextEditingController toDateCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.selectedDateRange == null) {
    } else {
      setState(() {
        if (DateFormat('dd-MM-yyyy').format(widget.selectedDateRange!.start) == DateFormat('dd-MM-yyyy').format(widget.selectedDateRange!.end)) {
          textboxcontroller.text = DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end);
          fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.end);
          toDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.end);
        } else {
          textboxcontroller.text =
              "${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.start)}   -   ${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end)}";
          fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.start);
          toDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.end);
        }
      });
    }
    // if (widget.placeholder != null) {
    //   setState(() {
    //     data = widget.placeholder!;
    //   });
    // }
    super.initState();
  }

  showDatePicker(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: Material(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minHeight: 300, maxHeight: 500),
                width: 350,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const Text("Select Date Range", style: TextStyle(fontSize: 16)),
                    const Divider(),
                    const SizedBox(height: 5),
                    if (!widget.withSingleSelect)
                      Row(
                        spacing: 18,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextBox(
                            controller: fromDateCtrl,
                            width: 120,
                            labelText: "From Date",
                            selectTextOnFocus: true,
                            height: 35,
                            showAlwaysLabel: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                              // SmartDateFormatter(),
                            ],
                            leading: const Icon(Icons.calendar_month, color: Colors.blueGrey, size: 16),
                            onValueChange: (v) {
                              if (v.length == 10) {
                                DateTime toDate = parseStringToDate(data: toDateCtrl.text, predefinedDateFormat: "dd-MM-yyyy", defaultValue: DateTime.now());
                                DateTime fromDate = parseStringToDate(
                                  data: fromDateCtrl.text,
                                  predefinedDateFormat: "dd-MM-yyyy",
                                  defaultValue: DateTime.now(),
                                );

                                if (toDate.difference(fromDate).isNegative) {
                                  showAlert("Start date must be on or before end date.", AlertType.error);
                                  fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(toDate.subtract(const Duration(days: 1)));
                                  fromDate = toDate.subtract(const Duration(days: 1));
                                }

                                setState(() {
                                  selectedDateRange = DateTimeRange(start: fromDate, end: toDate);
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 10, child: Divider()),
                          TextBox(
                            width: 120,
                            controller: toDateCtrl,
                            // backgroundColor: Colors.white,
                            labelText: "To Date",
                            height: 35,
                            selectTextOnFocus: true,
                            showAlwaysLabel: true,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))],
                            onValueChange: (v) {
                              if (v.length == 10) {
                                DateTime toDate = parseStringToDate(data: toDateCtrl.text, predefinedDateFormat: "dd-MM-yyyy", defaultValue: DateTime.now());
                                DateTime fromDate = parseStringToDate(
                                  data: fromDateCtrl.text,
                                  predefinedDateFormat: "dd-MM-yyyy",
                                  defaultValue: DateTime.now(),
                                );

                                if (toDate.difference(fromDate).isNegative) {
                                  showAlert("Start date must be on or before end date.", AlertType.error);
                                  toDateCtrl.text = DateFormat("dd-MM-yyyy").format(fromDate.add(const Duration(days: 1)));
                                  toDate = fromDate.add(const Duration(days: 1));
                                }

                                setState(() {
                                  selectedDateRange = DateTimeRange(start: fromDate, end: toDate);
                                });
                              }
                            },
                            leading: const Icon(Icons.calendar_month, color: Colors.blueGrey, size: 16),
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),
                    CalendarDatePicker2(
                      config: CalendarDatePicker2Config(
                        allowSameValueSelection: true,
                        dynamicCalendarRows: true,
                        daySplashColor: getMainStore().theme.value.HeadColor.withAlpha(100),
                        selectedDayHighlightColor: getMainStore().theme.value.secondaryColor.withAlpha(100),
                        selectedRangeHighlightColor: getMainStore().theme.value.secondaryColor.withAlpha(100),
                        rangeBidirectional: true,
                        animateToDisplayedMonthDate: true,
                        calendarType: CalendarDatePicker2Type.range,
                        calendarViewMode: CalendarDatePicker2Mode.day,
                        firstDayOfWeek: 1,
                        firstDate: widget.firstDate,
                        lastDate: widget.lastDate,
                        // dayTextStyle: TextStyle(color: widget.fontColor),
                      ),
                      // value: widget.selectedDateRange != null ? [widget.selectedDateRange!.start, widget.selectedDateRange!.end] : [DateTime.now()],
                      value: selectedDateRange != null ? [selectedDateRange!.start, selectedDateRange!.end] : [DateTime.now()],
                      onValueChanged: (value) {
                        if (widget.withSingleSelect) {
                          if (value.length > 1) {
                            setState(() {
                              selectedDateRange = DateTimeRange(start: DateTime.parse(value[0].toString()), end: DateTime.parse(value[1].toString()));
                            });
                            fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(value[0]);
                            toDateCtrl.text = DateFormat("dd-MM-yyyy").format(value[1]);
                          } else {
                            setState(() {
                              selectedDateRange = DateTimeRange(start: DateTime.parse(value[0].toString()), end: DateTime.parse(value[0].toString()));
                            });
                            fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(value[0]);
                            toDateCtrl.text = DateFormat("dd-MM-yyyy").format(value[0]);
                          }
                        } else {
                          if (value.length > 1) {
                            setState(() {
                              selectedDateRange = DateTimeRange(start: DateTime.parse(value[0].toString()), end: DateTime.parse(value[1].toString()));
                            });
                            fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(value[0]);
                            toDateCtrl.text = DateFormat("dd-MM-yyyy").format(value[1]);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MoonTextButton(
                          onTap: () {
                            if (widget.onValueChange != null) {
                              setState(() {
                                widget.selectedDateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
                              });
                              // print(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
                              widget.onValueChange!(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
                            }
                            goBack(context);
                          },
                          label: const Text("Select Today"),
                        ),
                        Row(
                          children: [
                            MoonTextButton(
                              onTap: () {
                                if (selectedDateRange != null && widget.onValueChange != null) {
                                  setState(() {
                                    widget.selectedDateRange = selectedDateRange;
                                  });
                                  widget.onValueChange!(selectedDateRange!);
                                }
                                goBack(context);
                              },
                              label: const Text("Ok"),
                            ),
                            MoonTextButton(onTap: () => goBack(context), label: const Text("Cancel")),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ).whenComplete(() {
      fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.start);
      toDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.end);
    });
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      selectedDateRange = widget.selectedDateRange;
      if (widget.selectedDateRange == null) {
      } else {
        setState(() {
          if (DateFormat('dd-MM-yyyy').format(widget.selectedDateRange!.start) == DateFormat('dd-MM-yyyy').format(widget.selectedDateRange!.end)) {
            textboxcontroller.text = DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end);
            fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.end);
            toDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.end);
          } else {
            textboxcontroller.text =
                "${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.start)} - ${DateFormat(widget.dateFormat).format(widget.selectedDateRange!.end)}";
            fromDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.start);
            toDateCtrl.text = DateFormat("dd-MM-yyyy").format(widget.selectedDateRange!.end);
          }
        });
      }
      return null;
    }, [widget.selectedDateRange]);
    return Row(
      children: [
        widget.leading ?? Container(),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: TextBox(
            height: widget.height,
            width:
                (widget.selectedDateRange != null &&
                    widget.selectedDateRange?.start.year == widget.selectedDateRange?.end.year &&
                    widget.selectedDateRange?.start.day == widget.selectedDateRange?.end.day &&
                    widget.selectedDateRange?.start.month == widget.selectedDateRange?.end.month)
                ? 150
                : widget.width,
            onValueChange: (v) {},
            onTap: () {
              if (!widget.disable) showDatePicker(context);
            },
            autofocus: widget.autofocus,
            readonly: true,
            fontColor: widget.fontColor,
            fontWeight: FontWeight.w600,
            selectTextOnFocus: false,
            backgroundColor: widget.backgroundColor,
            leading: widget.leadingIcon,
            withBorder: widget.withBorder,
            controller: textboxcontroller,
            placeholder: widget.placeholder,
            trailing: (widget.withClear)
                ? ButtonHelperG(
                    margin: 0,
                    onTap: () {
                      textboxcontroller.text = '';
                      widget.onValueChange!(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
                    },
                    background: Colors.transparent,
                    icon: const Icon(FontAwesomeIcons.xmark, color: Colors.blueGrey, size: 14),
                  )
                : null,
            // padding: EdgeInsets.only(left: 20),
            // alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }
}

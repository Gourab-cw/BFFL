import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform; // Only works on non-web platforms
import 'dart:math';
import 'dart:ui' as ui;

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as _dio;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:moon_design/moon_design.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ussd_phone_call_sms/ussd_phone_call_sms.dart';

void goBack(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}

bool isJSONParsable(String data) {
  try {
    jsonDecode(data);
    return true;
  } catch (e) {
    return false;
  }
}

dynamic parseJSON(dynamic data) {
  try {
    dynamic x = jsonDecode(data);
    return x;
  } catch (e) {
    return {};
  }
}

double getTextWidth(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: ui.TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);

  return textPainter.size.width;
}

enum AlertType { error, success, info }

class CustomResponse {
  bool success;
  dynamic data;
  Object? error;
  String response;
  _dio.Response<dynamic>? raw;
  CustomResponse({required this.success, this.data, this.error, required this.response, this.raw});
}

String makeDrCrCurrencyFormat(String format, double data) {
  String type = '';
  if (data > 0) {
    type = 'Cr';
  } else {
    type = 'Dr';
  }
  return "${currenyFormater(value: data, format: format).replaceAll('-', '')} $type";
}

// LABEL BOX WIDGET ====
class TextHelper extends StatelessWidget {
  TextHelper({
    super.key,
    required this.text,
    this.width,
    this.color,
    this.padding,
    this.camalToLabel = false,
    this.showRequired = false,
    this.onlyBottomBorder = false,
    this.withBorder = false,
    this.isWrap = false,
    this.fontsize = 11.5,
    this.borderRadius = 8,
    this.fontweight = FontWeight.w400,
    this.textalign = TextAlign.left,
    this.bgColor,
  });
  final String text;
  final bool isWrap;
  final bool camalToLabel;
  final bool showRequired;
  final bool onlyBottomBorder;
  final bool withBorder;
  final double fontsize;
  final double borderRadius;
  final double? width;
  final FontWeight? fontweight;
  final TextAlign textalign;
  final Color? color;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;

  MainStore mainStore = Get.find();

  String makeCamalToLabel(String data) {
    if (data.isEmpty) {
      return data;
    }

    // Use a regular expression to find all uppercase letters that are followed
    // by a lowercase letter, or are preceded by a lowercase letter.
    String result = data.replaceAllMapped(RegExp(r'(?<=[a-z])[A-Z]'), (Match m) => ' ${m.group(0)}');

    // Capitalize the very first letter of the result string
    return result[0].toUpperCase() + result.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: withBorder
            ? onlyBottomBorder
                  ? Border(bottom: BorderSide(color: mainStore.isDarkEnable.value ? const Color(0xFF2B2B2B) : const Color(0xFFD6D6D6)))
                  : Border.all(color: mainStore.isDarkEnable.value ? const Color(0xFF2B2B2B) : const Color(0xFFD6D6D6))
            : const Border.fromBorderSide(BorderSide.none),
      ),
      alignment: textalign == TextAlign.right
          ? Alignment.centerRight
          : textalign == TextAlign.center
          ? Alignment.center
          : Alignment.centerLeft,
      child: Wrap(
        children: [
          Text(
            !camalToLabel ? text : makeCamalToLabel(text),
            softWrap: isWrap,
            style: TextStyle(
              color: color ?? (mainStore.isDarkEnable.value ? Colors.blueGrey.shade200 : Colors.grey.shade900),
              fontSize: fontsize,
              fontWeight: fontweight,
              overflow: isWrap ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          if (showRequired) const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

class SelectableTextHelper extends StatelessWidget {
  SelectableTextHelper({
    super.key,
    required this.text,
    this.width,
    this.color,
    this.padding,
    this.showRequired = false,
    this.onlyBottomBorder = false,
    this.withBorder = false,
    this.isWrap = false,
    this.fontsize = 12,
    this.borderRadius = 8,
    this.fontweight = FontWeight.w400,
    this.textalign = TextAlign.left,
    this.bgColor,
  });
  final String text;
  final bool isWrap;
  final bool showRequired;
  final bool onlyBottomBorder;
  final bool withBorder;
  final double fontsize;
  final double borderRadius;
  final double? width;
  final FontWeight? fontweight;
  final TextAlign textalign;
  final Color? color;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;

  MainStore mainStore = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: withBorder
            ? onlyBottomBorder
                  ? Border(bottom: BorderSide(color: mainStore.isDarkEnable.value ? const Color(0xFF2B2B2B) : const Color(0xFFD6D6D6)))
                  : Border.all(color: mainStore.isDarkEnable.value ? const Color(0xFF2B2B2B) : const Color(0xFFD6D6D6))
            : const Border.fromBorderSide(BorderSide.none),
      ),
      alignment: textalign == TextAlign.right
          ? Alignment.centerRight
          : textalign == TextAlign.center
          ? Alignment.center
          : Alignment.centerLeft,
      child: Wrap(
        children: [
          SelectableText(
            text,
            // softWrap: isWrap ,
            style: TextStyle(
              color: color ?? (mainStore.isDarkEnable.value ? Colors.blueGrey.shade200 : Colors.grey.shade900),
              fontSize: fontsize,
              fontWeight: fontweight,
              overflow: isWrap ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ),
          if (showRequired) const Text(' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}

enum MultiSwitchBoxChildType { switchG, radioG }

class MultiSwitchBoxChildG {
  final bool value;
  final bool? groupValue;
  final String label;
  final MultiSwitchBoxChildType type;
  final Function(bool v) onTap;
  MultiSwitchBoxChildG({required this.value, required this.label, required this.onTap, this.groupValue, this.type = MultiSwitchBoxChildType.radioG});
}

class MultiSwitchBoxG extends StatefulWidget {
  final Axis direction;
  final FontWeight fontWeight;
  final double fontSize;
  final List<MultiSwitchBoxChildG> children;
  const MultiSwitchBoxG({super.key, this.direction = Axis.horizontal, required this.children, this.fontWeight = FontWeight.w600, this.fontSize = 12});

  @override
  State<MultiSwitchBoxG> createState() => _MultiSwitchBoxGState();
}

class _MultiSwitchBoxGState extends State<MultiSwitchBoxG> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: widget.direction,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        for (MultiSwitchBoxChildG m in widget.children)
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              m.type == MultiSwitchBoxChildType.radioG
                  ? MoonRadio(
                      value: m.value,
                      groupValue: m.groupValue ?? m.value,
                      onChanged: (v) => m.onTap(v ?? false),
                      activeColor: Colors.green,
                      tapAreaSizeValue: 30,
                    )
                  : MoonSwitch(
                      value: m.value,
                      onChanged: (v) => m.onTap(v),
                      switchSize: MoonSwitchSize.xs,
                      hasHapticFeedback: true,
                      activeTrackColor: Colors.green[400],
                      thumbColor: Colors.blueAccent[300],
                    ),
              GestureDetector(
                onTap: () {
                  m.onTap(!m.value);
                },
                child: TextHelper(text: m.label, fontweight: widget.fontWeight, fontsize: widget.fontSize),
              ),
            ],
          ),
      ],
    );
  }
}

// TEXT BOX WIDGET ========

class TextBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value)? onValueChange;
  final Function(String value)? onSubmitted;
  final Function()? onLongPress;
  final Function()? onTapOutside;
  final double height;
  final double? width;
  final double? fontSize;
  final double borderRadius;
  final bool readonly;
  final bool withBorder;
  final TextInputType keyboard;
  final Widget? leading;
  final Widget? trailing;
  final String? placeholder;
  final String? initialValue;
  final String? labelText;
  final Color? labelTextBackgroundColor;
  final Color? backgroundColor;
  final Function? onTap;
  final bool selectTextOnFocus;
  final bool autofocus;
  final bool withDebounce;
  final bool showAlwaysLabel;
  final bool obscureText;
  final bool makeSubmitOnFocus;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final FocusNode? focusNode;
  final bool onlyBottomBorder;
  final MoonTextInputSize textInputSize;
  final Iterable<String>? autofillHints;
  TextBox({
    super.key,
    this.onValueChange,
    this.onTap,
    this.onTapOutside,
    this.height = 40,
    this.fontSize = 12,
    this.width,
    this.fontWeight = FontWeight.w400,
    this.onlyBottomBorder = false,
    this.readonly = false,
    this.withBorder = true,
    this.withDebounce = true,
    this.showAlwaysLabel = false,
    this.selectTextOnFocus = false,
    this.obscureText = false,
    this.autofocus = false,
    this.makeSubmitOnFocus = false,
    this.focusNode,
    this.textAlign = TextAlign.left,
    this.keyboard = TextInputType.text,
    this.textInputSize = MoonTextInputSize.sm,
    this.labelText,
    this.labelTextBackgroundColor,
    this.backgroundColor,
    this.borderRadius = 8,
    this.leading,
    this.trailing,
    this.placeholder,
    this.onSubmitted,
    this.onLongPress,
    this.autofillHints,
    this.initialValue,
    TextEditingController? controller,
  }) : controller = controller ?? TextEditingController(text: initialValue ?? '');
  MainStore mainStore = Get.find();
  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  bool isActive = false;
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isActive = true;
        });
        if (widget.selectTextOnFocus) {
          widget.controller.selection = TextSelection(baseOffset: 0, extentOffset: widget.controller.value.text.length);
        }
      } else {
        if (widget.makeSubmitOnFocus) {
          makeOnSubmit();
        }
        setState(() {
          isActive = false;
        });
      }
    });
    super.initState();
  }

  void makeOnSubmit() {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (widget.onLongPress != null) {
          widget.onLongPress!();
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          MoonFormTextInput(
            focusNode: focusNode,
            textInputSize: widget.textInputSize,
            height: widget.height,
            width: widget.width,
            readOnly: widget.readonly,
            leading: widget.leading,
            trailing: widget.trailing,
            hintText: widget.showAlwaysLabel ? "" : widget.placeholder ?? (isActive ? '' : widget.labelText),
            controller: widget.controller,
            initialValue: widget.initialValue,
            keyboardType: widget.keyboard,
            autofocus: widget.autofocus,
            obscureText: widget.obscureText,
            textAlign: widget.textAlign,
            autofillHints: widget.autofillHints,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            style: TextStyle(
              // fontSize: 9
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
            inputFormatters: <TextInputFormatter>[if (widget.keyboard == TextInputType.number) FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
            onTap: () {
              if (widget.selectTextOnFocus && widget.controller.selection.end < widget.controller.value.text.length) {
                widget.controller.selection = TextSelection(baseOffset: 0, extentOffset: widget.controller.value.text.length);
              }
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            onSubmitted: (v) => makeOnSubmit(),
            onChanged: (value) {
              if (widget.onValueChange == null) return;
              if (widget.withDebounce) {
                EasyDebounce.debounce(
                  'my-debouncerTextBox', // <-- An ID for this particular debouncer
                  const Duration(milliseconds: 500), // <-- The debounce duration
                  () async => widget.onValueChange!(value), // <-- The target method
                );
              } else {
                widget.onValueChange!(value);
              }
            },
            onTapOutside: (v) {
              focusNode.unfocus();
              // setState(() {
              //   isActive = false;
              // });
              if (widget.onTapOutside != null) {
                widget.onTapOutside!();
              }
            },
            textColor: widget.mainStore.isDarkEnable.value ? Colors.grey[400] : Colors.grey[900],
            backgroundColor: widget.backgroundColor ?? (widget.mainStore.isDarkEnable.value ? Colors.grey[900] : Colors.grey[50]),
            activeBorderColor: (!widget.withBorder && !isActive)
                ? Colors.transparent
                : widget.readonly
                ? widget.mainStore.isDarkEnable.value
                      ? Colors.grey[400]
                      : Colors.grey[400]
                : widget.mainStore.isDarkEnable.value
                ? Colors.green[600]
                : Colors.green[600],
            inactiveBorderColor: !widget.withBorder
                ? Colors.transparent
                : widget.mainStore.isDarkEnable.value
                ? Colors.grey[500]
                : Colors.grey[400],
          ),
          if ((widget.showAlwaysLabel || isActive) && widget.labelText != null && widget.labelText != '')
            Positioned(
              top: 0,
              left: widget.leading == null ? 15 : 30,
              child: Container(
                height: 2,
                width: getTextWidth("${widget.labelText}", TextStyle(fontSize: widget.fontSize ?? 12, fontWeight: FontWeight.w500)),
                color: widget.backgroundColor ?? (widget.mainStore.isDarkEnable.value ? widget.backgroundColor ?? Colors.grey.shade900 : Colors.grey[50]),
              ),
            ),
          if ((widget.showAlwaysLabel || isActive) && widget.labelText != null && widget.labelText != '')
            Positioned(
              top: -8,
              left: widget.leading == null ? 17 : 30,
              child: Container(
                decoration: BoxDecoration(
                  // color: widget.labelTextBackgroundColor ?? widget.backgroundColor ?? (widget.mainStore.isDarkEnable.value ? Colors.grey[800] : Colors.grey[100]),
                  // color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextHelper(
                  text: " ${widget.labelText} ",
                  fontsize: (widget.fontSize! - 1.6),
                  color: (isActive && !widget.readonly)
                      ? Colors.green
                      : widget.mainStore.isDarkEnable.value
                      ? Colors.grey.shade400
                      : Colors.grey[700],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TextAreaBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value)? onValueChange;
  final Function(String value)? onSubmitted;
  final double height;
  final double? width;
  final bool readonly;
  final bool withBorder;
  final TextInputType keyboard;
  final Widget? leading;
  final Widget? trailing;
  final String? placeholder;
  final String? initialValue;
  final String? labelText;
  final Color? labelTextBackgroundColor;
  final Color? backgroundColor;
  final Function? onTap;
  final bool selectTextOnFocus;
  final bool autofocus;
  final bool withDebounce;
  final bool showAlwaysLabel;
  final bool obscureText;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final double fontSize;
  final FontWeight fontWeight;
  final BorderRadiusGeometry? borderRadius;
  TextAreaBox({
    super.key,
    this.onValueChange,
    this.onTap,
    required this.controller,
    this.height = 40,
    this.width,
    this.readonly = false,
    this.withBorder = true,
    this.withDebounce = false,
    this.showAlwaysLabel = false,
    this.selectTextOnFocus = false,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
    this.textAlign = TextAlign.left,
    this.keyboard = TextInputType.text,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w500,
    this.labelText,
    this.labelTextBackgroundColor,
    this.backgroundColor,
    this.leading,
    this.trailing,
    this.placeholder,
    this.borderRadius,
    this.onSubmitted,
    this.initialValue,
  });
  MainStore mainStore = Get.find();
  @override
  _TextAreaBoxState createState() => _TextAreaBoxState();
}

class _TextAreaBoxState extends State<TextAreaBox> {
  bool isActive = false;
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isActive = true;
        });
      } else {
        setState(() {
          isActive = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MoonTextArea(
          focusNode: focusNode,
          textPadding: const EdgeInsets.all(8),
          textStyle: TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight),
          height: widget.height,
          // width: widget.width,
          readOnly: widget.readonly,
          // leading: widget.leading,
          // trailing: widget.trailing,
          hintText: widget.showAlwaysLabel ? "" : widget.placeholder ?? (isActive ? '' : widget.labelText),
          controller: widget.controller,
          initialValue: widget.initialValue,
          // keyboardType: widget.keyboard,
          autofocus: widget.autofocus,
          // obscureText: widget.obscureText,
          textAlign: widget.textAlign,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
          inputFormatters: <TextInputFormatter>[if (widget.keyboard == TextInputType.number) FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
          onTap: () {
            if (widget.selectTextOnFocus) {
              widget.controller.selection = TextSelection(baseOffset: 0, extentOffset: widget.controller.value.text.length);
            }
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          onSubmitted: (v) {
            if (widget.withDebounce) {
              EasyDebounce.debounce(
                'my-debouncerTextBox', // <-- An ID for this particular debouncer
                const Duration(milliseconds: 500), // <-- The debounce duration
                () async {
                  if (widget.onSubmitted != null) {
                    widget.onSubmitted!(widget.controller.text);
                  }
                }, // <-- The target method
              );
            } else {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(widget.controller.text);
              }
            }
          },
          onChanged: (value) {
            if (widget.onValueChange == null) return;
            if (widget.withDebounce) {
              EasyDebounce.debounce(
                'my-debouncerTextBox', // <-- An ID for this particular debouncer
                const Duration(milliseconds: 500), // <-- The debounce duration
                () async => widget.onValueChange!(value), // <-- The target method
              );
            } else {
              widget.onValueChange!(value);
            }
          },
          onTapOutside: (v) {
            focusNode.unfocus();
            setState(() {
              isActive = false;
            });
          },
          textColor: widget.mainStore.isDarkEnable.value ? Colors.grey[400] : Colors.grey[900],
          backgroundColor: widget.mainStore.isDarkEnable.value ? Colors.grey[900] : widget.backgroundColor ?? Colors.grey[50],
          activeBorderColor: !widget.withBorder
              ? Colors.transparent
              : widget.mainStore.isDarkEnable.value
              ? Colors.green[800]
              : Colors.green[700],
          inactiveBorderColor: !widget.withBorder
              ? Colors.transparent
              : widget.mainStore.isDarkEnable.value
              ? Colors.grey[800]
              : Colors.grey[400],
        ),
        if ((widget.showAlwaysLabel || isActive) && widget.labelText != null && widget.labelText != '')
          Positioned(
            top: 0,
            left: widget.leading == null ? 15 : 30,
            child: Container(
              height: 2,
              width: getTextWidth("${widget.labelText}", TextStyle(fontSize: widget.fontSize ?? 12, fontWeight: FontWeight.w500)),
              color: widget.backgroundColor ?? (widget.mainStore.isDarkEnable.value ? widget.backgroundColor ?? Colors.grey.shade900 : Colors.grey[50]),
            ),
          ),
        if ((widget.showAlwaysLabel || isActive) && widget.labelText != null && widget.labelText != '')
          Positioned(
            top: -8,
            left: widget.leading == null ? 17 : 30,
            child: Container(
              decoration: BoxDecoration(
                // color: widget.labelTextBackgroundColor ?? widget.backgroundColor ?? (widget.mainStore.isDarkEnable.value ? Colors.grey[800] : Colors.grey[100]),
                // color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextHelper(
                text: " ${widget.labelText} ",
                fontsize: (widget.fontSize! - 1.6),
                color: (isActive && !widget.readonly)
                    ? Colors.green
                    : widget.mainStore.isDarkEnable.value
                    ? Colors.grey.shade400
                    : Colors.grey[700],
              ),
            ),
          ),
      ],
    );
  }
}

class DatePickerHelper extends StatefulHookWidget {
  final Function(String date)? onValueChange;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? dateFormat;
  final String? placeholder;
  final bool withBorder;
  final bool withClear;
  final bool readOnly;
  final double height;
  final double width;
  final Widget? leading;
  const DatePickerHelper({
    super.key,
    this.onValueChange,
    this.withClear = false,
    this.height = 50,
    this.width = 150,
    this.dateFormat = 'yyyy-MM-dd',
    this.placeholder = "Select Date",
    this.value,
    this.firstDate,
    this.lastDate,
    this.leading,
    this.withBorder = false,
    this.readOnly = false,
  });

  @override
  State<DatePickerHelper> createState() => _DatePickerHelperState();
}

class _DatePickerHelperState extends State<DatePickerHelper> {
  TextEditingController textEditingController = TextEditingController();
  DateTime? d;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      setState(() {
        if (widget.value != null) {
          d = widget.value;
          textEditingController.text = DateFormat(widget.dateFormat).format(widget.value!);
        } else {
          textEditingController.text = "";
        }
      });
    }, [widget.value]);
    return TextBox(
      width: widget.width,
      onTap: () async {
        if (widget.readOnly) {
          return;
        }
        List<DateTime?>? dd0 = await showCalendarDatePicker2Dialog(
          context: context,
          config: CalendarDatePicker2WithActionButtonsConfig(
            allowSameValueSelection: true,
            dynamicCalendarRows: true,
            daySplashColor: Colors.green.shade100,
            selectedDayHighlightColor: Colors.blueAccent.shade200,
            selectedRangeHighlightColor: Colors.blueAccent.shade100.withAlpha(40),
            rangeBidirectional: true,
            animateToDisplayedMonthDate: true,
            calendarType: CalendarDatePicker2Type.single,
            calendarViewMode: CalendarDatePicker2Mode.day,
            firstDayOfWeek: 1,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            weekdayLabelTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            dayTextStylePredicate: ({required date}) => TextStyle(color: DateFormat("EEE").format(date) == "Sun" ? Colors.orange.shade900 : Colors.blueGrey),
          ),
          dialogSize: Size(MediaQuery.sizeOf(context).width * 0.98, 400),
        );
        // DateTime? dd = await showDatePicker(
        //   context: context,
        //   firstDate: DateTime(2000),
        //   initialEntryMode: DatePickerEntryMode.calendarOnly,
        //   initialDate: widget.value ?? DateTime.now(),
        //   lastDate: DateTime(2050),
        //   currentDate: widget.value ?? DateTime.now(),
        // );

        DateTime? dd;
        if (dd0 != null && dd0.isNotEmpty) {
          dd = dd0.first;
        }

        if (dd != null && widget.onValueChange != null) {
          setState(() {
            d = dd;
            textEditingController.text = DateFormat(widget.dateFormat).format(dd!);
          });
          widget.onValueChange!(DateFormat(widget.dateFormat).format(dd));
        }
      },
      onValueChange: (v) {},
      placeholder: widget.placeholder,
      controller: textEditingController,
      withBorder: widget.withBorder,
      backgroundColor: Colors.grey[50],
      height: widget.height,
      leading: widget.leading,
      trailing: widget.withClear
          ? ButtonHelperG(
              onTap: () {
                textEditingController.text = '';
                if (widget.onValueChange != null) {
                  widget.onValueChange!('');
                }
              },
              background: Colors.transparent,
              margin: 0,
              icon: Icon(FontAwesomeIcons.xmark, color: Colors.blueGrey, size: 14),
            )
          : null,
      readonly: true,
    );
  }
}

// SELECT BOX WIDGET ========

class SelectItem {
  final int id;
  final dynamic value;
  SelectItem({required this.id, required this.value});
}

class SelectBoxHelper extends StatefulWidget {
  final List<SelectItem> items;
  final int? value;
  final List<int> valueList;
  final bool isMultiValue;
  final Function(int value) onValueChange;
  final Function(List<int> valuelist)? onMultiValueChange;
  final bool isWrap;
  const SelectBoxHelper({
    super.key,
    required this.items,
    this.isWrap = false,
    this.isMultiValue = false,
    this.value = -1,
    this.valueList = const [-1],
    this.onMultiValueChange,
    required this.onValueChange,
  });

  @override
  State<SelectBoxHelper> createState() => _SelectBoxHelperState();
}

class _SelectBoxHelperState extends State<SelectBoxHelper> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: widget.isWrap
          ? SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...widget.items.map(
                      (m) => GestureDetector(
                        onTap: () {
                          if (widget.isMultiValue && widget.onMultiValueChange != null) {
                            if (widget.valueList.contains(m.id)) {
                              widget.valueList.removeWhere((t) => t == m.id);
                              widget.onMultiValueChange!(widget.valueList);
                            } else {
                              widget.onMultiValueChange!([...widget.valueList, m.id]);
                            }
                          } else {
                            if (widget.value == m.id) {
                              widget.onValueChange(-1);
                            } else {
                              widget.onValueChange(m.id);
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          margin: const EdgeInsets.only(right: 10, bottom: 8),
                          decoration: BoxDecoration(
                            color: widget.isMultiValue
                                ? widget.valueList.contains(m.id)
                                      ? Colors.green[50]
                                      : Colors.white
                                : widget.value == m.id
                                ? Colors.green[50]
                                : Colors.white,
                            // border: Border.all(
                            //     width: 0,
                            //     color: widget.value == m.id
                            //         ? Color(0xFF0676FC)
                            //         : Colors.blueGrey),
                            borderRadius: BorderRadius.circular(50),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Color(0xFF94B6C6), blurRadius: 5)
                            // ]
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.isMultiValue && widget.valueList.contains(m.id)) Icon(FontAwesomeIcons.check, size: 11, color: Colors.green[700]),
                              if (!widget.isMultiValue && widget.value == m.id) Icon(FontAwesomeIcons.check, size: 11, color: Colors.green[700]),
                              if (widget.value == m.id) const SizedBox(width: 6),
                              Text(
                                parseString(data: m.value, defaultValue: ''),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: widget.isMultiValue
                                      ? widget.valueList.contains(m.id)
                                            ? Colors.green[700]
                                            : Colors.black
                                      : widget.value == m.id
                                      ? Colors.green[700]
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              primary: true,
              children: [
                ...widget.items.map(
                  (m) => GestureDetector(
                    onTap: () {
                      widget.onValueChange(m.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      margin: const EdgeInsets.only(right: 10, bottom: 8),
                      decoration: BoxDecoration(
                        color: widget.value == m.id ? Colors.green[50] : Colors.white,
                        border: Border.all(width: 1, color: widget.value == m.id ? Color(0xFF0676FC) : Colors.blueGrey),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [BoxShadow(color: Color(0xFF94B6C6), blurRadius: 5)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.value == m.id) Icon(FontAwesomeIcons.check, size: 15, color: Colors.green[700]),
                          if (widget.value == m.id) const SizedBox(width: 6),
                          Text(
                            parseString(data: m.value, defaultValue: ''),
                            style: TextStyle(color: widget.value == m.id ? Colors.green[700] : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, {this.color = const Color(0x00ffffff)});
}

class AreaChartHelper extends StatelessWidget {
  final List<ChartData> dataSource;
  final LinearGradient gradient;
  final String chartTitle;
  final bool showBorder;
  final bool showXAxis;
  final bool showYAxis;
  final bool enableTooltip;
  final bool tooltipcircle;
  final Color gridYLineColor;
  final Color gridXLineColor;
  final Color borderColor;
  final BorderDrawMode borderDrawMode;
  final Widget Function(dynamic data)? customTooltip;
  AreaChartHelper({
    super.key,
    required this.dataSource,
    this.gradient = const LinearGradient(colors: [Color(0xff6eaeff), Color(0x90dbecff)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    required this.chartTitle,
    this.customTooltip,
    this.showBorder = false,
    this.enableTooltip = true,
    this.showXAxis = true,
    this.showYAxis = true,
    this.gridXLineColor = const Color(0x6ec8c8c8),
    this.gridYLineColor = const Color(0x6ec8c8c8),
    this.borderColor = const Color(0xff00e3ff),
    this.borderDrawMode = BorderDrawMode.excludeBottom,
    this.tooltipcircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: showBorder ? 1 : 0,
      title: ChartTitle(
        text: chartTitle,
        alignment: ChartAlignment.near,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      enableAxisAnimation: false,
      zoomPanBehavior: ZoomPanBehavior(enableMouseWheelZooming: false, enableDoubleTapZooming: false, enablePanning: false),
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.betweenTicks,
        majorGridLines: MajorGridLines(color: gridXLineColor),
        isVisible: showXAxis,
        labelStyle: const TextStyle(fontSize: 11),
        rangePadding: ChartRangePadding.auto,
      ),
      primaryYAxis: CategoryAxis(
        isVisible: showYAxis,
        majorGridLines: MajorGridLines(color: gridYLineColor),
      ),
      series: <CartesianSeries>[
        SplineAreaSeries(
          // FastLineSeries(
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          dataSource: dataSource,
          markerSettings: MarkerSettings(
            isVisible: true,
            shape: tooltipcircle ? DataMarkerType.circle : DataMarkerType.rectangle,
            borderColor: const Color(0xff00e3ff),
            width: 14,
            height: 14,
          ),
          borderDrawMode: borderDrawMode,
          enableTooltip: enableTooltip,
          name: chartTitle,
          isVisibleInLegend: true,
          borderWidth: 2,
          borderColor: borderColor,
          gradient: gradient,
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: Colors.blueAccent[800],
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          if ((customTooltip != null)) {
            return customTooltip!(data);
          } else {
            return Container(
              color: const Color(0xFF040A0E),
              width: 110,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextHelper(text: '${data.x}', color: Colors.green[100], textalign: TextAlign.center),
                  ),
                  Divider(),
                  Container(
                    child: TextHelper(text: '${data.y}', color: Colors.green[100], fontweight: FontWeight.w600, textalign: TextAlign.center),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class BarChartHelper extends StatelessWidget {
  final List<ChartData> dataSource;
  final LinearGradient gradient;
  final String chartTitle;
  final bool showBorder;
  final bool showXAxis;
  final bool showYAxis;
  final bool enableTooltip;
  final bool tooltipcircle;
  final bool isHorizontal;
  final double barWidth;
  final double barSpacing;
  final Color gridYLineColor;
  final Color gridXLineColor;
  final Color tooltipColor;
  final Color borderColor;
  final Widget Function(dynamic data)? customTooltip;
  BarChartHelper({
    super.key,
    required this.dataSource,
    this.gradient = const LinearGradient(colors: [Color(0xff6eaeff), Color(0x90dbecff)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    required this.chartTitle,
    this.customTooltip,
    this.showBorder = false,
    this.enableTooltip = true,
    this.showXAxis = true,
    this.showYAxis = true,
    this.isHorizontal = false,
    this.barWidth = 0.6,
    this.barSpacing = 0.3,
    this.gridXLineColor = const Color(0x6ec8c8c8),
    this.gridYLineColor = const Color(0x6ec8c8c8),
    this.borderColor = const Color(0xff00e3ff),
    this.tooltipColor = const Color(0xff00e3ff),
    this.tooltipcircle = true,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: showBorder ? 1 : 0,
      title: ChartTitle(
        text: chartTitle,
        alignment: ChartAlignment.near,
        textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      enableAxisAnimation: false,
      zoomPanBehavior: ZoomPanBehavior(enableMouseWheelZooming: false, enableDoubleTapZooming: false, enablePanning: false),
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.betweenTicks,
        majorGridLines: MajorGridLines(color: gridXLineColor),
        isVisible: showXAxis,
        labelStyle: TextStyle(fontSize: 11),
        rangePadding: ChartRangePadding.auto,
      ),
      isTransposed: isHorizontal,
      primaryYAxis: CategoryAxis(
        isVisible: showYAxis,
        majorGridLines: MajorGridLines(color: gridYLineColor),
      ),
      series: <CartesianSeries>[
        BarSeries(
          // FastLineSeries(
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          dataSource: dataSource,
          markerSettings: MarkerSettings(
            isVisible: true,
            shape: tooltipcircle ? DataMarkerType.circle : DataMarkerType.rectangle,
            borderColor: tooltipColor,
            width: 14,
            height: 14,
          ),
          width: barWidth,
          spacing: barSpacing,
          enableTooltip: enableTooltip,
          name: chartTitle,
          isVisibleInLegend: true,
          borderWidth: 2,
          borderColor: borderColor,
          gradient: gradient,
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: Colors.blueAccent[800],
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          if ((customTooltip != null)) {
            return customTooltip!(data);
          } else {
            return Container(
              color: Color(0xFF040A0E),
              width: 110,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextHelper(text: '${data.x}', color: Colors.green[100], textalign: TextAlign.center),
                  ),
                  Divider(),
                  Container(
                    child: TextHelper(text: '${data.y}', color: Colors.green[100], fontweight: FontWeight.w600, textalign: TextAlign.center),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PieChartHelper extends StatelessWidget {
  final List<ChartData> dataSource;
  final String chartTitle;
  final int innerRadius;
  final int radius;
  final bool showBorder;
  final bool enableTooltip;
  final bool showLabel;
  final ChartDataLabelPosition labelPositon;
  final Color borderColor;
  final String Function(String)? dataLabelMaper;
  final Widget Function(dynamic data)? customTooltip;
  PieChartHelper({
    super.key,
    required this.dataSource,
    required this.chartTitle,
    this.customTooltip,
    this.dataLabelMaper,
    this.showBorder = false,
    this.showLabel = true,
    this.innerRadius = 0,
    this.radius = 100,
    this.enableTooltip = true,
    this.labelPositon = ChartDataLabelPosition.outside,
    this.borderColor = const Color(0xff00e3ff),
  });

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      title: ChartTitle(
        text: chartTitle,
        alignment: ChartAlignment.near,
        textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      series: <CircularSeries>[
        DoughnutSeries(
          // FastLineSeries(
          pointColorMapper: (data, _) => data.color,
          legendIconType: LegendIconType.circle,
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          dataLabelMapper: (data, _) => dataLabelMaper != null ? dataLabelMaper!(parseString(data: data.y, defaultValue: '')) : data.x,
          dataSource: dataSource,
          enableTooltip: enableTooltip,
          name: chartTitle,
          innerRadius: '$innerRadius%',
          radius: "$radius",
          dataLabelSettings: DataLabelSettings(
            isVisible: showLabel,
            labelPosition: labelPositon,
            connectorLineSettings: const ConnectorLineSettings(type: ConnectorType.line, length: '10%'),
            useSeriesColor: true,
          ),
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: Colors.blueAccent[800],
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          if ((customTooltip != null)) {
            return customTooltip!(data);
          } else {
            return Container(
              color: Color(0xFF040A0E),
              width: 110,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextHelper(text: '${data.x}', color: Colors.green[100], textalign: TextAlign.center),
                  ),
                  Divider(),
                  Container(
                    child: TextHelper(text: '${data.y}', color: Colors.green[100], fontweight: FontWeight.w600, textalign: TextAlign.center),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class DropDownStore extends GetxController {
  RxList<Map<String, dynamic>> list = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> selectedList = <Map<String, dynamic>>[].obs;
  RxString multiSelectionExpandId = ''.obs;
  Rx<TextEditingController> textController = TextEditingController().obs;
  RxBool showList = false.obs;
  RxBool init = false.obs;
  RxMap<String, dynamic> selectedValue = <String, dynamic>{}.obs;
}

class DropDownHelperG extends StatefulHookWidget {
  final String uniqueKey;
  final String displayKey;
  final String treeViewkey;
  final String valueKey;
  final String placeHolder;
  final String? labelText;
  final bool showLabelAlways;
  final bool showBorder;
  final Widget? leading;
  final Widget? trailing;
  final double rowHeight;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final Widget Function(Map<String, dynamic> data)? customRow;
  final void Function(DropDownStore store)? manageRawStore;
  final double listHeight;
  final double borderRadius;
  final Alignment followerAnchor;
  final MoonDropdownAnchorPosition dropDownPosition;
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic> value)? onValueChange;
  final Function(List<Map<String, dynamic>> value)? onMultiValueChange;
  final Function()? onHiding;
  final dynamic value;
  final List<Map<String, dynamic>>? multiSelectValue;
  final bool showClearText;
  final bool isMultiSelect;
  final bool isSearchEnable;
  final Duration transitionDuration;
  final Color? lightModeBackgroundColor;
  DropDownHelperG({
    super.key,
    required this.uniqueKey,
    this.leading,
    this.trailing,
    this.value,
    this.multiSelectValue,
    this.borderRadius = 8,
    this.displayKey = 'name',
    this.treeViewkey = '',
    this.labelText,
    this.showLabelAlways = false,
    this.valueKey = 'id',
    this.placeHolder = 'Search...',
    required this.items,
    this.rowHeight = 30,
    this.height = 50,
    this.fontSize = 13.5,
    this.fontWeight = FontWeight.w500,
    this.transitionDuration = const Duration(milliseconds: 5),
    this.customRow,
    this.listHeight = 200,
    this.showClearText = true,
    this.showBorder = true,
    this.isSearchEnable = false,
    this.isMultiSelect = false,
    this.onValueChange,
    this.onMultiValueChange,
    this.manageRawStore,
    this.onHiding,
    this.followerAnchor = Alignment.topCenter,
    this.lightModeBackgroundColor,
    this.dropDownPosition = MoonDropdownAnchorPosition.bottom,
  });

  @override
  State<DropDownHelperG> createState() => _DropDownHelperGState();
}

class _DropDownHelperGState extends State<DropDownHelperG> {
  late DropDownStore dropDownStore = Get.put(DropDownStore(), tag: widget.uniqueKey);
  MainStore mainStore = Get.find();

  Widget multiSelectWidget(Map<String, dynamic> data) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          if (dropDownStore.selectedList.any((t) => t[widget.valueKey] == data[widget.valueKey])) {
            dropDownStore.selectedList.removeWhere((t) => t[widget.valueKey] == data[widget.valueKey]);
          } else {
            dropDownStore.selectedList.add(data);
          }
          widget.onMultiValueChange!(dropDownStore.selectedList.value);
        },
        child: Row(
          spacing: 2,
          children: [
            SizedBox(
              width: 50,
              child: MoonCheckbox(
                activeColor: Colors.green[50],
                checkColor: Colors.green[800],
                value: dropDownStore.selectedList.any((t) => t[widget.valueKey] == data[widget.valueKey]),
                onChanged: (v) {
                  if (dropDownStore.selectedList.any((t) => t[widget.valueKey] == data[widget.valueKey])) {
                    dropDownStore.selectedList.removeWhere((t) => t[widget.valueKey] == data[widget.valueKey]);
                  } else {
                    dropDownStore.selectedList.add(data);
                  }
                  widget.onMultiValueChange!(dropDownStore.selectedList.value);
                },
              ),
            ),
            Expanded(
              child: TextHelper(text: data[widget.displayKey], fontsize: widget.fontSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget multiSelectWidgetChild(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        dropDownStore.showList.value = true;
      },
      onDoubleTap: () {
        dropDownStore.selectedList.removeWhere((t) => t[widget.valueKey] == data[widget.valueKey]);
        if (widget.onMultiValueChange != null) {
          widget.onMultiValueChange!(dropDownStore.selectedList.value);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Colors.blueGrey[50], borderRadius: BorderRadius.circular(15)),
            child: TextHelper(text: data[widget.displayKey], fontsize: widget.fontSize),
          ),
          Positioned(
            right: -5,
            top: -5,
            child: GestureDetector(
              onTap: () {
                dropDownStore.selectedList.removeWhere((t) => t[widget.valueKey] == data[widget.valueKey]);
                if (widget.onMultiValueChange != null) {
                  widget.onMultiValueChange!(dropDownStore.selectedList.value);
                }
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(color: Colors.grey[500], borderRadius: BorderRadius.circular(10)),
                child: Icon(FontAwesomeIcons.xmark, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget treeViewWidget(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: MoonAccordion(
        shadows: [],
        label: TextHelper(text: data['label']),
        children: [for (Map<String, dynamic> m in data['list']) multiSelectWidget(m)],
      ),
    );
  }

  Widget singleSelectWidget(Map<String, dynamic> data, int index) {
    return GestureDetector(
      onTap: () {
        Timer(const Duration(milliseconds: 200), () {
          dropDownStore.showList.value = false;
          if (widget.onHiding != null) {
            widget.onHiding!();
          }
        });
        if (widget.onValueChange != null) {
          widget.onValueChange!(data);
          dropDownStore.selectedValue.value = makeMapSerialize(data);
          dropDownStore.textController.value.text = parseString(data: dropDownStore.selectedValue[widget.displayKey], defaultValue: '');
        }
      },
      child: widget.customRow != null
          ? widget.customRow!(makeMapSerialize(data))
          : Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: index.isOdd
                    ? mainStore.isDarkEnable.value
                          ? Colors.grey[900]
                          : Colors.grey[50]
                    : mainStore.isDarkEnable.value
                    ? Colors.black87
                    : Colors.white,
              ),
              child: SizedBox(
                height: widget.rowHeight,
                child: TextHelper(isWrap: true, fontsize: widget.fontSize, text: data[widget.displayKey]),
              ),
            ),
    );
  }

  Widget treeViewWidgetSingleSelect(Map<String, dynamic> data) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: MoonAccordion(
        shadows: [],
        label: TextHelper(text: data['label']),
        children: [
          ...(makeListSerialize(data['list'])
              .asMap()
              .map(
                (index, value) => MapEntry(
                  index,
                  Container(
                    margin: EdgeInsets.only(left: 6),
                    padding: EdgeInsets.all(6),
                    child: singleSelectWidget(makeListSerialize(data['list'])[index], index),
                  ),
                ),
              )
              .values
              .toList()),
          // for(Map<String,dynamic> m in data['list'])
          //   multiSelectWidget(m)
        ],
      ),
    );
  }

  List<Map<String, dynamic>> listMaker(List<Map<String, dynamic>> list) {
    if (widget.treeViewkey == '') {
      return list;
    } else {
      List<Map<String, dynamic>> labels = [];
      list.forEach((l) {
        int index = labels.indexWhere((w) => w['label'] == l[widget.treeViewkey]);
        if (index == -1) {
          labels.add({
            'label': l[widget.treeViewkey],
            'list': [l],
          });
        } else {
          labels[index]['list'].add(l);
        }
      });
      return labels;
    }
  }

  @override
  void initState() {
    Timer(const Duration(milliseconds: 600), () {
      dropDownStore.list.value = widget.items;
      dropDownStore.filteredList.value = widget.items;
      dropDownStore.selectedList.value = widget.multiSelectValue ?? [];
      if (widget.value != null && widget.isMultiSelect == false && dropDownStore.init.value == false) {
        dropDownStore.textController.value.text = parseString(data: widget.value![widget.displayKey], defaultValue: '');
        Timer(const Duration(milliseconds: 700), () {
          dropDownStore.init.value = true;
        });
      }
      Timer(const Duration(milliseconds: 500), () {
        if (widget.manageRawStore != null) {
          widget.manageRawStore!(dropDownStore);
        }
      });
    });
    super.initState();
  }

  double getMaxHeight() {
    if (dropDownStore.filteredList.value.isEmpty) {
      return 50;
    }
    return (widget.rowHeight * dropDownStore.filteredList.length) < widget.listHeight
        ? ((widget.rowHeight + 30) * dropDownStore.filteredList.length) > 40
              ? ((widget.rowHeight + 30) * dropDownStore.filteredList.length)
              : 255
        : widget.listHeight;
  }

  @override
  void didUpdateWidget(covariant DropDownHelperG oldWidget) {
    // TODO: implement didUpdateWidget

    if (JsonEncoder().convert(oldWidget.items) != JsonEncoder().convert(widget.items)) {
      dropDownStore.list.value = widget.items;
      dropDownStore.filteredList.value = widget.items;
      dropDownStore.selectedList.value = widget.multiSelectValue ?? [];

      if (mounted) {
        if (dropDownStore.init.value) {
          dropDownStore.textController.value.text = makeMapSerialize(widget.value).isEmpty
              ? ''
              : parseString(
                  data: widget.items.firstWhereOrNull((t) => t[widget.valueKey] == widget.value![widget.valueKey])?[widget.displayKey],
                  defaultValue: '',
                );
        }
      }
    }

    if (JsonEncoder().convert(oldWidget.value) != JsonEncoder().convert(widget.value)) {
      if (mounted) {
        if (dropDownStore.init.value) {
          dropDownStore.textController.value.text = makeMapSerialize(widget.value).isEmpty
              ? ''
              : parseString(
                  data: widget.items.firstWhereOrNull((t) => t[widget.valueKey] == widget.value![widget.valueKey])?[widget.displayKey],
                  defaultValue: '',
                );
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    dropDownStore.init.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => MoonDropdown(
        followerAnchor: widget.followerAnchor,
        dropdownAnchorPosition: widget.dropDownPosition,
        show: dropDownStore.showList.value,
        borderRadius: BorderRadius.circular(5),
        constrainWidthToChild: true,
        transitionDuration: widget.transitionDuration,
        minHeight: 40,
        backgroundColor: mainStore.isDarkEnable.value ? Colors.black87 : Colors.white,
        onTapOutside: () {
          dropDownStore.showList.value = false;
          if (widget.onHiding != null) {
            widget.onHiding!();
          }
        },
        maxHeight: getMaxHeight(),
        content: dropDownStore.filteredList.value.isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [TextHelper(text: "No Data", fontweight: FontWeight.w400)],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(2),
                itemCount: listMaker(dropDownStore.filteredList.value).length,
                itemBuilder: (context, index) => widget.isMultiSelect
                    ? widget.treeViewkey != ''
                          ? treeViewWidget(listMaker(dropDownStore.filteredList.value)[index])
                          : multiSelectWidget(dropDownStore.filteredList.value[index])
                    : widget.treeViewkey != ''
                    ? treeViewWidgetSingleSelect(listMaker(dropDownStore.filteredList.value)[index])
                    : singleSelectWidget(dropDownStore.filteredList.value[index], index),
              ),
        child: widget.isMultiSelect
            ? dropDownStore.selectedList.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [for (Map<String, dynamic> m in dropDownStore.selectedList.value) multiSelectWidgetChild(m)],
                        ),
                      ),
                    )
                  : MoonButton(
                      onTap: () {
                        dropDownStore.showList.value = true;
                      },
                      backgroundColor: Colors.black12,
                      label: TextHelper(text: 'Choose option'),
                    )
            : TextBox(
                leading: widget.leading ?? Icon(MoonIcons.generic_search_24_light),
                readonly: !widget.isSearchEnable,
                placeholder: widget.placeHolder,
                height: widget.height,
                fontSize: widget.fontSize,
                borderRadius: widget.borderRadius,
                labelText: widget.labelText,
                showAlwaysLabel: widget.showLabelAlways,
                trailing:
                    widget.trailing ??
                    (widget.showClearText
                        ? MoonButton.icon(
                            onTap: () {
                              dropDownStore.textController.value.text = '';
                              dropDownStore.selectedValue.value = {};
                              dropDownStore.list.value = widget.items;
                              dropDownStore.filteredList.value = widget.items;
                              dropDownStore.selectedList.value = widget.multiSelectValue ?? [];
                              if (widget.onValueChange != null) {
                                widget.onValueChange!({});
                              }
                            },
                            buttonSize: MoonButtonSize.xs,
                            icon: Icon(FontAwesomeIcons.xmark, size: 14),
                          )
                        : null),
                onTapOutside: () {
                  // dropDownStore.showList.value=false;
                },
                onTap: () {
                  dropDownStore.showList.value = true;
                },
                onValueChange: (v) {
                  EasyDebounce.debounce(widget.uniqueKey, const Duration(milliseconds: 700), () {
                    if (v == '') {
                      dropDownStore.filteredList.value = dropDownStore.list.value;
                      return;
                    }
                    List<Map<String, dynamic>> list = dropDownStore.list.value;
                    dropDownStore.filteredList.value = list.where((t) => t[widget.displayKey].toString().toLowerCase().contains(v.toLowerCase())).toList();
                  });
                },
                withBorder: widget.showBorder,
                backgroundColor: widget.lightModeBackgroundColor,
                controller: dropDownStore.textController.value,
              ),
      ),
    );
  }
}

enum ButtonHelperTypeG { outlined, filled }

enum ButtonHelperDirectionG { vertical, horizontal }

class ButtonHelperG extends StatefulWidget {
  final Widget? label;
  final Color? background;
  final Widget? icon;
  final bool withSound;
  final bool withBorder;
  final double width;
  final double height;
  final double margin;
  final double borderRadius;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final ButtonHelperTypeG type;
  final Function()? onTap;
  final Function()? onDblTap;
  final Function()? onTapDown;
  final Function()? onLongPress;
  final List<BoxShadow>? shadow;
  final ButtonHelperDirectionG direction;
  ButtonHelperG({
    super.key,
    this.label,
    this.background,
    this.icon,
    this.shadow,
    this.width = 40,
    this.height = 40,
    this.borderRadius = 8,
    this.padding = EdgeInsets.zero,
    this.margin = 5,
    this.withSound = true,
    this.withBorder = false,
    this.onTap,
    this.onDblTap,
    this.onLongPress,
    this.onTapDown,
    this.direction = ButtonHelperDirectionG.horizontal,
    this.type = ButtonHelperTypeG.filled,
    this.alignment = Alignment.center,
  });

  @override
  State<ButtonHelperG> createState() => _ButtonHelperGState();
}

class _ButtonHelperGState extends State<ButtonHelperG> {
  MainStore mainStore = Get.find();
  bool isFocused = false;
  bool isHovered = false;
  bool tabbed = false;
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {
        isFocused = focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void makeTabbed() {
    setState(() {
      tabbed = true;
    });
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        tabbed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      onShowHoverHighlight: (v) {
        if (GetPlatform.isDesktop) {
          setState(() {
            isHovered = v;
          });
        }
      },
      onShowFocusHighlight: (v) {
        if (GetPlatform.isDesktop) {
          setState(() {
            isFocused = v;
          });
        }
      },
      enabled: true,
      focusNode: focusNode,
      autofocus: false,
      // onFocusChange: (v) {
      //   if (GetPlatform.isDesktop) {
      //     setState(() {
      //       isFocused = v;
      //     });
      //   }
      // },
      shortcuts: {LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent()},
      actions: {
        ActivateIntent: CallbackAction<Intent>(
          onInvoke: (intent) {
            if (widget.onTap != null) {
              widget.onTap!();
              if (widget.withSound && widget.onTapDown == null) {
                SystemSound.play(SystemSoundType.click);
                // mainStore.audioPlayer.play(AssetSource("click.mp3"),volume: 0.04);
              }
            }
            return null;
          },
        ),
      },
      child: Container(
        padding: widget.padding,
        margin: EdgeInsets.all(widget.margin),
        decoration: BoxDecoration(
          border: isFocused
              ? Border.all(color: mainStore.isDarkEnable.value ? Colors.black : Colors.grey.shade800)
              : widget.withBorder
              ? Border.all(color: mainStore.isDarkEnable.value ? Colors.black : Colors.grey.shade300)
              : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow:
              widget.shadow ??
              [
                BoxShadow(
                  color: widget.background == Colors.transparent
                      ? Colors.transparent
                      : mainStore.isDarkEnable.value
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                  offset: const Offset(0, 0),
                  spreadRadius: 0.005,
                  blurRadius: 10,
                ),
              ],
        ),
        child: GestureDetector(
          onTap: () {
            makeTabbed();
            if (widget.onTap != null) {
              widget.onTap!();
              if (widget.withSound && widget.onTapDown == null) {
                SystemSound.play(SystemSoundType.click);
                // mainStore.audioPlayer.play(AssetSource("click.mp3"),volume: 0.04);
              }
            }
          },
          onLongPress: () {
            if (widget.onLongPress != null) {
              if (widget.withSound) {
                SystemSound.play(SystemSoundType.click);
                // mainStore.audioPlayer.play(AssetSource("click.mp3"),volume: 0.04);
              }
              widget.onLongPress!();
            }
          },
          onDoubleTap: () {
            if (widget.onDblTap != null) {
              widget.onDblTap!();
              if (widget.withSound) {
                SystemSound.play(SystemSoundType.click);
              }
            }
          },
          child: AnimatedContainer(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            width: widget.width,
            height: widget.height,
            alignment: widget.alignment,
            decoration: BoxDecoration(color: widget.background ?? Colors.green, borderRadius: BorderRadius.circular(widget.borderRadius)),
            child: widget.direction == ButtonHelperDirectionG.horizontal
                ? Row(mainAxisSize: MainAxisSize.min, spacing: 5, children: [if (widget.icon != null) widget.icon!, if (widget.label != null) widget.label!])
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 2,
                    children: [if (widget.icon != null) widget.icon!, if (widget.label != null) widget.label!],
                  ),
          ),
        ),
      ),
    );
  }
}

class JsonViewerG extends StatelessWidget {
  final dynamic json;
  final String path;
  final String keyName;
  final bool enableCopy;
  final void Function(String path)? onValueTap;

  const JsonViewerG({Key? key, required this.json, this.path = '', this.onValueTap, this.keyName = '', this.enableCopy = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (json is Map) {
      return MoonAccordion(
        showBorder: false,
        borderColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        expandedBackgroundColor: Colors.transparent,
        shadows: [],
        showDivider: false,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (enableCopy)
              GestureDetector(
                onTap: () {
                  if (onValueTap != null) {
                    onValueTap!(path);
                  }
                },
                child: const Icon(MoonIcons.files_copy_32_regular, size: 20),
              ),
            Expanded(
              child: keyName == ''
                  ? TextHelper(text: (json as Map).toString(), fontweight: FontWeight.w600, color: Colors.blueGrey.shade800)
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (onValueTap != null) {
                              onValueTap!(path);
                            }
                          },
                          child: TextHelper(text: "$keyName: ", fontweight: FontWeight.w600),
                        ),
                        Expanded(
                          child: TextHelper(text: (json as Map).toString(), fontweight: FontWeight.w500, color: Colors.blueGrey.shade600),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        headerPadding: const EdgeInsets.only(left: 5),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: (json as Map<String, dynamic>).entries.map((entry) {
          final newPath = path.isEmpty ? entry.key : '$path.${entry.key}';
          return Padding(
            padding: const EdgeInsets.only(left: 12),
            child: JsonViewerG(json: entry.value, keyName: entry.key, path: newPath, onValueTap: onValueTap),
          );
        }).toList(),
      );
    } else if (json is List) {
      return MoonAccordion(
        showBorder: false,
        borderColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        expandedBackgroundColor: Colors.transparent,
        shadows: [],
        showDivider: false,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (enableCopy) const Icon(MoonIcons.files_copy_32_regular, size: 20),
            Expanded(
              child: keyName == ''
                  ? GestureDetector(
                      onTap: () {
                        if (onValueTap != null) {
                          onValueTap!(path);
                        }
                      },
                      child: TextHelper(text: (json as List).toString(), fontweight: FontWeight.w600, color: Colors.blueGrey.shade800),
                    )
                  : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (onValueTap != null) {
                              onValueTap!(path);
                            }
                          },
                          child: TextHelper(text: "$keyName: ", fontweight: FontWeight.w600),
                        ),
                        Expanded(
                          child: TextHelper(text: makeListSerialize(json).toString(), fontweight: FontWeight.w500, color: Colors.blueGrey.shade600),
                        ),
                      ],
                    ),
            ),
          ],
        ),
        headerPadding: const EdgeInsets.only(left: 5),
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: (json as List).asMap().entries.map((entry) {
          final newPath = '$path[${entry.key}]';
          return Padding(
            padding: const EdgeInsets.only(left: 12),
            child: JsonViewerG(json: entry.value, keyName: entry.key.toString(), path: newPath, onValueTap: onValueTap),
          );
        }).toList(),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          spacing: 8,
          children: [
            GestureDetector(
              onTap: () {
                if (onValueTap != null) {
                  onValueTap!(path);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (enableCopy) const Icon(MoonIcons.files_copy_32_regular, size: 20),
                  TextHelper(text: '$keyName: ', fontweight: FontWeight.w600),
                ],
              ),
            ),
            TextHelper(
              text: ' $json',
              fontweight: FontWeight.w500,
              fontsize: 13,
              color: (json.toString().toLowerCase() == 'true' || json.toString().toLowerCase() == 'false')
                  ? Colors.green.shade600
                  : double.tryParse(json.toString()) != null
                  ? Colors.green.shade600
                  : (json.toString().contains('#') && json.toString().length > 4 && json.toString().length < 9)
                  ? Colors.amber.shade600
                  : Colors.blueGrey.shade600,
            ),
          ],
        ),
      );
    }
  }
}

// HELPER FUNCTIONS ========

showAlert(String content, AlertType alertType, [BuildContext? context, Duration? duration, bool? withUndoBtn, Function? onUndoBtnClick]) {
  final stackTrace = StackTrace.current;
  logG("alert message  - $content \nfrom - $stackTrace");
  MainStore mainStore = Get.find<MainStore>();
  Color? _getColor(AlertType alertType) {
    switch (alertType) {
      case AlertType.error:
        return Colors.red[600];
      case AlertType.success:
        return Colors.green[600];
      default:
        return Colors.green[600];
    }
  }

  Color? getBackgroundColor(AlertType alertType) {
    switch (alertType) {
      case AlertType.error:
        return Colors.red[50];
      case AlertType.success:
        return Colors.green[100];
      default:
        return Colors.green[50];
    }
  }

  Color? getTextColor(AlertType alertType) {
    switch (alertType) {
      case AlertType.error:
        return Colors.red.shade400;
      case AlertType.success:
        return Colors.green.shade500;
      default:
        return Colors.green.shade500;
    }
  }

  Color? getSubTextColor(AlertType alertType) {
    switch (alertType) {
      case AlertType.error:
        return Colors.red.shade400;
      case AlertType.success:
        return Colors.green.shade800;
      default:
        return Colors.green.shade800;
    }
  }

  SnackbarController? _controller;

  _controller = Get.snackbar(
    alertType == AlertType.success
        ? "Success"
        : alertType == AlertType.error
        ? "Error"
        : "Info",
    content,
    mainButton: withUndoBtn == null
        ? null
        : TextButton(
            onPressed: () {
              if (onUndoBtnClick != null) {
                onUndoBtnClick();
                _controller?.close(withAnimations: false);
              }
            },
            child: const Text("Undo", style: TextStyle(fontWeight: FontWeight.w600)),
          ),
    messageText: TextHelper(text: content, fontsize: 12, isWrap: true, fontweight: FontWeight.w600, color: getSubTextColor(alertType)),
    titleText: TextHelper(
      text: alertType == AlertType.success
          ? "Success"
          : alertType == AlertType.error
          ? "Error"
          : "Info",
      fontsize: 14,
      fontweight: FontWeight.w600,
      color: getTextColor(alertType),
    ),
    padding: const EdgeInsets.all(5),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: getBackgroundColor(alertType),
    colorText: _getColor(alertType),
    margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 28),
    borderRadius: 14,
    duration: duration ?? Duration(seconds: alertType == AlertType.error ? 6 : 3),
    icon: alertType == AlertType.success ? Icon(Icons.check_circle, color: _getColor(alertType)) : Icon(Icons.info, color: _getColor(alertType)),
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
  );
  return;
}

Map<String, dynamic> makeMapSerialize(dynamic data) {
  try {
    return Map<String, dynamic>.from(data);
  } catch (e) {
    return {};
  }
}

List<Map<String, dynamic>> makeListSerialize(dynamic data) {
  try {
    return data.map<Map<String, dynamic>>((m) => Map<String, dynamic>.from(m)).toList();
  } catch (e) {
    return [];
  }
}

int parseInt({required dynamic data, required int defaultInt}) {
  try {
    return int.tryParse(parseDouble(data: data.toString(), defaultValue: 0.0).toStringAsFixed(0)) == null
        ? defaultInt
        : int.parse(parseDouble(data: data.toString(), defaultValue: 0.0).toStringAsFixed(0));
  } catch (e) {
    return defaultInt;
  }
}

double parseDouble({required dynamic data, required double defaultValue}) {
  try {
    return double.tryParse(data.toString()) == null ? defaultValue : double.parse(data.toString());
  } catch (e) {
    return defaultValue;
  }
}

String parseDoubleWithLength({required dynamic data, required String defaultValue, int doubleLength = 2}) {
  try {
    return double.tryParse(data.toString()) == null ? defaultValue : double.parse(data.toString()).toStringAsFixed(doubleLength);
  } catch (e) {
    return defaultValue;
  }
}

double parseDoubleWithFixLength({required dynamic data, required double defaultValue, int doubleLength = 2}) {
  try {
    return parseDouble(
      data: double.tryParse(data.toString()) == null ? defaultValue : double.parse(data.toString()).toStringAsFixed(doubleLength),
      defaultValue: 0.0,
    );
  } catch (e) {
    return defaultValue;
  }
}

String parseString({required dynamic data, required String defaultValue}) {
  try {
    if (data == null) return defaultValue;
    return (data.toString() == 'null' || data.toString().trim().isEmpty) ? defaultValue : data.toString();
  } catch (e) {
    return defaultValue;
  }
}

bool parseBool({required dynamic data, required bool defaultValue}) {
  try {
    if (data is bool) return data;
    if (data == null) return defaultValue;
    if (data == 0) return false;
    if (data == "0") return false;
    if (data == 1) return true;
    if (data == "1") return true;
    if (data.toString().toLowerCase() == 'false') return false;
    if (data.toString().toLowerCase() == 'true') return true;
    return defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

String parseIntToString({required dynamic data, required String valueForZero}) {
  try {
    return parseInt(data: data, defaultInt: 0) == 0 ? valueForZero : parseInt(data: data, defaultInt: 0).toString();
  } catch (e) {
    return valueForZero;
  }
}

String parseDateToString({required dynamic data, required dynamic formatDate, required dynamic predefinedDateFormat, required String defaultValue}) {
  try {
    return DateFormat(formatDate).format(DateFormat(predefinedDateFormat).parse(parseString(data: data, defaultValue: '')));
  } catch (e) {
    return defaultValue;
  }
}

DateTime parseStringToDate({required dynamic data, required String predefinedDateFormat, required DateTime defaultValue}) {
  try {
    return DateFormat(predefinedDateFormat).parse(data);
  } catch (e) {
    return defaultValue;
  }
}

DateTime? parseStringToEmptyDate({required dynamic data, required String predefinedDateFormat, required DateTime? defaultValue}) {
  try {
    return DateFormat(predefinedDateFormat).parse(data);
  } catch (e) {
    return defaultValue;
  }
}

DateTimeRange getFinancialYearRange(DateTime date, {int fiscalYearStartMonth = 4, isLastDateIsToday = false}) {
  int year = date.year;
  if (date.month < fiscalYearStartMonth) {
    year--;
  }
  DateTime startDate = DateTime(year, fiscalYearStartMonth, 1);
  DateTime endDate = isLastDateIsToday ? DateTime.now() : DateTime(year + 1, fiscalYearStartMonth, 1).subtract(const Duration(days: 1));
  return DateTimeRange(start: startDate, end: endDate);
}

String currenyFormater({required dynamic value, String format = "##,##,##,##,###.00", bool withDrCr = true, bool isPositiveEqualsDr = false}) {
  String val = parseString(data: value, defaultValue: '').replaceAll(',', '');
  String extra = '';
  if (val.contains('-')) {
    val = val.replaceAll('-', '');
    extra = withDrCr ? "" : '-';
  }
  bool isDouble = false;
  int doubleLen = 0;
  String floatPart = '';
  String intPart = '';
  String reversedFormatStr = '';
  String DrCrString = !withDrCr
      ? ""
      : (!isPositiveEqualsDr &&
            parseDouble(
              data: parseString(data: value, defaultValue: '').replaceAll(',', ''),
              defaultValue: 0.0,
            ).isNegative)
      ? "DR"
      : "CR";
  if (val == '' || parseString(data: format, defaultValue: '') == '') {
    print('Give proper value and format to use currenyFormater ===========>>> Error on currenyFormater');
    return '₹ 0.0';
  }
  if (format.contains('.')) {
    isDouble = true;
    doubleLen = format.substring(format.indexOf('.') + 1).length;
  }
  if (isDouble) {
    val = parseString(
      data: parseDoubleWithLength(data: val, defaultValue: '0.0', doubleLength: doubleLen),
      defaultValue: '',
    );
    floatPart = val.substring(val.indexOf('.'));
    intPart = val.substring(0, val.indexOf('.')).split('').reversed.join('');
    reversedFormatStr = format.substring(0, format.indexOf('.')).split('').reversed.join('');
  } else {
    intPart = val.split('').reversed.join('');
    reversedFormatStr = format.split('').reversed.join('');
  }

  List<int> commaIndexList = [];
  String modifiedVal = '';

  for (int i = 0; i < reversedFormatStr.length; i++) {
    if (reversedFormatStr[i] == ',') {
      commaIndexList.add(i - commaIndexList.length - 1);
    }
  }
  for (int i = 0; i < intPart.length; i++) {
    modifiedVal += intPart[i];
    if (i != intPart.length - 1 && commaIndexList.contains(i)) {
      modifiedVal += ',';
    }
  }
  return '₹ $extra${modifiedVal.split('').reversed.join('')}$floatPart ${parseDouble(
            data: parseString(data: value, defaultValue: '').replaceAll(',', ''),
            defaultValue: 0.0,
          ) == 0 ? "" : DrCrString}';
}

double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371000; // Radius of Earth in meters
  final double phi1 = lat1 * pi / 180; // Convert latitude to radians
  final double phi2 = lat2 * pi / 180; // Convert latitude to radians
  final double deltaPhi = (lat2 - lat1) * pi / 180; // Difference in latitudes
  final double deltaLambda = (lon2 - lon1) * pi / 180; // Difference in longitudes

  final double a = sin(deltaPhi / 2) * sin(deltaPhi / 2) + cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);

  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  final double distance = R * c; // Distance in meters

  return distance;
}

Color hexToColor(String hex) {
  try {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // add alpha if not provided
    }
    return Color(int.parse(hex, radix: 16));
  } catch (e) {
    return Colors.green.shade300;
  }
}

extension HexColor on Color {
  /// Converts this [Color] object to an 8-digit hexadecimal string representation.
  /// The returned string is in the format "#AARRGGBB" if [leadingHashSign] is
  /// `true`, otherwise "AARRGGBB".
  String toHex({bool leadingHashSign = true}) {
    final String hexA = alpha.toRadixString(16).padLeft(2, '0'); // Alpha channel
    final String hexR = red.toRadixString(16).padLeft(2, '0'); // Red channel
    final String hexG = green.toRadixString(16).padLeft(2, '0'); // Green channel
    final String hexB = blue.toRadixString(16).padLeft(2, '0'); // Blue channel
    return '${leadingHashSign ? '#' : ''}' + '$hexA$hexR$hexG$hexB'.toUpperCase(); // Concatenate and convert to uppercase
  }
}

showDatePickerHelper({
  required BuildContext context,
  double borderRadius = 8,
  required DateTimeRange selectedDateRange,
  Function(DateTimeRange)? onValueChange,
}) async {
  DateTimeRange selectedDateTimeRange = selectedDateRange;

  return await showDialog(
    context: context,
    builder: (context) => Center(
      child: Material(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.black,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          width: 350,
          height: 450,
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Select Date Range", style: TextStyle(fontSize: 16)),
              CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  allowSameValueSelection: true,
                  animateToDisplayedMonthDate: true,
                  calendarType: CalendarDatePicker2Type.range,
                  calendarViewMode: CalendarDatePicker2Mode.day,
                  firstDayOfWeek: 1,
                ),
                value: [selectedDateRange.start, selectedDateRange.end],
                onValueChanged: (value) {
                  if (value.length > 1) {
                    selectedDateTimeRange = DateTimeRange(start: DateTime.parse(value[0].toString()), end: DateTime.parse(value[1].toString()));
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MoonTextButton(
                    onTap: () {
                      if (onValueChange != null) {
                        selectedDateTimeRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
                        // print(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
                        onValueChange(DateTimeRange(start: DateTime.now(), end: DateTime.now()));
                      }
                      goBack(context);
                    },
                    label: const Text("Select Today"),
                  ),
                  MoonTextButton(
                    onTap: () {
                      if (onValueChange != null) {
                        // selectedDateRange = selectedDateRange;
                        onValueChange(selectedDateTimeRange!);
                      }
                      goBack(context);
                    },
                    label: const Text("Ok"),
                  ),
                  MoonTextButton(onTap: () => goBack(context), label: const Text("Cancel")),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ),
  );
}

void logG(dynamic message) {
  var logger = Logger(
    printer: PrettyPrinter(
      // methodCount: 2, // Number of method calls to be displayed
      // errorMethodCount: 8, // Number of method calls if stacktrace is provided
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      // Should each log print contain a timestamp
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );
  logger.i(message);
}

int boolToInt(bool data) {
  return data ? 1 : 0;
}

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  String identifier = '';

  if (GetPlatform.isWeb) {
    // Web
    WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
    identifier = '${webInfo.vendor}${webInfo.userAgent}${webInfo.hardwareConcurrency}';
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    identifier = androidInfo.id;
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    identifier = iosInfo.identifierForVendor ?? '';
  } else if (Platform.isMacOS) {
    MacOsDeviceInfo macInfo = await deviceInfoPlugin.macOsInfo;
    identifier = '${macInfo.systemGUID}';
  } else if (Platform.isWindows) {
    WindowsDeviceInfo windowsInfo = await deviceInfoPlugin.windowsInfo;
    identifier = windowsInfo.deviceId;
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfoPlugin.linuxInfo;
    identifier = '${linuxInfo.machineId}';
  } else {
    identifier = 'unknown';
  }

  // Hash the identifier to create a consistent and safe device ID
  var bytes = utf8.encode(identifier);
  var digest = sha256.convert(bytes);

  return digest.toString();
}

class DeviceDetails {
  final String deviceId;
  final String osVersion;
  final String deviceModel;

  DeviceDetails({required this.deviceId, required this.osVersion, required this.deviceModel});
}

Future<DeviceDetails> getDeviceDetails() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  String identifier = 'unknown';
  String osVersion = 'unknown';
  String deviceModel = 'unknown';

  if (GetPlatform.isWeb) {
    final webInfo = await deviceInfoPlugin.webBrowserInfo;
    identifier = '${webInfo.vendor}${webInfo.userAgent}${webInfo.hardwareConcurrency}';
    osVersion = '${webInfo.userAgent}';
    deviceModel = '${webInfo.vendor}';
  } else if (Platform.isAndroid) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    identifier = androidInfo.id;
    osVersion = 'Android ${androidInfo.version.release}';
    deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    identifier = iosInfo.identifierForVendor ?? 'unknown';
    osVersion = 'iOS ${iosInfo.systemVersion}';
    deviceModel = iosInfo.utsname.machine;
  } else if (Platform.isMacOS) {
    final macInfo = await deviceInfoPlugin.macOsInfo;
    identifier = macInfo.systemGUID ?? 'unknown';
    osVersion = macInfo.osRelease;
    deviceModel = macInfo.model;
  } else if (Platform.isWindows) {
    final windowsInfo = await deviceInfoPlugin.windowsInfo;
    identifier = windowsInfo.deviceId;
    osVersion = windowsInfo.productName;
    deviceModel = windowsInfo.computerName;
  } else if (Platform.isLinux) {
    final linuxInfo = await deviceInfoPlugin.linuxInfo;
    identifier = linuxInfo.machineId ?? 'unknown';
    osVersion = linuxInfo.version ?? 'Linux';
    deviceModel = linuxInfo.name;
  }

  // Create a consistent and safe device ID (hashed)
  final bytes = utf8.encode(identifier);
  final digest = sha256.convert(bytes);

  return DeviceDetails(deviceId: digest.toString(), osVersion: osVersion, deviceModel: deviceModel);
}

Future<void> makePhoneCall(String number, BuildContext context) async {
  List<String> numberList = number.split(',');
  if (numberList.length == 1) {
    if (GetPlatform.isAndroid == false) return;
    String phnNo = parseString(data: numberList[0], defaultValue: '');
    if (phnNo == '') return showAlert("No number found to call", AlertType.error, context);
    bool grant = await Permission.phone.request().isGranted;
    if (grant) {
      UssdPhoneCallSms().phoneCall(phoneNumber: "91$phnNo");
    } else {
      bool denied = await Permission.phone.isPermanentlyDenied;
      if (denied) {
        showAlert("Give call permission to conitnue", AlertType.error, context);
        Timer(const Duration(seconds: 1), () {
          openAppSettings();
        });
      } else {
        showAlert("Give call permission to continue", AlertType.error, context);
      }
    }
  } else if (numberList.length > 1) {
    return showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: numberList
                  .map(
                    (m) => GestureDetector(
                      onTap: () async {
                        bool grant = await Permission.phone.request().isGranted;
                        if (grant) {
                          UssdPhoneCallSms().phoneCall(phoneNumber: m);
                        } else {
                          bool denied = await Permission.phone.isPermanentlyDenied;
                          if (denied) {
                            showAlert("Give call permission to conitnue", AlertType.error, context);
                            Timer(const Duration(seconds: 1), () {
                              openAppSettings();
                            });
                          } else {
                            showAlert("Give call permission to conitnue", AlertType.error, context);
                          }
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(color: Colors.blueAccent.shade100.withAlpha(30), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            Container(
                              decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(10)),
                              width: 25,
                              height: 25,
                              child: const Center(child: Icon(MoonIcons.devices_phone_32_regular)),
                            ),
                            TextHelper(
                              text: parseString(data: m, defaultValue: ''),
                              fontsize: 14,
                              fontweight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
  showAlert("No number found to call", AlertType.error, context);
}

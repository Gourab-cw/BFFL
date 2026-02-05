import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';

import '../../app/mainstore.dart';
import 'helper.dart';

class AsyncSelectStore extends GetxController {
  RxBool show = false.obs;
  RxBool loading = false.obs;
  RxList contentList = [].obs;
  RxString selectedId = ("").obs;
}

class AsyncSelect extends StatefulWidget {
  final String uniqueKey;
  final Map<String, dynamic>? queryParameters;
  final String keyValue;
  final String? placeHolder;
  final String displayValue;
  final String serachValue;
  final String? labelText;
  final Widget? leading;
  final Widget? trailing;
  final Color? labelTextBackgroundColor;
  final Color? backgroundColor;
  final Function(dynamic value) onValueChange;
  final Future<List<Map<String, dynamic>>> Function(String q) callContent;
  final Function()? onTapOutside;
  final Function? onTextClear;
  final double maxHeight;
  final FontWeight fontWeight;
  final double contentwidth;
  final double parentHeight;
  final double listHeight;
  final double rowHeight;
  final double borderRadius;
  final double fontSize;
  final bool withClearText;
  final bool disabled;
  final bool autofocus;
  final bool withBorder;
  final bool showAlwaysLabel;
  final bool keepNewItem;
  final Map<String, dynamic>? value;
  final MoonDropdownAnchorPosition dropDownPosition;
  final Function(Function disposeFunction)? getAsyncDispose;
  final Widget Function(Map<String, dynamic> data)? customComponent;

  AsyncSelect({
    super.key,
    required this.onValueChange,
    this.onTapOutside,
    required this.uniqueKey,
    required this.callContent,
    this.queryParameters,
    this.keyValue = 'id',
    this.serachValue = 'q',
    this.maxHeight = 300,
    this.listHeight = 45,
    this.rowHeight = 45,
    this.contentwidth = 200,
    this.parentHeight = 50,
    this.borderRadius = 8,
    this.fontSize = 13.5,
    this.fontWeight = FontWeight.w500,
    this.leading,
    this.trailing,
    this.placeHolder,
    this.labelText,
    this.withClearText = false,
    this.disabled = false,
    this.autofocus = false,
    this.showAlwaysLabel = false,
    this.keepNewItem = false,
    this.onTextClear,
    this.value,
    this.labelTextBackgroundColor,
    this.backgroundColor,
    this.withBorder = false,
    this.getAsyncDispose,
    this.customComponent,
    this.dropDownPosition = MoonDropdownAnchorPosition.bottom,
    this.displayValue = 'name',
  });

  @override
  State<AsyncSelect> createState() => _AsyncSelectState();
}

class _AsyncSelectState extends State<AsyncSelect> {
  MainStore mainStore = Get.find<MainStore>();
  GlobalKey listkey = GlobalKey();
  TextEditingController textEditingController = TextEditingController();
  late AsyncSelectStore asyncSelectStore = Get.put(AsyncSelectStore(), tag: widget.uniqueKey);
  void hideList() {
    asyncSelectStore.show.value = false;
  }

  Future callContents(String text, BuildContext context) async {
    if (textEditingController.text == '') {
      widget.onValueChange({});
      return;
    }
    try {
      asyncSelectStore.loading.value = true;
      List<Map<String, dynamic>> data = await widget.callContent(textEditingController.text);
      if (widget.keepNewItem) {
        asyncSelectStore.contentList.value = [
          if (widget.keepNewItem) {widget.displayValue: textEditingController.text, widget.keyValue: 0, "isNew": true},
          ...makeListSerialize(data),
        ];
      } else {
        asyncSelectStore.contentList.value = data;
      }
      asyncSelectStore.show.value = true;
    } catch (e) {
      showAlert("Error! $e", AlertType.error, context);
    } finally {
      asyncSelectStore.loading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.getAsyncDispose != null) {
      widget.getAsyncDispose!(hideList);
    }
  }

  @override
  void didUpdateWidget(covariant AsyncSelect oldWidget) {
    // TODO: implement didUpdateWidget
    textEditingController.text = parseString(data: widget.value?[widget.displayValue], defaultValue: "");
    // asyncSelectStore.contentList.value = [];
    asyncSelectStore.update();
    super.didUpdateWidget(oldWidget);
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   logG(widget.value);
  //   if (widget.value != null) {
  //     textEditingController.text = widget.value![widget.displayValue] ?? '';
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      textEditingController.text = widget.value![widget.displayValue] ?? '';
    }

    return Obx(() {
      return MoonDropdown(
        show: asyncSelectStore.show.value,
        constrainWidthToChild: true,
        maxWidth: widget.contentwidth,
        maxHeight: asyncSelectStore.contentList.isEmpty
            ? 50
            : widget.listHeight >= widget.maxHeight
            ? widget.listHeight + 40
            : asyncSelectStore.contentList.isEmpty
            ? 60
            : asyncSelectStore.contentList.length * widget.rowHeight > widget.maxHeight
            ? widget.maxHeight
            : asyncSelectStore.contentList.length * widget.rowHeight > widget.rowHeight
            ? asyncSelectStore.contentList.length * widget.rowHeight
            : widget.rowHeight,
        minHeight: asyncSelectStore.contentList.isEmpty ? 40 : widget.listHeight,
        transitionCurve: Curves.decelerate,
        dropdownAnchorPosition: widget.dropDownPosition,
        backgroundColor: mainStore.isDarkEnable.value ? const Color.fromARGB(255, 15, 15, 15) : Colors.grey[50],
        onTapOutside: () {
          dynamic value = asyncSelectStore.contentList.firstWhereOrNull((t) => t[widget.keyValue] == asyncSelectStore.selectedId);

          // asyncSelectStore.show.value = false;
          if (value != null) {
            textEditingController.text = value?[widget.displayValue];
          } else {
            textEditingController.text = '';
          }
          if (widget.onTapOutside != null) {
            widget.onTapOutside!();
          }
          asyncSelectStore.show.value = false;
        },
        content: asyncSelectStore.contentList.isEmpty
            // ignore: avoid_unnecessary_containers
            ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("No data found")])
            : SizedBox(
                height: asyncSelectStore.contentList.isEmpty
                    ? 60
                    : asyncSelectStore.contentList.length * 35 > widget.maxHeight
                    ? widget.maxHeight
                    : asyncSelectStore.contentList.length * 35 > widget.rowHeight
                    ? asyncSelectStore.contentList.length * 35
                    : widget.rowHeight,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: asyncSelectStore.contentList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (asyncSelectStore.contentList[index] == null) {
                          return;
                        }
                        dynamic c = asyncSelectStore.contentList[index];
                        asyncSelectStore.selectedId.value = parseString(data: c[widget.keyValue], defaultValue: "");
                        textEditingController.clear();
                        // if (onTextClear != null) {
                        //   onTextClear!();
                        // }
                        dynamic value = asyncSelectStore.contentList.firstWhereOrNull((t) => t[widget.keyValue] == c[widget.keyValue]);
                        // textEditingController.text = value?[widget.displayValue] ?? '';
                        asyncSelectStore.show.value = false;
                        if (value != null) {
                          widget.onValueChange(value);
                        }
                        if (widget.onTapOutside != null) {
                          widget.onTapOutside!();
                        }
                      },
                      child: widget.customComponent != null
                          ? widget.customComponent!(asyncSelectStore.contentList[index])
                          : Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              width: widget.contentwidth,
                              decoration: BoxDecoration(
                                // color: Colors.red,
                                color: mainStore.isDarkEnable.value
                                    ? index % 2 != 0
                                          ? Colors.grey[900]
                                          : const Color.fromARGB(255, 41, 40, 40)
                                    : index % 2 != 0
                                    ? Colors.grey[200]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  spacing: 5,
                                  children: [
                                    if (parseBool(data: asyncSelectStore.contentList[index]?["isNew"], defaultValue: false))
                                      Icon(Icons.info_outline, size: 18, color: Colors.blueAccent.shade100),
                                    Expanded(
                                      child: TextHelper(
                                        text: parseString(data: asyncSelectStore.contentList[index]?[widget.displayValue], defaultValue: 'No text found!'),
                                        isWrap: true,
                                        fontsize: widget.fontSize,
                                        fontweight: widget.fontWeight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    );
                  },
                ),
              ),
        child: Opacity(
          opacity: widget.disabled ? 1 : 1,
          child: TextBox(
            height: widget.parentHeight,
            controller: textEditingController,
            onlyBottomBorder: true,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            leading: widget.leading,
            labelTextBackgroundColor: widget.labelTextBackgroundColor,
            autofocus: widget.autofocus,
            trailing: asyncSelectStore.loading.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: MoonCircularLoader(
                          backgroundColor: mainStore.isDarkEnable.value ? Colors.black : Colors.grey[300],
                          strokeWidth: 2,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : widget.withClearText
                ? GestureDetector(
                    onTap: () {
                      if (widget.disabled) {
                        return;
                      }
                      textEditingController.clear();
                      if (widget.onTextClear != null) {
                        widget.onTextClear!();
                      }
                    },
                    child: const MouseRegion(cursor: SystemMouseCursors.click, child: Icon(MoonIcons.controls_close_24_regular, size: 18)),
                  )
                : widget.trailing,
            placeholder: widget.placeHolder,
            showAlwaysLabel: widget.showAlwaysLabel,
            labelText: widget.labelText,
            withBorder: widget.withBorder,
            backgroundColor: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            readonly: widget.disabled,
            onValueChange: (value) async {
              EasyDebounce.debounce(
                'my-debouncer', // <-- An ID for this particular debouncer
                const Duration(milliseconds: 300), // <-- The debounce duration
                () async {
                  try {
                    await callContents("?${widget.serachValue}=$value", context);
                  } catch (e) {
                    showAlert("$e", AlertType.error, context);
                  }
                }, // <-- The target method
              );
              // setState(() {
              //   show = true;
              // });
            },
          ),
        ),
      );
    });
  }
}

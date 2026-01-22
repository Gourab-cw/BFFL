import 'dart:async';
import 'dart:convert';
import 'package:healthandwellness/core/utility/helper.dart';

import '../../app/mainstore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum DropDownStylingMode { defaultStyle, underlineStyle }

class DropDownHelperStore extends GetxController {
  var currentlyOpenAccordionItem = ''.obs;
}

class DropDownHelper extends StatefulHookWidget {
  final String placeholder;
  final List<dynamic> items;
  final List<dynamic>? multiselectedId;
  final String labelExpr;
  final String valueExpr;
  final String? iconExpr;
  final bool withIcon;
  final Widget? parentLeadingIcon;
  final String selectedId;
  final Function onValueChange;
  final TextEditingController localTextController = TextEditingController();
  final Widget? selectedLeadingIcon;
  final MoonDropdownAnchorPosition dropDownPosition;
  final bool expandAll;
  final bool withSearch;
  final bool selectOnFocus;
  final bool withTreeView;
  final bool autofocus;
  final String? treeViewParentExpr;
  final bool withMultiSelect;
  final bool withBorder;
  final bool disable;
  final Alignment followerAnchor;
  final double height;
  final double listheight;
  final double width;
  final double childFontSize;
  final double multiSelectButtonHeight;
  final Color? lightModeBackgroundColor;
  final Widget? customWidgetForBlankData;
  final Function? onTap;
  final DropDownStylingMode stylingMode;
  // dynamic _currentlyOpenAccordionItem = '';
  DropDownHelper({
    super.key,
    required this.items,
    required this.labelExpr,
    required this.valueExpr,
    required this.selectedId,
    this.multiselectedId,
    required this.onValueChange,
    this.parentLeadingIcon,
    this.iconExpr,
    this.withIcon = false,
    this.withBorder = true,
    this.disable = false,
    this.placeholder = "Choose an option",
    this.selectedLeadingIcon,
    this.withSearch = false,
    this.selectOnFocus = false,
    this.withTreeView = false,
    this.expandAll = false,
    this.withMultiSelect = false,
    this.autofocus = false,
    this.multiSelectButtonHeight = 40,
    this.childFontSize = 13,
    this.treeViewParentExpr,
    this.listheight = 80,
    this.width = 200,
    this.height = 50,
    this.lightModeBackgroundColor,
    this.customWidgetForBlankData,
    this.followerAnchor = Alignment.topCenter,
    this.onTap,
    this.stylingMode = DropDownStylingMode.defaultStyle,
    this.dropDownPosition = MoonDropdownAnchorPosition.bottom,
  });

  @override
  State<DropDownHelper> createState() => _DropDownHelperState();
}

class _DropDownHelperState extends State<DropDownHelper> {
  bool _showChoices = false;
  MainStore mainStore = Get.find();
  List<dynamic> itemList = [];
  List<dynamic> multiSelectItemList = [];
  TextEditingController selectedTextController = TextEditingController();
  DropDownHelperStore dropDownHelperStore = Get.put(DropDownHelperStore());
  FocusNode textFocusNode = FocusNode();

  bool isDevelopment = true;

  getSelectedIdLabel(String selectedId) {
    if (selectedId == '') return;
    var index = widget.items.indexWhere(
      (f) => f[widget.valueExpr]!.toString() == selectedId,
    );
    if (index != -1) {
      setState(() {
        selectedTextController.text = parseString(
          data: makeMapSerialize(widget.items[index])[widget.labelExpr ?? ''],
          defaultValue: '',
        );
      });
    } else {
      setState(() {
        selectedTextController.text = '';
      });
    }
  }

  getLeadingWidget(String id, List<dynamic> list) {
    int x = list.indexWhere((f) => f[widget.valueExpr].toString() == id);
    Color color;
    if (x != -1) {
      color = Color(
        int.parse(
          'FF${list[x][widget.iconExpr]!.toString().replaceAll('#', '')}',
          radix: 16,
        ),
      );
    } else {
      color = const Color.fromRGBO(255, 255, 255, 0);
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: color,
        ),
      ),
    );
  }

  filterSearchItems(String text) {
    List filtered = widget.items
        .where(
          (f) =>
              f[widget.labelExpr] != null &&
              f[widget.labelExpr]!.toString().toLowerCase().contains(
                text.toLowerCase(),
              ),
        )
        .toList();
    setState(() {
      itemList = filtered;
    });
  }

  List makeTreeViewList(List list) {
    Map parents = {};

    for (Map l in list) {
      if (!parents.keys.contains(l[widget.treeViewParentExpr])) {
        parents.addAll({
          l[widget.treeViewParentExpr]: list
              .where(
                (w) =>
                    w[widget.treeViewParentExpr] ==
                    l[widget.treeViewParentExpr],
              )
              .toList(),
        });
      }
    }
    List data = [];
    for (dynamic m in parents.keys) {
      data.add({
        "type": "parent",
        "identityValue": m,
        "label": m,
        "children": parents[m],
      });
    }
    return data;
  }

  @override
  void initState() {
    setState(() {
      itemList = widget.withTreeView
          ? makeTreeViewList(jsonDecode(jsonEncode(widget.items)))
          : widget.items;
      if (widget.multiselectedId != null) {
        multiSelectItemList = [...widget.multiselectedId!];
      }
    });
    getSelectedIdLabel(widget.selectedId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        getSelectedIdLabel(widget.selectedId);
        return () {
          dropDownHelperStore.currentlyOpenAccordionItem.value = '';
          // dispose
        };
      },
      [widget.selectedId], // didUpdateWidget
    );
    useEffect(
      () {
        getSelectedIdLabel(widget.selectedId);
        setState(() {
          itemList = widget.withTreeView
              ? makeTreeViewList(jsonDecode(jsonEncode(widget.items)))
              : widget.items;
          if (widget.multiselectedId != null) {
            multiSelectItemList = [...widget.multiselectedId!];
          }
        });
      },
      [widget.items], // didUpdateWidget
    );
    return Obx(() {
      return SizedBox(
        height: widget.withMultiSelect ? 50 : widget.height,
        width: widget.width,
        child: MoonDropdown(
          // routeObserver: routeObserver,
          followerAnchor: widget.followerAnchor,
          dropdownAnchorPosition: widget.dropDownPosition,
          borderRadius: BorderRadius.circular(10),
          dropdownShadows: const [
            BoxShadow(color: Color(0xAB9F9F9F), blurRadius: 5, spreadRadius: 1),
          ],
          // minHeight: 80,
          distanceToTarget: widget.withMultiSelect ? 0 : 10,
          maxHeight: widget.listheight,
          show: widget.disable ? false : _showChoices,
          backgroundColor: mainStore.isDarkEnable.value
              ? Colors.grey[900]
              : widget.lightModeBackgroundColor ?? Colors.grey[50],
          constrainWidthToChild: true,
          onTapOutside: () => setState(() {
            _showChoices = false;
            selectedTextController.text = '';
            getSelectedIdLabel(widget.selectedId);
          }),
          content: Container(
            height: itemList.length * 40 > widget.listheight
                ? widget.listheight
                : itemList.length * 50,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: mainStore.isDarkEnable.value
                  ? Colors.grey[900]
                  : widget.lightModeBackgroundColor ?? Colors.grey[50],
              borderRadius: BorderRadius.circular(26),
            ),
            child: widget.withTreeView
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: itemList.length,
                    itemBuilder: (context, index) => MoonAccordion(
                      borderColor: const Color.fromARGB(255, 136, 136, 136),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      label: Text(
                        itemList[index]['label'],
                        style: TextStyle(
                          color: mainStore.isDarkEnable.value
                              ? Colors.grey[500]
                              : Colors.grey[700],
                        ),
                      ),
                      identityValue: itemList[index]['identityValue'],
                      childrenPadding: const EdgeInsets.all(12),
                      iconColor: mainStore.isDarkEnable.value
                          ? Colors.grey[500]
                          : Colors.grey[700],
                      expandedIconColor: mainStore.isDarkEnable.value
                          ? Colors.grey[500]
                          : Colors.grey[700],
                      initiallyExpanded: widget.expandAll,
                      groupIdentityValue:
                          dropDownHelperStore.currentlyOpenAccordionItem.value,
                      onExpansionChanged: (value) => setState(
                        () =>
                            dropDownHelperStore
                                .currentlyOpenAccordionItem
                                .value = value
                                .toString(),
                      ),
                      children: List.generate(
                        itemList[index]['children'].length,
                        (x) => MoonMenuItem(
                          absorbGestures: true,
                          onTap: () {
                            if (widget.withMultiSelect) {
                              setState(() {
                                multiSelectItemList.any(
                                      (r) =>
                                          r ==
                                          itemList[index]['children'][x][widget
                                              .valueExpr],
                                    )
                                    ? multiSelectItemList.removeWhere(
                                        (r) =>
                                            r ==
                                            itemList[index]['children'][x][widget
                                                .valueExpr],
                                      )
                                    : multiSelectItemList.add(
                                        itemList[index]['children'][x][widget
                                            .valueExpr],
                                      );
                              });
                              Timer(const Duration(milliseconds: 700), () {
                                widget.onValueChange(multiSelectItemList);
                              });
                              return;
                            }
                            widget.onValueChange(
                              itemList[index]['children'][x][widget.valueExpr],
                            );
                            setState(() {
                              _showChoices = false;
                              itemList = widget.withTreeView
                                  ? makeTreeViewList(
                                      jsonDecode(jsonEncode(widget.items)),
                                    )
                                  : widget.items;
                            });
                          },

                          label: Row(
                            children: [
                              widget.withIcon
                                  ? getLeadingWidget(
                                      itemList[index]['children'][x]![widget
                                              .valueExpr]
                                          .toString(),
                                      widget.items,
                                    )
                                  : Container(),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  itemList[index]['children'][x][widget
                                          .labelExpr] ??
                                      "",
                                  style: TextStyle(
                                    color: mainStore.isDarkEnable.value
                                        ? Colors.grey[100]
                                        : Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          leading: widget.withMultiSelect
                              ? MoonCheckbox(
                                  tapAreaSizeValue: 10,
                                  value: multiSelectItemList.any(
                                    (r) =>
                                        r ==
                                        itemList[index]['children'][x][widget
                                            .valueExpr],
                                  ),
                                  onChanged: (v) {
                                    setState(() {
                                      if (v == true) {
                                        multiSelectItemList.add(
                                          itemList[index]['children'][x][widget
                                              .valueExpr],
                                        );
                                      } else {
                                        multiSelectItemList.removeWhere(
                                          (r) =>
                                              r ==
                                              itemList[index]['children'][x][widget
                                                  .valueExpr],
                                        );
                                      }
                                    });
                                  },
                                )
                              : Container(),
                          // trailing: MoonCheckbox(
                          //   value: _availableChoices[Choices.values[index]],
                          //   tapAreaSizeValue: 0,
                          //   onChanged: (_) {},
                          // ),
                        ),
                        // shrinkWrap: false,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: itemList.length,
                    itemBuilder: (context, index) => MoonMenuItem(
                      height: 45,
                      verticalGap: 5,
                      absorbGestures: true,
                      backgroundColor: index % 2 != 0
                          ? Colors.grey[200]
                          : Colors.grey[50],
                      onTap: () {
                        if (widget.withMultiSelect) {
                          setState(() {
                            multiSelectItemList.any(
                                  (r) => r == itemList[index][widget.valueExpr],
                                )
                                ? multiSelectItemList.removeWhere(
                                    (r) =>
                                        r == itemList[index][widget.valueExpr],
                                  )
                                : multiSelectItemList.add(
                                    itemList[index][widget.valueExpr],
                                  );
                          });
                          Timer(const Duration(milliseconds: 700), () {
                            widget.onValueChange(multiSelectItemList);
                          });
                          return;
                        }
                        widget.onValueChange(itemList[index][widget.valueExpr]);
                        setState(() {
                          _showChoices = false;
                          itemList = widget.withTreeView
                              ? makeTreeViewList(
                                  jsonDecode(jsonEncode(widget.items)),
                                )
                              : widget.items;
                        });
                      },
                      label: Row(
                        children: [
                          widget.withIcon
                              ? getLeadingWidget(
                                  itemList[index]![widget.valueExpr].toString(),
                                  itemList,
                                )
                              : Container(),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextHelper(
                              text: parseString(
                                data: itemList[index][widget.labelExpr],
                                defaultValue: '',
                              ),
                              color: mainStore.isDarkEnable.value
                                  ? Colors.grey[100]
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      leading: widget.withMultiSelect
                          ? MoonCheckbox(
                              tapAreaSizeValue: 10,
                              value: multiSelectItemList.any(
                                (r) => r == itemList[index][widget.labelExpr],
                              ),
                              onChanged: (v) {
                                setState(() {
                                  if (v == true) {
                                    multiSelectItemList.add(
                                      itemList[index][widget.labelExpr],
                                    );
                                  } else {
                                    multiSelectItemList.removeWhere(
                                      (r) =>
                                          r ==
                                          itemList[index][widget.labelExpr],
                                    );
                                  }
                                });
                              },
                            )
                          : Container(),

                      // trailing: MoonCheckbox(
                      //   value: _availableChoices[Choices.values[index]],
                      //   tapAreaSizeValue: 0,
                      //   onChanged: (_) {},
                      // ),
                    ),
                    shrinkWrap: false,
                  ),
          ),
          child: widget.withMultiSelect
              ? SizedBox(
                  width: 350,
                  height: widget.multiSelectButtonHeight + 8,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.disable) return;
                      setState(() => _showChoices = !_showChoices);
                    },
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 8, right: 10),
                      scrollDirection: Axis.horizontal,
                      child: multiSelectItemList.isEmpty
                          ? widget.customWidgetForBlankData ??
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainStore.isDarkEnable.value
                                        ? Colors.grey[900]
                                        : widget.lightModeBackgroundColor ??
                                              Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(widget.placeholder),
                                  ),
                                )
                          : Row(
                              children: multiSelectItemList
                                  .map(
                                    (m) => Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: mainStore.isDarkEnable.value
                                                ? const Color.fromARGB(
                                                    255,
                                                    119,
                                                    117,
                                                    112,
                                                  )
                                                : const Color.fromARGB(
                                                    255,
                                                    236,
                                                    236,
                                                    236,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Text(
                                            widget.items.firstWhereOrNull(
                                                  (f) =>
                                                      f[widget.valueExpr] == m,
                                                )![widget.labelExpr] ??
                                                'NA##',
                                            style: TextStyle(
                                              fontSize: widget.childFontSize,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: -5,
                                          top: -6,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                multiSelectItemList.removeWhere(
                                                  (f) => f == m,
                                                );
                                              });
                                              Timer(
                                                const Duration(
                                                  milliseconds: 700,
                                                ),
                                                () {
                                                  widget.onValueChange(
                                                    multiSelectItemList,
                                                  );
                                                },
                                              );
                                              return;
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red[300],
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ),
                )
              : MoonTextInput(
                  height: widget.height,
                  readOnly: !widget.withSearch,
                  autofocus: widget.autofocus,
                  focusNode: textFocusNode,
                  controller: selectedTextController,
                  canRequestFocus: widget.withSearch,
                  mouseCursor: MouseCursor.defer,
                  // backgroundColor:
                  //     mainStore.isDarkEnable.value ? Colors.grey[600] : Colors.white,
                  textColor: mainStore.isDarkEnable.value
                      ? Colors.grey[400]
                      : Colors.grey[900],
                  backgroundColor: mainStore.isDarkEnable.value
                      ? Colors.grey[900]
                      : widget.lightModeBackgroundColor ?? Colors.grey[50],
                  activeBorderColor: widget.withBorder
                      ? mainStore.isDarkEnable.value
                            ? Colors.grey[800]
                            : Colors.grey[700]
                      : Colors.transparent,
                  inactiveBorderColor:
                      widget.stylingMode == DropDownStylingMode.underlineStyle
                      ? mainStore.isDarkEnable.value
                            ? Colors.grey[800]
                            : Colors.grey[600]
                      : widget.withBorder
                      ? mainStore.isDarkEnable.value
                            ? Colors.grey[800]
                            : Colors.grey[300]
                      : Colors.transparent,
                  decoration: BoxDecoration(
                    color: mainStore.isDarkEnable.value
                        ? Colors.grey[900]
                        : widget.lightModeBackgroundColor ?? Colors.grey[50],
                    borderRadius: BorderRadius.circular(
                      widget.stylingMode == DropDownStylingMode.underlineStyle
                          ? 0
                          : 5,
                    ),
                    border:
                        widget.stylingMode == DropDownStylingMode.underlineStyle
                        ? Border(
                            bottom: BorderSide(
                              color: widget.withBorder
                                  ? mainStore.isDarkEnable.value
                                        ? const Color(0xffbfbfbf)
                                        : const Color(0xffbfbfbf)
                                  : mainStore.isDarkEnable.value
                                  ? const Color(0xFF323232)
                                  : const Color(0xffbfbfbf),
                            ),
                          )
                        : Border.all(
                            color: widget.withBorder
                                ? mainStore.isDarkEnable.value
                                      ? const Color(0xffbfbfbf)
                                      : const Color(0xffbfbfbf)
                                : mainStore.isDarkEnable.value
                                ? const Color(0xFF323232)
                                : const Color(0xbfbfbf),
                          ),
                  ),
                  hintText: widget.placeholder,
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!();
                    }
                    if (widget.selectOnFocus) {
                      selectedTextController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: selectedTextController.text.length,
                      );
                    }
                    if (widget.disable) return;
                    setState(() => _showChoices = !_showChoices);
                  },
                  onChanged: (text) {
                    filterSearchItems(text);
                  },
                  leading: widget.withIcon
                      ? getLeadingWidget(
                          widget.selectedId.toString(),
                          widget.items,
                        )
                      : widget.parentLeadingIcon,
                  trailing: Center(
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: _showChoices ? -0.5 : 0,
                      child: const Icon(
                        MoonIcons.controls_chevron_down_small_16_light,
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}

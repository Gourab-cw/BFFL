import 'dart:math' as math;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';

import '../core/utility/daterangepicker.dart';
import '../core/utility/helper.dart';
import 'date_filter_calculation.dart';
import 'mainstore.dart';

enum DataGridSortingEnum { ascending, descending }

class DataGridSortingType {
  final int index;
  final DataGridSortingEnum type;
  DataGridSortingType({required this.index, required this.type});
}

class DataGridHelperStore3 extends GetxController {
  RxList<Map<String, int>> editableCell = [
    {"row": -1, "cell": -1},
  ].obs;
  RxList selectedRow = [].obs;
  TextEditingController searchBoxController = TextEditingController();
  TextEditingController editCellTextController = TextEditingController();
  RxList uniqueFilterList = [].obs;
  RxList<int> filterShowIndex = <int>[].obs;
  RxList<String> filterOpenIndex = <String>[].obs;
  RxList<Map<String, dynamic>> filteredData = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredDataSource =
      <Map<String, dynamic>>[].obs;
  List<DataRow> rows = <DataRow>[].obs;
  RxDouble footerWidth = (0.0).obs;
  RxInt totalPage = 0.obs;
  RxInt currentPageIndex = 0.obs;
  RxBool isPaginate = false.obs;
  bool showFilter = false;

  Map<String, List<String>> globalFilters = {};

  TextEditingController globalFilterSearchController = TextEditingController();

  void makeGlobalFilter(
    List<DataGridColumnModel3> column,
    List<Map<String, dynamic>> dataSource,
  ) {
    List<String> columnName = column.map((m) => m.dataField).toList();
    // filteredDataSource.value = dataSource;
    filteredDataSource.value = filteredDataSource.value.where((w) {
      return columnName.any(
        (x) => w[x].toString().toLowerCase().contains(
          searchBoxText.value.toLowerCase(),
        ),
      );
    }).toList();
    if (globalFilters.isNotEmpty) {
      globalFilters.forEach((key, value) {
        filteredDataSource.value = filteredDataSource.value.where((w) {
          return value.any(
            (x) => w[key].toString().toLowerCase().contains(x.toLowerCase()),
          );
        }).toList();
      });
    }
    update();
  }

  Rxn<DataGridSortingType> sortingColumn = Rxn<DataGridSortingType>(null);
  // Filter property
  TextEditingController filterTextController = TextEditingController();
  RxString filteredSearchText = ''.obs;
  RxString searchBoxText = ''.obs;
}

class CellUpdateValue3 {
  final int rowIndex;
  final int colIndex;
  final String colName;
  final String value;
  final Map<String, dynamic> rowValue;

  CellUpdateValue3({
    required this.rowIndex,
    required this.colIndex,
    required this.colName,
    required this.value,
    required this.rowValue,
  });
}

class CellCoordinate {
  final int xIndex;
  final int yIndex;
  CellCoordinate({required this.xIndex, required this.yIndex});
}

class DataGridHelper3 extends StatefulHookWidget {
  final List<Map<String, dynamic>> dataSource;
  final List<DataGridColumnModel3> columnList;
  final DataGridHelperStore3? controller;
  final Widget? noDataWidget;
  final Color headerColor;
  final Color headerFontColor;
  final Color? backgroundColor;
  final bool showSelection;
  final bool showFooter;
  final bool showBorderVertical;
  final Color? footerColor;
  final Color borderColor;
  final Color alternateRowColor;
  final double fontSize;
  final double headerFontSize;
  final bool withPaginate;
  final int defaultPageSize;
  final double columnSpacing;
  final double rowSpacing;
  final double width;
  final double rowHeight;
  final double headerHeight;
  final bool showAlternateColor;
  final bool withBorder;
  final bool withSearch;
  final bool hideHeader;
  final String uniqueKey;
  final List<String>? filterList;
  final int columnFixCount;
  final Function(CellUpdateValue3)? onCellValueChange;
  DataGridHelper3({
    super.key,
    required this.dataSource,
    required this.columnList,
    required this.uniqueKey,
    this.controller,
    this.fontSize = 13,
    this.headerFontSize = 13,
    this.columnSpacing = 0,
    this.rowSpacing = 0,
    this.columnFixCount = 0,
    this.defaultPageSize = 1,
    this.rowHeight = 40,
    this.headerHeight = 40,
    this.filterList,
    this.withPaginate = false,
    this.showBorderVertical = false,
    this.withSearch = false,
    this.hideHeader = false,
    required this.width,
    this.noDataWidget,
    this.onCellValueChange,
    this.showFooter = false,
    this.withBorder = false,
    this.showAlternateColor = false,
    this.footerColor,
    this.backgroundColor,
    this.headerColor = const Color.fromARGB(255, 218, 235, 255),
    this.borderColor = const Color.fromARGB(255, 218, 235, 255),
    this.alternateRowColor = const Color.fromARGB(255, 246, 246, 246),
    this.headerFontColor = const Color.fromARGB(255, 15, 16, 16),
    this.showSelection = false,
  });

  @override
  State<DataGridHelper3> createState() => _DataGridHelper2State();
}

class _DataGridHelper2State extends State<DataGridHelper3> {
  late DataGridHelperStore3 dataGridHelperStore =
      widget.controller ??
      Get.put(DataGridHelperStore3(), tag: widget.uniqueKey);
  final MainStore mainStore = Get.find();

  List<ScrollController> verticalScrollControllers = [];
  String uniqueKeyGiven = "";
  ScrollController horizontalScrollCon = ScrollController();
  ScrollController verticalScrollCon = ScrollController();
  ScrollController verticalFixScrollCon = ScrollController();
  // List selectedRow = [];
  double getPinnedColumnWidth() {
    return widget.columnList
        .sublist(0, widget.columnFixCount)
        .fold(0.0, (sum, col) => sum + (col.width ?? getAutoHeadWidth()));
  }

  Alignment getAlignment(CellTextAlignment3 alignment) {
    switch (alignment) {
      case CellTextAlignment3.left:
        return Alignment.centerLeft;
      case CellTextAlignment3.right:
        return Alignment.centerRight;
      case CellTextAlignment3.center:
        return Alignment.center;
    }
  }

  TextAlign getTextAlign(CellTextAlignment3 alignment) {
    switch (alignment) {
      case CellTextAlignment3.left:
        return TextAlign.left;
      case CellTextAlignment3.right:
        return TextAlign.right;
      case CellTextAlignment3.center:
        return TextAlign.center;
    }
  }

  void filterDataSource() {
    List data = [...widget.dataSource];

    for (var fData in dataGridHelperStore.filteredData) {
      data.retainWhere(
        (d) => fData['value'].contains(d[fData['key']].toString()),
      );
    }
    dataGridHelperStore.filteredDataSource.value = makeListSerialize(data);
    setFilteredDataSourceWithPaginate(
      filterData: false,
      totalCount: dataGridHelperStore.filteredDataSource.value.length,
    );
    if (dataGridHelperStore.filterOpenIndex.isNotEmpty) {
      setUniqueFilterList(
        parseInt(
          data: dataGridHelperStore.filterOpenIndex.value[0],
          defaultInt: 0,
        ),
      );
    }
    dataGridHelperStore.makeGlobalFilter(widget.columnList, widget.dataSource);
    dataGridHelperStore.update();
  }

  void sortDataBase() {
    if (dataGridHelperStore.sortingColumn.value == null) {
      return;
    }
    int sortColumnIndex = dataGridHelperStore.sortingColumn.value!.index;
    bool isAsc =
        dataGridHelperStore.sortingColumn.value!.type ==
        DataGridSortingEnum.ascending;
    List<Map<String, dynamic>> data = widget.dataSource;
    if (sortColumnIndex != -1) {
      if (isAsc) {
        data.sort((a, b) {
          return a[widget.columnList[sortColumnIndex].dataField]
              .toString()
              .compareTo(
                b[widget.columnList[sortColumnIndex].dataField].toString(),
              );
        });
      } else {
        data.sort((a, b) {
          return b[widget.columnList[sortColumnIndex].dataField]
              .toString()
              .compareTo(
                a[widget.columnList[sortColumnIndex].dataField].toString(),
              );
        });
      }
      dataGridHelperStore.filteredDataSource.value = data;
      dataGridHelperStore.update();
      filterDataSource();
    }
  }

  double getAutoWidth() {
    double x = 0;
    int count = 0;
    for (var m in widget.columnList) {
      if (m.width != null) {
        x += m.width!;
        count++;
      }
    }
    return ((widget.width - x) / (widget.columnList.length - count) - 8);
  }

  double getAutoHeadWidth() {
    double x = 0;
    int count = 0;
    for (var m in widget.columnList) {
      if (m.width != null) {
        x += m.width!;
        count++;
      }
    }
    // logG((widget.width - x) / (widget.columnList.length - count) - (8+ widget.columnSpacing));
    double width =
        ((widget.width - x) / (widget.columnList.length - count) -
        (widget.columnSpacing));
    return width < 50 ? 50 : width;
  }

  String getTextValue(dynamic data, CellDataType3 cellType) {
    return cellType == CellDataType3.int
        ? data == null
              ? '0'
              : data.toString()
        : data == null
        ? '0'
        : data.toString();
  }

  String getSummeryValue(
    int index,
    SummeryType3? summeryType,
    List dataSource,
  ) {
    if (summeryType == null) {
      return "No summery type found";
    }
    String key = widget.columnList[index].dataField;
    // String dataType=widget.columnList[index].dataType==CellDataType3.int ? "int" : "string";
    List data = dataSource.map((m) => m[key]).toList();
    // print(data);m[key]
    if (summeryType == SummeryType3.count) {
      return data
          .where(
            (m) => parseString(data: m, defaultValue: "").trim().isNotEmpty,
          )
          .length
          .toString();
    } else if (summeryType == SummeryType3.sum) {
      return double.parse(
        data
            .fold(
              0.0,
              (a, b) =>
                  double.parse(a.toString()) +
                  double.parse(
                    double.tryParse(b.toString()) == null
                        ? '0.0'
                        : b.toString(),
                  ),
            )
            .toString(),
      ).toStringAsFixed(2);
    } else {
      return '';
    }
  }

  List<DataColumn> columns(
    List<DataGridColumnModel3> list,
    BuildContext context,
  ) {
    return list
        .map(
          (m) => DataColumn(
            headingRowAlignment: m.textAlign == CellTextAlignment3.left
                ? MainAxisAlignment.start
                : m.textAlign == CellTextAlignment3.right
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            label: Text(
              m.title ?? m.dataField.toString().toUpperCase(),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
  }

  Widget getHeaderForEmptyDataSource() {
    return SizedBox(
      height: widget.headerHeight,
      width: widget.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            ...widget.columnList
                .asMap()
                .map(
                  (index, value) => MapEntry(
                    index,
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: widget.columnSpacing / 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: value.customHeaderCell != null
                              ? BorderSide.none
                              : BorderSide(width: 1, color: widget.borderColor),
                          right: index <= (widget.columnFixCount - 1)
                              ? BorderSide(color: Colors.blueGrey.shade200)
                              : BorderSide.none,
                        ),
                        color: value.customHeaderCell != null
                            ? null
                            : widget.headerColor,
                      ),
                      child: value.customHeaderCell != null
                          ? Container(
                              width:
                                  widget.columnList[index].width ??
                                  getAutoHeadWidth(),
                              height: widget.headerHeight,
                              child: value.customHeaderCell!(
                                CustomCellData3(
                                  rowIndex: 0,
                                  cellIndex: index,
                                  rowValue: {},
                                  cellValue: widget.columnList[index].dataField,
                                  data: widget.dataSource,
                                ),
                              ),
                            )
                          : Row(
                              children: [
                                TextHelper(
                                  text: parseString(
                                    data:
                                        widget.columnList[index].title ??
                                        widget.columnList[index].dataField
                                            .toString()
                                            .toUpperCase(),
                                    defaultValue: "",
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 4,
                                  ),
                                  textalign:
                                      widget.columnList[index].textAlign ==
                                          CellTextAlignment3.left
                                      ? TextAlign.left
                                      : widget.columnList[index].textAlign ==
                                            CellTextAlignment3.right
                                      ? TextAlign.right
                                      : TextAlign.center,
                                  fontweight: FontWeight.w600,
                                  fontsize: widget.fontSize,
                                  isWrap: true,
                                  color: widget.headerFontColor,
                                  width: widget.columnList[index].width != null
                                      ? dataGridHelperStore.filterShowIndex
                                                .contains(index)
                                            ? widget.columnList[index].width! -
                                                  25
                                            : widget.columnList[index].width
                                      : dataGridHelperStore.filterShowIndex
                                            .contains(index)
                                      ? getAutoHeadWidth() - 25
                                      : getAutoHeadWidth(),
                                ),
                                if (dataGridHelperStore.filterShowIndex
                                    .contains(index))
                                  MoonPopover(
                                    show: dataGridHelperStore.filterOpenIndex
                                        .contains(index.toString()),
                                    popoverPosition: index.toString() == '0'
                                        ? MoonPopoverPosition.bottomRight
                                        : MoonPopoverPosition.bottomLeft,
                                    onTapOutside: () {
                                      dataGridHelperStore.filterOpenIndex
                                          .remove(index.toString());
                                      dataGridHelperStore
                                              .filterTextController
                                              .text =
                                          '';
                                      dataGridHelperStore
                                              .filteredSearchText
                                              .value =
                                          '';
                                    },
                                    backgroundColor:
                                        mainStore.isDarkEnable.value
                                        ? Colors.blueGrey.shade900
                                        : Colors.white,
                                    content: Material(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 180,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                MoonCheckbox(
                                                  value:
                                                      dataGridHelperStore
                                                              .filteredData
                                                              .indexWhere(
                                                                (t) =>
                                                                    t['key'] ==
                                                                    widget
                                                                        .columnList[index]
                                                                        .dataField,
                                                              ) ==
                                                          -1
                                                      ? false
                                                      : dataGridHelperStore
                                                                .filteredData
                                                                .firstWhere(
                                                                  (t) =>
                                                                      t['key'] ==
                                                                      widget
                                                                          .columnList[index]
                                                                          .dataField,
                                                                  orElse: () =>
                                                                      {
                                                                        'value':
                                                                            [],
                                                                      },
                                                                )['value']
                                                                .length ==
                                                            widget
                                                                .dataSource
                                                                .length
                                                      ? true
                                                      : null,
                                                  onChanged: (v) {
                                                    if (v != null &&
                                                        v == true) {
                                                      int filterIndex =
                                                          dataGridHelperStore
                                                              .filteredData
                                                              .indexWhere(
                                                                (t) =>
                                                                    t['key'] ==
                                                                    widget
                                                                        .columnList[index]
                                                                        .dataField,
                                                              );
                                                      if (filterIndex == 0) {
                                                        dataGridHelperStore
                                                            .filteredData
                                                            .add({
                                                              'key': widget
                                                                  .columnList[index]
                                                                  .dataField,
                                                              'value': widget
                                                                  .dataSource
                                                                  .map(
                                                                    (
                                                                      m,
                                                                    ) => m[widget.columnList[index].dataField]
                                                                        .toString(),
                                                                  )
                                                                  .toList(),
                                                            });
                                                      } else {
                                                        if (filterIndex != -1) {
                                                          dataGridHelperStore
                                                              .filteredData
                                                              .value
                                                              .removeAt(
                                                                filterIndex,
                                                              );
                                                        }
                                                        dataGridHelperStore
                                                            .filteredData
                                                            .add({
                                                              'key': widget
                                                                  .columnList[index]
                                                                  .dataField,
                                                              'value': widget
                                                                  .dataSource
                                                                  .map(
                                                                    (
                                                                      m,
                                                                    ) => m[widget.columnList[index].dataField]
                                                                        .toString(),
                                                                  )
                                                                  .toList(),
                                                            });
                                                      }
                                                    } else {
                                                      int filterIndex =
                                                          dataGridHelperStore
                                                              .filteredData
                                                              .indexWhere(
                                                                (t) =>
                                                                    t['key'] ==
                                                                    widget
                                                                        .columnList[index]
                                                                        .dataField,
                                                              );
                                                      dataGridHelperStore
                                                          .filteredData
                                                          .value
                                                          .removeAt(
                                                            filterIndex,
                                                          );
                                                    }
                                                    filterDataSource();
                                                  },
                                                  activeColor: Colors.blue,
                                                  tristate: true,
                                                ),
                                                Expanded(
                                                  child: TextBox(
                                                    placeholder: "Search..",
                                                    height: 35,
                                                    borderRadius: 5,
                                                    onValueChange: (v) {
                                                      dataGridHelperStore
                                                              .filteredSearchText
                                                              .value =
                                                          v;
                                                    },
                                                    controller:
                                                        dataGridHelperStore
                                                            .filterTextController,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 180,
                                            child: Divider(height: 2),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            height: 150,
                                            child: ListView.builder(
                                              itemCount: dataGridHelperStore
                                                  .uniqueFilterList
                                                  .value
                                                  .length,
                                              itemBuilder:
                                                  (
                                                    BuildContext context,
                                                    int childIndex,
                                                  ) => GestureDetector(
                                                    onTap: () {
                                                      bool isChecked =
                                                          isFilterItemSelected(
                                                            widget
                                                                .columnList[index]
                                                                .dataField,
                                                            dataGridHelperStore
                                                                .uniqueFilterList
                                                                .value[childIndex],
                                                          );
                                                      if (isChecked) {
                                                        removeFilterItemSelect(
                                                          widget
                                                              .columnList[index]
                                                              .dataField,
                                                          dataGridHelperStore
                                                              .uniqueFilterList
                                                              .value[childIndex],
                                                        );
                                                      } else {
                                                        setFilterItemSelect(
                                                          widget
                                                              .columnList[index]
                                                              .dataField,
                                                          dataGridHelperStore
                                                              .uniqueFilterList
                                                              .value[childIndex],
                                                        );
                                                      }
                                                      filterDataSource();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        StreamBuilder<Object>(
                                                          stream:
                                                              dataGridHelperStore
                                                                  .filteredData
                                                                  .stream,
                                                          builder: (context, snapshot) {
                                                            return MoonCheckbox(
                                                              activeColor:
                                                                  Colors.blue,
                                                              onChanged: (v) {
                                                                bool
                                                                isChecked = isFilterItemSelected(
                                                                  widget
                                                                      .columnList[index]
                                                                      .dataField,
                                                                  dataGridHelperStore
                                                                      .uniqueFilterList
                                                                      .value[childIndex],
                                                                );
                                                                if (isChecked) {
                                                                  removeFilterItemSelect(
                                                                    widget
                                                                        .columnList[index]
                                                                        .dataField,
                                                                    dataGridHelperStore
                                                                        .uniqueFilterList
                                                                        .value[childIndex],
                                                                  );
                                                                } else {
                                                                  setFilterItemSelect(
                                                                    widget
                                                                        .columnList[index]
                                                                        .dataField,
                                                                    dataGridHelperStore
                                                                        .uniqueFilterList
                                                                        .value[childIndex],
                                                                  );
                                                                }
                                                                filterDataSource();
                                                              },
                                                              value: isFilterItemSelected(
                                                                widget
                                                                    .columnList[index]
                                                                    .dataField,
                                                                dataGridHelperStore
                                                                    .uniqueFilterList
                                                                    .value[childIndex],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        Expanded(
                                                          child: TextHelper(
                                                            text: dataGridHelperStore
                                                                .uniqueFilterList
                                                                .value[childIndex]
                                                                .toString(),
                                                            fontsize: 12,
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
                                    child: GestureDetector(
                                      onTap: () {
                                        if (dataGridHelperStore.filterOpenIndex
                                            .contains(index.toString())) {
                                          dataGridHelperStore.filterOpenIndex
                                              .remove(index.toString());
                                        } else {
                                          dataGridHelperStore.filterOpenIndex
                                              .add(index.toString());
                                        }
                                      },
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        color: Colors.transparent,
                                        child: Icon(
                                          FontAwesomeIcons.filter,
                                          size: 12,
                                          color:
                                              dataGridHelperStore.filteredData
                                                      .indexWhere(
                                                        (t) =>
                                                            t['key'] ==
                                                            widget
                                                                .columnList[index]
                                                                .dataField,
                                                      ) ==
                                                  -1
                                              ? Colors.black87
                                              : Colors.blue.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                )
                .values,
          ],
        ),
      ),
    );
  }

  Widget cellBuilding2(CellCoordinate v, List dataSource) {
    int x = v.xIndex;
    int x2 = v.xIndex;
    int y = v.yIndex;
    int y2 = v.yIndex;
    // Map<String,dynamic> m = widget.dataSource[y];
    Map<String, dynamic> m = {};
    if (y != 0) {
      y = v.yIndex - 1;
      m = dataSource[v.yIndex - 1];
    }
    return Container(
      // height: widget.headerHeight,
      margin: EdgeInsets.only(
        left: parseDouble(data: widget.columnSpacing, defaultValue: 0.0) / 2,
        right: parseDouble(data: widget.columnSpacing, defaultValue: 0.0) / 2,
        bottom: widget.rowSpacing,
      ),
      decoration: BoxDecoration(
        color: y.isOdd ? Colors.grey.shade100 : Colors.white,
      ),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        onTap: () {
          if (widget.showSelection == false &&
              (widget.columnList[x].editable == true ||
                  (widget.columnList[x].customEditable != null &&
                      widget.columnList[x].customEditable!(
                        CustomCellData3(
                          rowIndex: y2,
                          cellIndex: x,
                          data: widget.dataSource,
                          rowValue: m,
                          cellValue: widget.columnList[x].dataField,
                        ),
                      )))) {
            dataGridHelperStore.editCellTextController.text = getTextValue(
              m[widget.columnList[x].dataField],
              widget.columnList[x].dataType,
            );
            dataGridHelperStore.editableCell.value = [
              {'row': y, 'cell': x},
            ];
            dataGridHelperStore.update();
          }
        },
        child: y2 == 0
            ? widget.hideHeader
                  ? const SizedBox.shrink()
                  : widget.columnList[x].customHeaderCell != null
                  ? widget.columnList[x].customHeaderCell!(
                      CustomCellData3(
                        rowIndex: y2,
                        cellIndex: x,
                        data: widget.dataSource,
                        rowValue: m,
                        cellValue: widget.columnList[x].dataField,
                      ),
                    )
                  : Obx(
                      () => GestureDetector(
                        onTap: () {
                          if (!widget.columnList[x].sortable) {
                            return;
                          }
                          if (dataGridHelperStore.sortingColumn.value == null ||
                              dataGridHelperStore.sortingColumn.value!.index !=
                                  x2) {
                            dataGridHelperStore.sortingColumn.value =
                                DataGridSortingType(
                                  index: x2,
                                  type: DataGridSortingEnum.ascending,
                                );
                            dataGridHelperStore.update();
                            return;
                          }
                          if (dataGridHelperStore.sortingColumn.value!.type ==
                              DataGridSortingEnum.ascending) {
                            dataGridHelperStore.sortingColumn.value =
                                DataGridSortingType(
                                  index: x2,
                                  type: DataGridSortingEnum.descending,
                                );
                          } else {
                            dataGridHelperStore.sortingColumn.value =
                                DataGridSortingType(
                                  index: x2,
                                  type: DataGridSortingEnum.ascending,
                                );
                          }
                          dataGridHelperStore.update();
                          sortDataBase();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: widget.withBorder
                                  ? BorderSide(
                                      width: 1,
                                      color: widget.borderColor,
                                    )
                                  : BorderSide.none,
                              right: x2 <= (widget.columnFixCount - 1)
                                  ? BorderSide(color: Colors.blueGrey.shade200)
                                  : widget.showBorderVertical
                                  ? BorderSide(
                                      width: 1,
                                      color: widget.borderColor,
                                    )
                                  : BorderSide.none,
                            ),
                            color: widget.headerColor,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextHelper(
                                  text: parseString(
                                    data:
                                        widget.columnList[x2].title ??
                                        widget.columnList[x2].dataField
                                            .toString()
                                            .toUpperCase(),
                                    defaultValue: "",
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 8,
                                  ),
                                  textalign:
                                      widget.columnList[x2].textAlign ==
                                          CellTextAlignment3.left
                                      ? TextAlign.left
                                      : widget.columnList[x2].textAlign ==
                                            CellTextAlignment3.right
                                      ? TextAlign.right
                                      : TextAlign.center,
                                  fontweight: FontWeight.w600,
                                  fontsize: widget.headerFontSize != 13
                                      ? widget.headerFontSize
                                      : widget.fontSize,
                                  isWrap: true,
                                  color:
                                      widget.columnList[x2].headerFontColor ??
                                      widget.headerFontColor,
                                  width:
                                      widget.columnList[x2].width ??
                                      (widget.columnList[x2].minWidth != null
                                          ? (widget.columnList[x2].minWidth! <
                                                    getAutoHeadWidth()
                                                ? widget.columnList[x2].minWidth
                                                : getAutoHeadWidth())
                                          : getAutoHeadWidth()),
                                ),
                              ),
                              if (dataGridHelperStore
                                      .sortingColumn
                                      .value
                                      ?.index ==
                                  x2)
                                Transform.rotate(
                                  angle:
                                      dataGridHelperStore
                                              .sortingColumn
                                              .value
                                              ?.type ==
                                          DataGridSortingEnum.descending
                                      ? 0
                                      : 90 * (math.pi / 90),
                                  child: Icon(
                                    Icons.sort_rounded,
                                    size: 13,
                                    color: widget.headerFontColor,
                                  ),
                                ),
                              if (dataGridHelperStore.filterShowIndex.contains(
                                x2,
                              ))
                                MoonPopover(
                                  show: dataGridHelperStore.filterOpenIndex
                                      .contains(x.toString()),
                                  popoverPosition: x2.toString() == '0'
                                      ? MoonPopoverPosition.bottomRight
                                      : MoonPopoverPosition.bottomLeft,
                                  onTapOutside: () {
                                    dataGridHelperStore.filterOpenIndex.remove(
                                      x.toString(),
                                    );
                                    dataGridHelperStore
                                            .filterTextController
                                            .text =
                                        '';
                                    dataGridHelperStore
                                            .filteredSearchText
                                            .value =
                                        '';
                                  },
                                  backgroundColor: mainStore.isDarkEnable.value
                                      ? Colors.blueGrey.shade900
                                      : Colors.white,
                                  content: Material(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width:
                                              widget.columnList[x2].dataType ==
                                                  CellDataType3.date
                                              ? 300
                                              : 180,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              MoonCheckbox(
                                                value:
                                                    dataGridHelperStore
                                                            .filteredData
                                                            .indexWhere(
                                                              (t) =>
                                                                  t['key'] ==
                                                                  widget
                                                                      .columnList[x2]
                                                                      .dataField,
                                                            ) ==
                                                        -1
                                                    ? false
                                                    : dataGridHelperStore
                                                              .filteredData
                                                              .firstWhere(
                                                                (t) =>
                                                                    t['key'] ==
                                                                    widget
                                                                        .columnList[x2]
                                                                        .dataField,
                                                                orElse: () => {
                                                                  'value': [],
                                                                },
                                                              )['value']
                                                              .length ==
                                                          widget
                                                              .dataSource
                                                              .length
                                                    ? true
                                                    : null,
                                                onChanged: (v) {
                                                  if (v != null && v == true) {
                                                    int filterIndex =
                                                        dataGridHelperStore
                                                            .filteredData
                                                            .indexWhere(
                                                              (t) =>
                                                                  t['key'] ==
                                                                  widget
                                                                      .columnList[x2]
                                                                      .dataField,
                                                            );
                                                    if (filterIndex == 0) {
                                                      dataGridHelperStore.filteredData.add({
                                                        'key': widget
                                                            .columnList[x2]
                                                            .dataField,
                                                        'value': widget
                                                            .dataSource
                                                            .where(
                                                              (
                                                                m,
                                                              ) => m[widget.columnList[x2].dataField]
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                    dataGridHelperStore
                                                                        .filteredSearchText
                                                                        .value
                                                                        .toLowerCase(),
                                                                  ),
                                                            )
                                                            .map(
                                                              (m) =>
                                                                  m[widget
                                                                          .columnList[x2]
                                                                          .dataField]
                                                                      .toString(),
                                                            )
                                                            .toList(),
                                                      });
                                                    } else {
                                                      if (filterIndex != -1) {
                                                        dataGridHelperStore
                                                            .filteredData
                                                            .value
                                                            .removeAt(
                                                              filterIndex,
                                                            );
                                                      }
                                                      dataGridHelperStore.filteredData.add({
                                                        'key': widget
                                                            .columnList[x]
                                                            .dataField,
                                                        'value': widget
                                                            .dataSource
                                                            .where(
                                                              (
                                                                m,
                                                              ) => m[widget.columnList[x2].dataField]
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                    dataGridHelperStore
                                                                        .filteredSearchText
                                                                        .value
                                                                        .toLowerCase(),
                                                                  ),
                                                            )
                                                            .map(
                                                              (m) =>
                                                                  m[widget
                                                                          .columnList[x2]
                                                                          .dataField]
                                                                      .toString(),
                                                            )
                                                            .toList(),
                                                      });
                                                    }
                                                  } else {
                                                    int filterIndex =
                                                        dataGridHelperStore
                                                            .filteredData
                                                            .indexWhere(
                                                              (t) =>
                                                                  t['key'] ==
                                                                  widget
                                                                      .columnList[x2]
                                                                      .dataField,
                                                            );
                                                    dataGridHelperStore
                                                        .filteredData
                                                        .value
                                                        .removeAt(filterIndex);
                                                  }
                                                  filterDataSource();
                                                },
                                                activeColor: Colors.blue,
                                                tristate: true,
                                              ),
                                              Expanded(
                                                child: TextBox(
                                                  placeholder: "Search",
                                                  height: 35,
                                                  borderRadius: 5,
                                                  onValueChange: (v) {
                                                    dataGridHelperStore
                                                            .filteredSearchText
                                                            .value =
                                                        v;
                                                  },
                                                  controller:
                                                      dataGridHelperStore
                                                          .filterTextController,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (widget.columnList[x2].dataType !=
                                            CellDataType3.date)
                                          SizedBox(
                                            width: 180,
                                            child: Divider(),
                                          ),
                                        if (widget.columnList[x2].dataType ==
                                            CellDataType3.date)
                                          SizedBox(
                                            width: 300,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ButtonHelperG(
                                                  onTap: () {
                                                    int filterIndex =
                                                        dataGridHelperStore
                                                            .filteredData
                                                            .indexWhere(
                                                              (t) =>
                                                                  t['key'] ==
                                                                  widget
                                                                      .columnList[x2]
                                                                      .dataField,
                                                            );
                                                    dataGridHelperStore
                                                        .filteredData
                                                        .value
                                                        .removeAt(filterIndex);
                                                    filterDataSource();
                                                  },
                                                  width: 80,
                                                  icon: Icon(
                                                    Icons.refresh,
                                                    size: 18,
                                                    color: Colors.grey,
                                                  ),
                                                  label: TextHelper(
                                                    text: "Reset",
                                                  ),
                                                  background:
                                                      Colors.transparent,
                                                ),
                                              ],
                                            ),
                                          ),
                                        widget.columnList[x2].dataType ==
                                                CellDataType3.date
                                            ? DateRangePicker(
                                                selectedDateRange:
                                                    getSelectedDateRange(
                                                      dataGridHelperStore:
                                                          dataGridHelperStore,
                                                      dateFormat:
                                                          "yyyy-MM-dd hh:mm:ss",
                                                      column:
                                                          widget.columnList[x2],
                                                      dataSource:
                                                          widget.dataSource,
                                                    ),
                                                withPopupMode: false,
                                                onValueChange: (v) {
                                                  filterDateWidget(
                                                    dateRange: v,
                                                    dataGridHelperStore:
                                                        dataGridHelperStore,
                                                    dateFormat:
                                                        "yyyy-MM-dd hh:mm:ss",
                                                    column:
                                                        widget.columnList[x2],
                                                    dataSource:
                                                        widget.dataSource,
                                                  );
                                                  filterDataSource();
                                                },
                                                dateFormat:
                                                    "yyyy-MM-dd hh:mm:ss",
                                                withSingleSelect: false,
                                              )
                                            : SizedBox(
                                                width: 180,
                                                height: 150,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 5,
                                                  ),
                                                  addAutomaticKeepAlives: false,
                                                  itemCount:
                                                      getUniqueFilterList(
                                                        x2,
                                                      ).length,
                                                  shrinkWrap: true,
                                                  itemExtent: 40,
                                                  itemBuilder: (context, childIndex) => GestureDetector(
                                                    onTap: () {
                                                      bool isChecked =
                                                          isFilterItemSelected(
                                                            widget
                                                                .columnList[x2]
                                                                .dataField,
                                                            getUniqueFilterList(
                                                              x2,
                                                            )[childIndex],
                                                          );
                                                      if (isChecked) {
                                                        removeFilterItemSelect(
                                                          widget
                                                              .columnList[x2]
                                                              .dataField,
                                                          getUniqueFilterList(
                                                            x2,
                                                          )[childIndex],
                                                        );
                                                      } else {
                                                        setFilterItemSelect(
                                                          widget
                                                              .columnList[x2]
                                                              .dataField,
                                                          getUniqueFilterList(
                                                            x2,
                                                          )[childIndex],
                                                        );
                                                      }
                                                      filterDataSource();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        MoonCheckbox(
                                                          activeColor:
                                                              Colors.blue,
                                                          onChanged: (v) {
                                                            bool
                                                            isChecked = isFilterItemSelected(
                                                              widget
                                                                  .columnList[x2]
                                                                  .dataField,
                                                              getUniqueFilterList(
                                                                x2,
                                                              )[childIndex],
                                                            );
                                                            if (isChecked) {
                                                              removeFilterItemSelect(
                                                                widget
                                                                    .columnList[x2]
                                                                    .dataField,
                                                                getUniqueFilterList(
                                                                  x2,
                                                                )[childIndex],
                                                              );
                                                            } else {
                                                              setFilterItemSelect(
                                                                widget
                                                                    .columnList[x2]
                                                                    .dataField,
                                                                getUniqueFilterList(
                                                                  x2,
                                                                )[childIndex],
                                                              );
                                                            }
                                                            filterDataSource();
                                                          },
                                                          value: isFilterItemSelected(
                                                            widget
                                                                .columnList[x2]
                                                                .dataField,
                                                            getUniqueFilterList(
                                                              x2,
                                                            )[childIndex],
                                                          ),
                                                        ),
                                                        // StreamBuilder<Object>(
                                                        //   stream: dataGridHelperStore.filteredData.stream,
                                                        //   builder: (context, snapshot) {
                                                        //     return MoonCheckbox(
                                                        //       activeColor: Colors.blue,
                                                        //       onChanged: (v) {
                                                        //         bool isChecked = isFilterItemSelected(
                                                        //           widget.columnList[x2].dataField,
                                                        //           getUniqueFilterList(x2)[childIndex],
                                                        //         );
                                                        //         if (isChecked) {
                                                        //           removeFilterItemSelect(widget.columnList[x2].dataField, getUniqueFilterList(x2)[childIndex]);
                                                        //         } else {
                                                        //           setFilterItemSelect(widget.columnList[x2].dataField, getUniqueFilterList(x2)[childIndex]);
                                                        //         }
                                                        //         filterDataSource();
                                                        //       },
                                                        //       value: isFilterItemSelected(widget.columnList[x2].dataField, getUniqueFilterList(x2)[childIndex]),
                                                        //     );
                                                        //   },
                                                        // ),
                                                        Expanded(
                                                          child: TextHelper(
                                                            text:
                                                                widget
                                                                        .columnList[x2]
                                                                        .customFilterCellText !=
                                                                    null
                                                                ? widget
                                                                      .columnList[x2]
                                                                      .customFilterCellText!(
                                                                    getUniqueFilterList(
                                                                          x2,
                                                                        )[childIndex]
                                                                        .toString(),
                                                                  )
                                                                : getUniqueFilterList(
                                                                        x2,
                                                                      )[childIndex]
                                                                      .toString(),
                                                            fontsize: 12,
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
                                  child: GestureDetector(
                                    onTap: () {
                                      if (dataGridHelperStore.filterOpenIndex
                                          .contains(x2.toString())) {
                                        dataGridHelperStore.filterOpenIndex
                                            .remove(x2.toString());
                                      } else {
                                        dataGridHelperStore.filterOpenIndex.add(
                                          x2.toString(),
                                        );
                                      }
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      color: Colors.transparent,
                                      child: Icon(
                                        FontAwesomeIcons.filter,
                                        size: 12,
                                        color:
                                            dataGridHelperStore.filteredData
                                                    .indexWhere(
                                                      (t) =>
                                                          t['key'] ==
                                                          widget
                                                              .columnList[x2]
                                                              .dataField,
                                                    ) ==
                                                -1
                                            ? mainStore.isDarkEnable.value
                                                  ? Colors.grey.shade700
                                                  : widget.headerFontColor
                                            : Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
            : GestureDetector(
                onLongPress: () {
                  if (widget.columnList[x].onLongPress != null) {
                    widget.columnList[x].onLongPress!(
                      CustomCellData3(
                        rowIndex: y,
                        cellIndex: x,
                        data: widget.dataSource,
                        rowValue: m,
                        cellValue: m[widget.columnList[x].dataField],
                      ),
                    );
                  }
                },
                child: Obx(
                  () => TooltipVisibility(
                    visible: widget.columnList[x].withTooltip,
                    child: Tooltip(
                      verticalOffset: 7,
                      message: parseString(
                        data: "${m[widget.columnList[x].dataField]}",
                        defaultValue: "",
                      ),
                      waitDuration: const Duration(seconds: 1),
                      exitDuration: const Duration(milliseconds: 0),
                      showDuration: const Duration(seconds: 2),
                      enableTapToDismiss: true,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey.shade600,
                        boxShadow: const [BoxShadow(color: Colors.grey)],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: widget.withBorder
                                ? BorderSide(
                                    width: 1,
                                    color: widget.borderColor,
                                  )
                                : BorderSide.none,
                            right: x2 <= (widget.columnFixCount - 1)
                                ? BorderSide(color: Colors.blueGrey.shade200)
                                : widget.withBorder
                                ? BorderSide(
                                    width: 1,
                                    color: widget.borderColor,
                                  )
                                : BorderSide.none,
                          ),
                          color: widget.columnList[x].rowColor != null
                              ? widget.columnList[x].rowColor!(
                                  CustomCellData3(
                                    rowIndex: y,
                                    cellIndex: x,
                                    data: widget.dataSource,
                                    rowValue: m,
                                    cellValue:
                                        m[widget.columnList[x].dataField],
                                  ),
                                )
                              : (x2 <= (widget.columnFixCount - 1)
                                    ? Colors.amber.shade50.withAlpha(10)
                                    : widget.showAlternateColor
                                    ? y.isOdd
                                          ? widget.alternateRowColor
                                          : Colors.white
                                    : Colors.white),
                        ),
                        child:
                            dataGridHelperStore.editableCell.any(
                                  (e) => e['row'] == y && e['cell'] == x,
                                ) &&
                                ((widget.columnList[x].editable != null &&
                                        widget.columnList[x].editable ==
                                            true) ||
                                    (widget.columnList[x].customEditable !=
                                            null &&
                                        widget.columnList[x].customEditable!(
                                          CustomCellData3(
                                            rowIndex: y2,
                                            cellIndex: x,
                                            data: widget.dataSource,
                                            rowValue: m,
                                            cellValue:
                                                widget.columnList[x].dataField,
                                          ),
                                        )))
                            ? Center(
                                child: TextBox(
                                  backgroundColor: Colors.white,
                                  height: 35,
                                  width:
                                      widget.columnList[x].editorWidth ??
                                      getAutoHeadWidth(),
                                  controller: dataGridHelperStore
                                      .editCellTextController,
                                  selectTextOnFocus: widget
                                      .columnList[x]
                                      .selectTextOnEditStart,
                                  autofocus: true,
                                  textAlign:
                                      widget.columnList[x].textAlign ==
                                          CellTextAlignment3.left
                                      ? TextAlign.left
                                      : widget.columnList[x].textAlign ==
                                            CellTextAlignment3.right
                                      ? TextAlign.right
                                      : TextAlign.center,
                                  keyboard: widget.columnList[x].keyboard,
                                  fontSize:
                                      widget.columnList[x].fontSize ??
                                      widget.fontSize - 1,
                                  onValueChange: (e) {},
                                  initialValue: getTextValue(
                                    m[widget.columnList[x].dataField],
                                    widget.columnList[x].dataType,
                                  ),
                                  onSubmitted: (value) {
                                    if (widget.onCellValueChange != null) {
                                      widget.onCellValueChange!(
                                        CellUpdateValue3(
                                          rowIndex: y,
                                          colIndex: x,
                                          colName:
                                              widget.columnList[x].dataField,
                                          value: dataGridHelperStore
                                              .editCellTextController
                                              .text,
                                          rowValue: dataGridHelperStore
                                              .filteredDataSource
                                              .value[y],
                                        ),
                                      );
                                    }
                                    dataGridHelperStore.editableCell.clear();
                                    dataGridHelperStore
                                            .editCellTextController
                                            .text =
                                        '';
                                  },
                                  onTapOutside: () {
                                    //dataGridHelperStore.editableCell.removeWhere(
                                    //     (e) => e['row'] == i && e['cell'] == cellIndex);
                                    if (widget.onCellValueChange != null) {
                                      widget.onCellValueChange!(
                                        CellUpdateValue3(
                                          rowIndex: y,
                                          colIndex: x,
                                          colName:
                                              widget.columnList[x].dataField,
                                          value: dataGridHelperStore
                                              .editCellTextController
                                              .text,
                                          rowValue: dataGridHelperStore
                                              .filteredDataSource
                                              .value[y],
                                        ),
                                      );
                                    }
                                    dataGridHelperStore.editableCell.clear();
                                    dataGridHelperStore
                                            .editCellTextController
                                            .text =
                                        '';
                                  },
                                ),
                              )
                            : Container(
                                width:
                                    widget.columnList[x].width ??
                                    (widget.columnList[x].minWidth != null
                                        ? (widget.columnList[x].minWidth! >
                                                  getAutoHeadWidth()
                                              ? widget.columnList[x].minWidth
                                              : getAutoHeadWidth())
                                        : getAutoHeadWidth()),
                                alignment:
                                    widget.columnList[x].textAlign ==
                                        CellTextAlignment3.left
                                    ? Alignment.centerLeft
                                    : widget.columnList[x].textAlign ==
                                          CellTextAlignment3.right
                                    ? Alignment.centerRight
                                    : Alignment.center,
                                padding:
                                    widget.columnList[x].textAlign ==
                                        CellTextAlignment3.right
                                    ? const EdgeInsets.only(right: 3)
                                    : widget.columnList[x].textAlign ==
                                          CellTextAlignment3.left
                                    ? const EdgeInsets.only(left: 3)
                                    : const EdgeInsets.symmetric(horizontal: 0),
                                child: widget.columnList[x].customCell != null
                                    ? widget.columnList[x].customCell!(
                                        CustomCellData3(
                                          rowIndex: y,
                                          cellIndex: x,
                                          data: widget.dataSource,
                                          rowValue: m,
                                          cellValue:
                                              m[widget.columnList[x].dataField],
                                        ),
                                      )
                                    : TextHelper(
                                        text: getTextValue(
                                          m[widget.columnList[x].dataField],
                                          widget.columnList[x].dataType,
                                        ),
                                        isWrap: true,
                                        textalign:
                                            widget.columnList[x].textAlign ==
                                                CellTextAlignment3.left
                                            ? TextAlign.left
                                            : widget.columnList[x].textAlign ==
                                                  CellTextAlignment3.right
                                            ? TextAlign.right
                                            : TextAlign.center,
                                        fontsize:
                                            widget.columnList[x].fontSize ??
                                            widget.fontSize,
                                        color: widget.columnList[x].fontColor,
                                        // softWrap: true,
                                        // textWidthBasis: TextWidthBasis.parent,
                                        // textAlign: TextAlign.left,
                                        // // textAlign: x.textAlign == CellTextAlignment.left
                                        // //     ? TextAlign.left
                                        // //     : x.textAlign == CellTextAlignment.right
                                        // //         ? TextAlign.right
                                        // //         : TextAlign.center,
                                        // style: TextStyle(fontSize: widget.fontSize),
                                      ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget singleCellMakeForBody(
    DataGridColumnModel3 columnData,
    int rowIndex,
    int cellIndex,
    Map<String, dynamic> rowValue,
    dynamic cellValue,
    bool isFixedCell,
  ) {
    return GestureDetector(
      onTap: () {
        if (widget.showSelection == false &&
            (columnData.editable == true ||
                (columnData.customEditable != null &&
                    columnData.customEditable!(
                      CustomCellData3(
                        rowIndex: rowIndex,
                        cellIndex: cellIndex,
                        data: widget.dataSource,
                        rowValue: rowValue,
                        cellValue: widget.columnList[cellIndex].dataField,
                      ),
                    )))) {
          dataGridHelperStore.editCellTextController.text = getTextValue(
            rowValue[widget.columnList[cellIndex].dataField],
            widget.columnList[cellIndex].dataType,
          );
          dataGridHelperStore.editableCell.value = [
            {'row': rowIndex, 'cell': cellIndex},
          ];
          dataGridHelperStore.update();
        }
      },
      onLongPress: () {
        if (columnData.onLongPress != null) {
          columnData.onLongPress!(
            CustomCellData3(
              rowIndex: rowIndex,
              cellIndex: cellIndex,
              data: widget.dataSource,
              rowValue: rowValue,
              cellValue: cellValue,
            ),
          );
        }
      },
      child: Obx(
        () => TooltipVisibility(
          visible: columnData.withTooltip,
          child: Tooltip(
            verticalOffset: 7,
            message: parseString(data: "${cellValue}", defaultValue: ""),
            waitDuration: const Duration(seconds: 1),
            exitDuration: const Duration(milliseconds: 0),
            showDuration: const Duration(seconds: 2),
            enableTapToDismiss: true,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey.shade600,
              boxShadow: const [BoxShadow(color: Colors.grey)],
            ),
            child: Container(
              height: widget.rowHeight,
              decoration: BoxDecoration(
                border: Border(
                  bottom: widget.withBorder
                      ? BorderSide(width: 1, color: widget.borderColor)
                      : BorderSide.none,
                  // right: isFixedCell ? BorderSide(width: 1, color: Colors.blueGrey.shade300) : BorderSide.none,
                ),
                color: columnData.rowColor != null
                    ? columnData.rowColor!(
                        CustomCellData3(
                          rowIndex: rowIndex,
                          cellIndex: cellIndex,
                          data: widget.dataSource,
                          rowValue: rowValue,
                          cellValue: cellValue,
                        ),
                      )
                    // : (x2 <= (widget.columnFixCount - 1)
                    //     ? Colors.amber.shade50.withAlpha(10)
                    : widget.showAlternateColor
                    ? rowIndex.isOdd
                          ? widget.alternateRowColor
                          : Colors.white
                    : Colors.white,
              ),
              child:
                  dataGridHelperStore.editableCell.any(
                        (e) => e['row'] == rowIndex && e['cell'] == cellIndex,
                      ) &&
                      ((columnData.editable != null &&
                              columnData.editable == true) ||
                          (columnData.customEditable != null &&
                              columnData.customEditable!(
                                CustomCellData3(
                                  rowIndex: rowIndex,
                                  cellIndex: cellIndex,
                                  data: widget.dataSource,
                                  rowValue: rowValue,
                                  cellValue: columnData.dataField,
                                ),
                              )))
                  ? Center(
                      child: TextBox(
                        backgroundColor: Colors.white,
                        height: 35,
                        width: columnData.editorWidth ?? getAutoHeadWidth(),
                        controller: dataGridHelperStore.editCellTextController,
                        selectTextOnFocus: columnData.selectTextOnEditStart,
                        autofocus: true,
                        textAlign:
                            columnData.textAlign == CellTextAlignment3.left
                            ? TextAlign.left
                            : columnData.textAlign == CellTextAlignment3.right
                            ? TextAlign.right
                            : TextAlign.center,
                        keyboard: columnData.keyboard,
                        fontSize: columnData.fontSize ?? widget.fontSize - 1,
                        onValueChange: (e) {},
                        initialValue: getTextValue(
                          cellValue,
                          columnData.dataType,
                        ),
                        onSubmitted: (value) {
                          if (widget.onCellValueChange != null) {
                            widget.onCellValueChange!(
                              CellUpdateValue3(
                                rowIndex: rowIndex,
                                colIndex: cellIndex,
                                colName: columnData.dataField,
                                value: dataGridHelperStore
                                    .editCellTextController
                                    .text,
                                rowValue: rowValue,
                              ),
                            );
                          }
                          dataGridHelperStore.editableCell.clear();
                          dataGridHelperStore.editCellTextController.text = '';
                        },
                        onTapOutside: () {
                          //dataGridHelperStore.editableCell.removeWhere(
                          //     (e) => e['row'] == i && e['cell'] == cellIndex);
                          if (widget.onCellValueChange != null) {
                            widget.onCellValueChange!(
                              CellUpdateValue3(
                                rowIndex: rowIndex,
                                colIndex: cellIndex,
                                colName: columnData.dataField,
                                value: dataGridHelperStore
                                    .editCellTextController
                                    .text,
                                rowValue: rowValue,
                              ),
                            );
                          }
                          dataGridHelperStore.editableCell.clear();
                          dataGridHelperStore.editCellTextController.text = '';
                        },
                      ),
                    )
                  : Container(
                      width:
                          columnData.width ??
                          (columnData.minWidth != null
                              ? (columnData.minWidth! > getAutoHeadWidth()
                                    ? columnData.minWidth
                                    : getAutoHeadWidth())
                              : getAutoHeadWidth()),
                      alignment: columnData.textAlign == CellTextAlignment3.left
                          ? Alignment.centerLeft
                          : columnData.textAlign == CellTextAlignment3.right
                          ? Alignment.centerRight
                          : Alignment.center,
                      padding: columnData.textAlign == CellTextAlignment3.right
                          ? const EdgeInsets.only(right: 3)
                          : columnData.textAlign == CellTextAlignment3.left
                          ? const EdgeInsets.only(left: 3)
                          : const EdgeInsets.symmetric(horizontal: 0),
                      child: columnData.customCell != null
                          ? columnData.customCell!(
                              CustomCellData3(
                                rowIndex: rowIndex,
                                cellIndex: cellIndex,
                                data: widget.dataSource,
                                rowValue: rowValue,
                                cellValue: cellValue,
                              ),
                            )
                          : TextHelper(
                              text: getTextValue(
                                cellValue,
                                columnData.dataType,
                              ),
                              isWrap: true,
                              textalign:
                                  columnData.textAlign ==
                                      CellTextAlignment3.left
                                  ? TextAlign.left
                                  : columnData.textAlign ==
                                        CellTextAlignment3.right
                                  ? TextAlign.right
                                  : TextAlign.center,
                              fontsize: columnData.fontSize ?? widget.fontSize,
                              color: columnData.fontColor,
                              // softWrap: true,
                              // textWidthBasis: TextWidthBasis.parent,
                              // textAlign: TextAlign.left,
                              // // textAlign: x.textAlign == CellTextAlignment.left
                              // //     ? TextAlign.left
                              // //     : x.textAlign == CellTextAlignment.right
                              // //         ? TextAlign.right
                              // //         : TextAlign.center,
                              // style: TextStyle(fontSize: widget.fontSize),
                            ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  // FIlter Item CRUD =====
  bool isFilterItemSelected(String key, dynamic value) {
    int index = dataGridHelperStore.filteredData.value.indexWhere(
      (t) => t['key'] == key,
    );
    if (index == -1) return false;
    Map<String, dynamic> data = dataGridHelperStore.filteredData.value[index];
    return data['value'].contains(value.toString());
  }

  void setFilterItemSelect(String key, dynamic value) {
    int index = dataGridHelperStore.filteredData.indexWhere(
      (t) => t['key'] == key,
    );
    if (index == -1) {
      dataGridHelperStore.filteredData.add({
        'key': key,
        'value': [value.toString()],
      });
    } else {
      dataGridHelperStore.filteredData[index]['value'].add(value.toString());
    }
    dataGridHelperStore.filteredData.refresh();
    dataGridHelperStore.update();
  }

  void removeFilterItemSelect(String key, dynamic value) {
    int index = dataGridHelperStore.filteredData.indexWhere(
      (t) => t['key'] == key,
    );
    if (index == -1) {
      return;
    } else {
      int length = dataGridHelperStore.filteredData[index]['value'].length;
      if (length > 1) {
        dataGridHelperStore.filteredData[index]['value'].remove(
          value.toString(),
        );
      } else {
        dataGridHelperStore.filteredData.removeAt(index);
      }
    }
    dataGridHelperStore.filteredData.refresh();
    dataGridHelperStore.update();
  }

  //===================================

  List getUniqueFilterList(int colIndex) {
    if (dataGridHelperStore.filteredData.isNotEmpty &&
        dataGridHelperStore.filteredData[0]["key"] !=
            widget.columnList[colIndex].dataField) {
      return Set.from(
            dataGridHelperStore.filteredDataSource.map(
              (d) => d[widget.columnList[colIndex].dataField],
            ),
          )
          .where(
            (t) => widget.columnList[colIndex].customFilterCellText != null
                ? widget
                      .columnList[colIndex]
                      .customFilterCellText!(
                        parseString(data: t, defaultValue: ''),
                      )
                      .toString()
                      .toLowerCase()
                      .contains(dataGridHelperStore.filteredSearchText.value)
                : parseString(data: t, defaultValue: '')
                      .toString()
                      .toLowerCase()
                      .contains(dataGridHelperStore.filteredSearchText.value),
          )
          .toList();
    }

    return Set.from(
          widget.dataSource.map(
            (d) => d[widget.columnList[colIndex].dataField],
          ),
        )
        .where(
          (t) => widget.columnList[colIndex].customFilterCellText != null
              ? widget
                    .columnList[colIndex]
                    .customFilterCellText!(
                      parseString(data: t, defaultValue: ''),
                    )
                    .toString()
                    .toLowerCase()
                    .contains(dataGridHelperStore.filteredSearchText.value)
              : parseString(data: t, defaultValue: '')
                    .toString()
                    .toLowerCase()
                    .contains(dataGridHelperStore.filteredSearchText.value),
        )
        .toList();

    // return Set.from(
    //   widget.dataSource.map((d) => d[widget.columnList[colIndex].dataField]),
    // ).toList().where((t) => parseString(data: t, defaultValue: '').toString().toLowerCase().contains(dataGridHelperStore.filteredSearchText.value)).toList();
  }

  void setUniqueFilterList(int colIndex) {
    if (dataGridHelperStore.filteredData.isNotEmpty &&
        dataGridHelperStore.filteredData[0]["key"] !=
            widget.columnList[colIndex].dataField) {
      dataGridHelperStore.uniqueFilterList.value =
          Set.from(
                dataGridHelperStore.filteredDataSource.map(
                  (d) => d[widget.columnList[colIndex].dataField],
                ),
              )
              .where(
                (t) => widget.columnList[colIndex].customFilterCellText != null
                    ? widget
                          .columnList[colIndex]
                          .customFilterCellText!(
                            parseString(data: t, defaultValue: ''),
                          )
                          .toString()
                          .toLowerCase()
                          .contains(
                            dataGridHelperStore.filteredSearchText.value,
                          )
                    : parseString(
                        data: t,
                        defaultValue: '',
                      ).toString().toLowerCase().contains(
                        dataGridHelperStore.filteredSearchText.value,
                      ),
              )
              .toList();
      return;
    }

    dataGridHelperStore.uniqueFilterList.value =
        Set.from(
              widget.dataSource.map(
                (d) => d[widget.columnList[colIndex].dataField],
              ),
            )
            .where(
              (t) => widget.columnList[colIndex].customFilterCellText != null
                  ? widget
                        .columnList[colIndex]
                        .customFilterCellText!(
                          parseString(data: t, defaultValue: ''),
                        )
                        .toString()
                        .toLowerCase()
                        .contains(dataGridHelperStore.filteredSearchText.value)
                  : parseString(data: t, defaultValue: '')
                        .toString()
                        .toLowerCase()
                        .contains(dataGridHelperStore.filteredSearchText.value),
            )
            .toList();

    // return Set.from(
    //   widget.dataSource.map((d) => d[widget.columnList[colIndex].dataField]),
    // ).toList().where((t) => parseString(data: t, defaultValue: '').toString().toLowerCase().contains(dataGridHelperStore.filteredSearchText.value)).toList();
  }

  void initOwnWork({isForFilter = false, allRefresh = false}) {
    List<int> indexList = [];
    widget.columnList.asMap().forEach((index, c) {
      if (c.showFilter) {
        indexList.add(index);
      }
    });
    dataGridHelperStore.filterShowIndex.value = indexList;
    dataGridHelperStore.uniqueFilterList.value = [];
    // if (widget.withPaginate && widget.dataSource.length > widget.defaultPageSize) {
    //   setFilteredDataSourceWithPaginate(filterData: true);
    // }
    if (allRefresh) {
      dataGridHelperStore.filteredData.value = [];
      dataGridHelperStore.filteredDataSource.value = widget.dataSource;
    }

    filterDataSource();
  }

  bool isSyncingScroll = false;
  @override
  void initState() {
    super.initState();
    verticalScrollControllers = List.generate(
      widget.columnList.length,
      (i) => ScrollController(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verticalScrollCon.addListener(() {
        if (!isSyncingScroll && verticalFixScrollCon.hasClients) {
          isSyncingScroll = true;
          verticalFixScrollCon.jumpTo(verticalScrollCon.offset);
          isSyncingScroll = false;
        }
      });

      verticalFixScrollCon.addListener(() {
        if (!isSyncingScroll && verticalScrollCon.hasClients) {
          isSyncingScroll = true;
          verticalScrollCon.jumpTo(verticalFixScrollCon.offset);
          isSyncingScroll = false;
        }
      });
      initOwnWork();
    });
  }

  void setFilteredDataSourceWithPaginate({
    bool filterData = false,
    int totalCount = 0,
  }) {
    if (!widget.withPaginate) {
      return;
    }
    int totalCount0 = totalCount == 0 ? widget.dataSource.length : totalCount;
    if (!filterData) {
      dataGridHelperStore.isPaginate.value =
          (dataGridHelperStore.filteredDataSource.value.length >
              widget.defaultPageSize) &&
          widget.withPaginate;

      // dataGridHelperStore.totalPage.value = parseInt(data: (dataGridHelperStore.filteredDataSource.value.length / widget.defaultPageSize), defaultInt: 1);
      dataGridHelperStore.totalPage.value =
          (dataGridHelperStore.filteredDataSource.value.length /
                  widget.defaultPageSize)
              .ceil();
    } else {
      dataGridHelperStore.isPaginate.value =
          (widget.dataSource.length > widget.defaultPageSize) &&
          widget.withPaginate;
      // dataGridHelperStore.totalPage.value = parseInt(data: (widget.dataSource.length / widget.defaultPageSize), defaultInt: 1);
      dataGridHelperStore.totalPage.value =
          (widget.dataSource.length / widget.defaultPageSize).ceil();
    }
    // if (filterData) {
    //   dataGridHelperStore.filteredDataSource.value = widget.dataSource.sublist(
    //     dataGridHelperStore.currentPageIndex.value,
    //     dataGridHelperStore.currentPageIndex.value + widget.defaultPageSize,
    //   );
    // }

    if (totalCount0 -
            dataGridHelperStore.currentPageIndex.value *
                widget.defaultPageSize <
        widget.defaultPageSize) {
      int startIndex = dataGridHelperStore.currentPageIndex.value;
      int endIndex =
          startIndex +
          totalCount0 -
          dataGridHelperStore.currentPageIndex.value * widget.defaultPageSize;
      dataGridHelperStore.filteredDataSource.value = dataGridHelperStore
          .filteredDataSource
          .sublist(startIndex, endIndex);
    } else {
      int startIndex = dataGridHelperStore.currentPageIndex.value;
      int endIndex = startIndex + widget.defaultPageSize;
      dataGridHelperStore.filteredDataSource.value = dataGridHelperStore
          .filteredDataSource
          .sublist(startIndex, endIndex);
    }
  }

  Widget getDataGridFilter(
    List<String> filterKeys,
    List<Map<String, dynamic>> dataSource,
    DataGridHelperStore3 store,
    List<DataGridColumnModel3> column,
  ) {
    List<Map<String, dynamic>> source = dataSource;
    Map<String, List<String>> filter = {};
    for (var f in filterKeys) {
      filter[f] = source.map((m) => m[f].toString()).toSet().toList();
    }
    return GetBuilder<DataGridHelperStore3>(
      init: store,
      autoRemove: false,
      builder: (store) {
        return Column(
          children: [
            TextBox(
              labelText: "Search",
              showAlwaysLabel: true,
              withBorder: false,
              backgroundColor: Colors.blue.shade50.withAlpha(180),
              controller: dataGridHelperStore.globalFilterSearchController,
              onValueChange: (v) {
                dataGridHelperStore.update();
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: filter.keys.map((m) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextHelper(text: m, camalToLabel: true, fontsize: 11.8),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                filter[m]
                                    ?.where(
                                      (f) => f.toLowerCase().contains(
                                        dataGridHelperStore
                                            .globalFilterSearchController
                                            .text
                                            .toLowerCase(),
                                      ),
                                    )
                                    .map((f) {
                                      return Row(
                                        children: [
                                          MoonCheckbox(
                                            value:
                                                store.globalFilters[m] !=
                                                    null &&
                                                store.globalFilters[m]!
                                                    .contains(f),
                                            activeColor: Colors.blue,
                                            onChanged: (v) {
                                              if (v == true) {
                                                if (store.globalFilters[m] !=
                                                    null) {
                                                  store.globalFilters[m]!.add(
                                                    f,
                                                  );
                                                } else {
                                                  store.globalFilters[m] = [f];
                                                }
                                              } else {
                                                store.globalFilters[m]!.remove(
                                                  f,
                                                );
                                                if (store
                                                    .globalFilters[m]!
                                                    .isEmpty) {
                                                  store.globalFilters.remove(m);
                                                }
                                              }
                                              filterDataSource();
                                              // store.makeGlobalFilter(column, dataSource);
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              bool v =
                                                  !(store.globalFilters[m] !=
                                                          null &&
                                                      store.globalFilters[m]!
                                                          .contains(f));
                                              if (v == true) {
                                                if (store.globalFilters[m] !=
                                                    null) {
                                                  store.globalFilters[m]!.add(
                                                    f,
                                                  );
                                                } else {
                                                  store.globalFilters[m] = [f];
                                                }
                                              } else {
                                                store.globalFilters[m]!.remove(
                                                  f,
                                                );
                                                if (store
                                                    .globalFilters[m]!
                                                    .isEmpty) {
                                                  store.globalFilters.remove(m);
                                                }
                                              }
                                              filterDataSource();
                                              // store.makeGlobalFilter(column, dataSource);
                                            },
                                            child: TextHelper(
                                              text: f,
                                              fontsize: 11,
                                              isWrap: true,
                                              camalToLabel: true,
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                    .toList() ??
                                [],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      // logG("changes widget.columnList");
      String previousUniqueKey = uniqueKeyGiven;
      uniqueKeyGiven = widget.uniqueKey;
      EasyDebounce.debounce(
        "datagridUpdate${widget.uniqueKey}",
        const Duration(milliseconds: 100),
        () {
          if (previousUniqueKey == uniqueKeyGiven) {
            initOwnWork();
            dataGridHelperStore.sortingColumn.value == null;
          } else {
            dataGridHelperStore.currentPageIndex.value = 0;
            initOwnWork(allRefresh: true);
            dataGridHelperStore.sortingColumn.value == null;
          }
          dataGridHelperStore.update();
          setState(() {});
        },
      );
    }, [widget.dataSource, widget.uniqueKey, widget.columnList]);
    return Builder(
      builder: (cc) {
        double columnContainerHeight = MediaQuery.sizeOf(cc).height - 200;
        if (widget.showFooter) {
          columnContainerHeight -= widget.rowHeight;
        }
        if (!widget.hideHeader) {
          columnContainerHeight -= widget.headerHeight;
        }
        return Obx(
          () => Container(
            color: widget.backgroundColor,
            child: Column(
              children: [
                if (widget.withSearch)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Datagrid inbuilt filter
                      if (widget.filterList != null &&
                          widget.filterList!.isNotEmpty)
                        GetBuilder<DataGridHelperStore3>(
                          init: dataGridHelperStore,
                          autoRemove: false,
                          builder: (dataGridHelperStore) {
                            return MoonPopover(
                              show: dataGridHelperStore.showFilter,
                              onTapOutside: () {
                                dataGridHelperStore.showFilter = false;
                                dataGridHelperStore.update();
                              },
                              popoverPosition: MoonPopoverPosition.bottom,
                              content: Material(
                                color: Colors.white,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 200,
                                    minHeight: 100,
                                    maxHeight: 500,
                                  ),
                                  child: getDataGridFilter(
                                    widget.filterList!,
                                    widget.dataSource,
                                    dataGridHelperStore,
                                    widget.columnList,
                                  ),
                                ),
                              ),
                              child: ButtonHelperG(
                                onTap: () {
                                  dataGridHelperStore.showFilter =
                                      !dataGridHelperStore.showFilter;
                                  dataGridHelperStore.update();
                                },
                                icon: Icon(
                                  Icons.filter_alt_rounded,
                                  color:
                                      dataGridHelperStore.globalFilters.isEmpty
                                      ? Colors.grey.shade600
                                      : Colors.blue.shade500,
                                ),
                                width: 35,
                                height: 35,
                                background: Colors.grey.shade100,
                                withBorder: true,
                                shadow: [],
                              ),
                            );
                          },
                        ),
                      // Datagrid search
                      TextBox(
                        width: 220,
                        height: 35,
                        borderRadius: 5,
                        placeholder: "Search..",
                        controller: dataGridHelperStore.searchBoxController,
                        onValueChange: (v) {
                          dataGridHelperStore.searchBoxText.value = v;
                          filterDataSource();
                          // dataGridHelperStore.makeGlobalFilter(widget.columnList, widget.dataSource);
                        },
                        trailing: const Icon(
                          MoonIcons.generic_search_24_regular,
                        ),
                      ),
                    ],
                  ),
                if (widget.withSearch) const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    margin: GetPlatform.isDesktop
                        ? const EdgeInsets.only(right: 0, bottom: 0)
                        : EdgeInsets.zero,
                    color: mainStore.isDarkEnable.value
                        ? Colors.black
                        : (widget.backgroundColor ?? Colors.white),
                    child: Row(
                      children: [
                        // This is for fix column -- start
                        if (widget.columnFixCount > 0 &&
                            widget.dataSource.isNotEmpty)
                          SizedBox(
                            width: List.generate(widget.columnFixCount, (
                              index,
                            ) {
                              return (widget.columnList[index].width ??
                                  getAutoHeadWidth());
                            }).fold(0.0, (a, b) => a! + b),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (widget.dataSource.isNotEmpty)
                                  // Header is dataSource is not empty
                                  SizedBox(
                                    height: widget.headerHeight,
                                    child: ListView.builder(
                                      addAutomaticKeepAlives: false,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.columnFixCount,
                                      itemBuilder: (context, index) => SizedBox(
                                        width:
                                            widget.columnList[index].width ??
                                            getAutoHeadWidth(),
                                        child: cellBuilding2(
                                          CellCoordinate(
                                            xIndex: index,
                                            yIndex: 0,
                                          ),
                                          widget.dataSource,
                                        ),
                                      ),
                                    ),
                                  ),

                                if (widget.dataSource.isEmpty)
                                  // const SizedBox.shrink()
                                  Expanded(
                                    child: Column(
                                      children: [getHeaderForEmptyDataSource()],
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(
                                        context,
                                      ).copyWith(scrollbars: false),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        controller: verticalFixScrollCon,
                                        child: Container(
                                          child: Row(
                                            children: List.generate(
                                              widget.columnFixCount,
                                              (indexColumn) => Container(
                                                // color: Colors.blue,
                                                constraints: BoxConstraints(
                                                  minHeight: columnContainerHeight,
                                                ),
                                                decoration: BoxDecoration(
                                                  border:
                                                      !widget.showBorderVertical
                                                      ? null
                                                      : Border(
                                                          right: BorderSide(
                                                            width: 1,
                                                            color: Colors
                                                                .blueGrey
                                                                .shade200,
                                                          ),
                                                        ),
                                                ),
                                                width:
                                                    widget
                                                        .columnList[indexColumn]
                                                        .width ??
                                                    getAutoHeadWidth(),
                                                // margin: const EdgeInsets.symmetric(horizontal: 2),
                                                child: Column(
                                                  children: List.generate(
                                                    dataGridHelperStore
                                                        .filteredDataSource
                                                        .value
                                                        .length,
                                                    (indexRow) {
                                                      final cellIndex =
                                                          indexColumn;
                                                      final columnData = widget
                                                          .columnList[indexColumn];
                                                      final String key =
                                                          columnData.dataField;
                                                      final rowValue =
                                                          dataGridHelperStore
                                                              .filteredDataSource
                                                              .value[indexRow];
                                                      final cellValue =
                                                          dataGridHelperStore
                                                              .filteredDataSource
                                                              .value[indexRow][key];
                                                      return singleCellMakeForBody(
                                                        columnData,
                                                        indexRow,
                                                        cellIndex,
                                                        rowValue,
                                                        cellValue,
                                                        true,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // ListView.builder(
                                      //   addAutomaticKeepAlives: false,
                                      //   controller: verticalFixScrollCon,
                                      //   cacheExtent: 200,
                                      //   itemExtent: widget.rowHeight,
                                      //   itemCount: dataGridHelperStore.filteredDataSource.value.length,
                                      //   itemBuilder: (context1, indexColumn) => RepaintBoundary(
                                      //     child: Row(
                                      //       children: [
                                      //         for (int i = 0; i < widget.columnFixCount; i++)
                                      //           SizedBox(
                                      //             height: widget.rowHeight,
                                      //             width: widget.columnList[i].width ?? getAutoHeadWidth(),
                                      //             child: cellBuilding2(
                                      //               CellCoordinate(xIndex: i, yIndex: indexColumn + 1),
                                      //               dataGridHelperStore.filteredDataSource.value,
                                      //             ),
                                      //           ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),

                                // Footer=======
                                // Footer=======
                                if (widget.showFooter)
                                  SizedBox(
                                    width: List.generate(
                                      widget.columnFixCount,
                                      (index) {
                                        return (widget
                                                .columnList[index]
                                                .width ??
                                            getAutoHeadWidth());
                                      },
                                    ).fold(0.0, (a, b) => a! + b),
                                    height: 40,
                                    // margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*0.015),
                                    child: Row(
                                      children: [
                                        // 🟦 Scrollable Footer Cells
                                        Expanded(
                                          child: Row(
                                            children: [
                                              for (
                                                int i = 0;
                                                i < widget.columnFixCount;
                                                i++
                                              )
                                                Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  width:
                                                      (widget
                                                              .columnList[i]
                                                              .width ??
                                                          getAutoHeadWidth()) -
                                                      widget.columnSpacing * 2,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      top: const BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                      bottom: const BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                      right: widget.withBorder
                                                          ? BorderSide(
                                                              width: 1,
                                                              color: widget
                                                                  .borderColor,
                                                            )
                                                          : BorderSide.none,
                                                    ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                      ),
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        widget.columnSpacing,
                                                    vertical: widget.rowSpacing,
                                                  ),
                                                  child:
                                                      widget
                                                              .columnList[i]
                                                              .customSummaryCell !=
                                                          null
                                                      ? widget
                                                            .columnList[i]
                                                            .customSummaryCell!(
                                                          getSummeryValue(
                                                            i,
                                                            widget
                                                                .columnList[i]
                                                                .summeryType,
                                                            dataGridHelperStore
                                                                .filteredDataSource
                                                                .value,
                                                          ),
                                                        )
                                                      : TextHelper(
                                                          text:
                                                              !widget
                                                                  .columnList[i]
                                                                  .withSummery
                                                              ? ""
                                                              : widget
                                                                        .columnList[i]
                                                                        .summeryPrefix +
                                                                    getSummeryValue(
                                                                      i,
                                                                      widget
                                                                          .columnList[i]
                                                                          .summeryType,
                                                                      dataGridHelperStore
                                                                          .filteredDataSource
                                                                          .value,
                                                                    ),
                                                          fontweight:
                                                              FontWeight.w600,
                                                          textalign:
                                                              widget
                                                                      .columnList[i]
                                                                      .textAlign ==
                                                                  CellTextAlignment3
                                                                      .left
                                                              ? TextAlign.left
                                                              : widget
                                                                        .columnList[i]
                                                                        .textAlign ==
                                                                    CellTextAlignment3
                                                                        .right
                                                              ? TextAlign.right
                                                              : TextAlign
                                                                    .center,
                                                          fontsize:
                                                              widget
                                                                  .columnList[i]
                                                                  .fontSize ??
                                                              widget.fontSize,
                                                        ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        // This is for fix column -- end
                        Expanded(
                          child: Scrollbar(
                            controller: horizontalScrollCon,
                            thumbVisibility: true,
                            child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(
                                context,
                              ).copyWith(scrollbars: true),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: horizontalScrollCon,
                                child: SizedBox(
                                  width: widget.dataSource.isEmpty
                                      ? widget.width
                                      : List.generate(
                                          widget.columnList.length -
                                              widget.columnFixCount,
                                          (index) {
                                            return (widget
                                                    .columnList[index +
                                                        widget.columnFixCount]
                                                    .width ??
                                                getAutoHeadWidth());
                                          },
                                        ).fold(0.0, (a, b) => a! + b),
                                  child: Column(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // This is header
                                      if (widget.dataSource.isNotEmpty)
                                        if (!widget.hideHeader)
                                          SizedBox(
                                            height: widget.headerHeight,
                                            child: Row(
                                              children: [
                                                for (
                                                  int i = 0;
                                                  i <
                                                      widget.columnList.length -
                                                          widget.columnFixCount;
                                                  i++
                                                )
                                                  SizedBox(
                                                    width:
                                                        widget
                                                            .columnList[i +
                                                                widget
                                                                    .columnFixCount]
                                                            .width ??
                                                        getAutoHeadWidth(),
                                                    child: cellBuilding2(
                                                      CellCoordinate(
                                                        xIndex:
                                                            i +
                                                            widget
                                                                .columnFixCount,
                                                        yIndex: 0,
                                                      ),
                                                      widget.dataSource,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                      if (widget.hideHeader)
                                        const Divider(height: 2),
                                      widget.dataSource.isEmpty
                                          ? Expanded(
                                              child: Column(
                                                children: [
                                                  getHeaderForEmptyDataSource(),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child:
                                                          widget.noDataWidget ??
                                                          const Text("No Item"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Expanded(
                                              child: Builder(
                                                builder: (context) {
                                                  return SingleChildScrollView(
                                                    controller:
                                                        verticalScrollCon,
                                                    child: Row(
                                                      children: List.generate(
                                                        widget
                                                                .columnList
                                                                .length -
                                                            widget
                                                                .columnFixCount,
                                                        (indexColumn) {
                                                          return Container(
                                                            constraints: BoxConstraints(
                                                              minHeight: columnContainerHeight,
                                                            ),
                                                            // color: Colors.blue,
                                                            // height: double.infinity,
                                                            decoration: BoxDecoration(
                                                              border:
                                                                  !widget
                                                                      .showBorderVertical
                                                                  ? null
                                                                  : Border(
                                                                      right:
                                                                          widget
                                                                              .withBorder
                                                                          ? BorderSide(
                                                                              width: 1,
                                                                              color: widget.borderColor,
                                                                            )
                                                                          : BorderSide.none,
                                                                    ),
                                                            ),
                                                            width:
                                                                widget
                                                                    .columnList[indexColumn +
                                                                        widget
                                                                            .columnFixCount]
                                                                    .width ??
                                                                getAutoHeadWidth(),
                                                            // margin: const EdgeInsets.symmetric(horizontal: 2),
                                                            child: Column(
                                                              children: List.generate(
                                                                dataGridHelperStore
                                                                    .filteredDataSource
                                                                    .value
                                                                    .length,
                                                                (indexRow) {
                                                                  final cellIndex =
                                                                      widget
                                                                          .columnFixCount +
                                                                      indexColumn;
                                                                  final columnData =
                                                                      widget
                                                                          .columnList[widget
                                                                              .columnFixCount +
                                                                          indexColumn];
                                                                  final String
                                                                  key = columnData
                                                                      .dataField;
                                                                  final rowValue =
                                                                      dataGridHelperStore
                                                                          .filteredDataSource
                                                                          .value[indexRow];
                                                                  final cellValue =
                                                                      dataGridHelperStore
                                                                          .filteredDataSource
                                                                          .value[indexRow][key];
                                                                  return singleCellMakeForBody(
                                                                    columnData,
                                                                    indexRow,
                                                                    cellIndex,
                                                                    rowValue,
                                                                    cellValue,
                                                                    false,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                  return Container(
                                                    color: Colors.blue,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                    child: ListView.builder(
                                                      addAutomaticKeepAlives:
                                                          false,
                                                      itemCount:
                                                          dataGridHelperStore
                                                              .filteredDataSource
                                                              .value
                                                              .length,
                                                      controller:
                                                          verticalScrollCon,
                                                      cacheExtent: 200,
                                                      itemExtent:
                                                          widget.rowHeight,
                                                      itemBuilder: (context1, indexColumn) => RepaintBoundary(
                                                        child: Row(
                                                          children: [
                                                            for (
                                                              int i = 0;
                                                              i <
                                                                  widget
                                                                          .columnList
                                                                          .length -
                                                                      widget
                                                                          .columnFixCount;
                                                              i++
                                                            )
                                                              SizedBox(
                                                                height: widget
                                                                    .rowHeight,
                                                                width:
                                                                    widget
                                                                        .columnList[i +
                                                                            widget.columnFixCount]
                                                                        .width ??
                                                                    getAutoHeadWidth(),
                                                                child: cellBuilding2(
                                                                  CellCoordinate(
                                                                    xIndex:
                                                                        i +
                                                                        widget
                                                                            .columnFixCount,
                                                                    yIndex:
                                                                        indexColumn +
                                                                        1,
                                                                  ),
                                                                  dataGridHelperStore
                                                                      .filteredDataSource
                                                                      .value,
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
                                      // : Expanded(
                                      //     child: SizedBox(
                                      //       width: List.generate(widget.columnList.length - widget.columnFixCount, (index) {
                                      //         return (widget.columnList[index + widget.columnFixCount].width ?? getAutoHeadWidth());
                                      //       }).fold(0.0, (a, b) => a! + b),
                                      //       child: Builder(builder: (context) {
                                      //         return Container(
                                      //           color: Colors.blue,
                                      //           margin: EdgeInsets.symmetric(horizontal: 10),
                                      //           child: ListView.builder(
                                      //             addAutomaticKeepAlives: false,
                                      //             itemCount: dataGridHelperStore.filteredDataSource.value.length,
                                      //             controller: verticalScrollCon,
                                      //             cacheExtent: 200,
                                      //             itemExtent: widget.rowHeight,
                                      //             itemBuilder: (context1, indexColumn) => RepaintBoundary(
                                      //               child: Row(
                                      //                 children: [
                                      //                   for (int i = 0; i < widget.columnList.length - widget.columnFixCount; i++)
                                      //                     SizedBox(
                                      //                       height: widget.rowHeight,
                                      //                       width: widget.columnList[i + widget.columnFixCount].width ?? getAutoHeadWidth(),
                                      //                       child: cellBuilding2(
                                      //                         CellCoordinate(xIndex: i + widget.columnFixCount, yIndex: indexColumn + 1),
                                      //                         dataGridHelperStore.filteredDataSource.value,
                                      //                       ),
                                      //                     ),
                                      //                 ],
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         );
                                      //       }),
                                      //     ),
                                      //   ),

                                      // Footer=======
                                      // Footer=======
                                      if (widget.showFooter)
                                        SizedBox(
                                          width: List.generate(
                                            widget.columnList.length -
                                                widget.columnFixCount,
                                            (index) {
                                              return (widget
                                                      .columnList[index +
                                                          widget.columnFixCount]
                                                      .width ??
                                                  getAutoHeadWidth());
                                            },
                                          ).fold(0.0, (a, b) => a! + b),
                                          height: 40,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                widget.columnList.length -
                                                widget.columnFixCount,
                                            itemBuilder: (ctx, i) {
                                              final col =
                                                  widget.columnList[i +
                                                      widget.columnFixCount];
                                              return Container(
                                                alignment: Alignment.center,
                                                width:
                                                    (col.width ??
                                                        getAutoHeadWidth()) -
                                                    widget.columnSpacing * 2,
                                                decoration: !widget.withBorder
                                                    ? null
                                                    : BoxDecoration(
                                                        border: Border(
                                                          top: BorderSide(
                                                            color: widget
                                                                .borderColor,
                                                          ),
                                                          right:
                                                              widget
                                                                  .showBorderVertical
                                                              ? BorderSide(
                                                                  color: widget
                                                                      .borderColor,
                                                                )
                                                              : BorderSide.none,
                                                          bottom: BorderSide(
                                                            color: widget
                                                                .borderColor,
                                                          ),
                                                        ),

                                                        // Border(
                                                        //     top: BorderSide(color: widget.borderColor),
                                                        //     bottom: BorderSide(color: widget.borderColor),
                                                        //     right: widget.withBorder ? BorderSide(width: 1, color: widget.borderColor) : BorderSide.none),
                                                      ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                    ),
                                                margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      widget.columnSpacing,
                                                  vertical: widget.rowSpacing,
                                                ),
                                                child:
                                                    col.customSummaryCell !=
                                                        null
                                                    ? col.customSummaryCell!(
                                                        getSummeryValue(
                                                          i +
                                                              widget
                                                                  .columnFixCount,
                                                          col.summeryType,
                                                          dataGridHelperStore
                                                              .filteredDataSource
                                                              .value,
                                                        ),
                                                      )
                                                    : TextHelper(
                                                        text: !col.withSummery
                                                            ? ""
                                                            : col.summeryPrefix +
                                                                  getSummeryValue(
                                                                    i +
                                                                        widget
                                                                            .columnFixCount,
                                                                    col.summeryType,
                                                                    dataGridHelperStore
                                                                        .filteredDataSource
                                                                        .value,
                                                                  ),
                                                        fontweight:
                                                            FontWeight.w600,
                                                        textalign:
                                                            col.textAlign ==
                                                                CellTextAlignment3
                                                                    .left
                                                            ? TextAlign.left
                                                            : col.textAlign ==
                                                                  CellTextAlignment3
                                                                      .right
                                                            ? TextAlign.right
                                                            : TextAlign.center,
                                                        fontsize:
                                                            widget
                                                                .columnList[i]
                                                                .fontSize ??
                                                            widget.fontSize,
                                                        color:
                                                            col.footerFontColor ??
                                                            col.fontColor,
                                                      ),
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (dataGridHelperStore.isPaginate.value)
                  const SizedBox(height: 5),
                if (dataGridHelperStore.isPaginate.value)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 9,
                    children: [
                      TextHelper(text: "Pages : ", fontweight: FontWeight.w700),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: 25,
                            child: Row(
                              spacing: 5,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: DropDownHelperG(
                                    uniqueKey: "pagesDataGrid3",
                                    trailing: const SizedBox.shrink(),
                                    borderRadius: 2,
                                    height: 24,
                                    leading: const SizedBox.shrink(),
                                    placeHolder: "",
                                    displayKey: "name",
                                    valueKey: "id",
                                    dropDownPosition:
                                        MoonDropdownAnchorPosition.top,
                                    followerAnchor: Alignment.bottomCenter,
                                    value:
                                        List.generate(
                                          dataGridHelperStore.totalPage.value,
                                          (index) => ({
                                            "id": index,
                                            "name": (index + 1).toString(),
                                            "value": (index + 1).toString(),
                                          }),
                                        ).firstWhereOrNull(
                                          (t) =>
                                              t["id"] ==
                                              dataGridHelperStore
                                                  .currentPageIndex
                                                  .value,
                                        ),
                                    items: List.generate(
                                      dataGridHelperStore.totalPage.value,
                                      (index) => ({
                                        "id": index,
                                        "name": (index + 1).toString(),
                                        "value": (index + 1).toString(),
                                      }),
                                    ),
                                    onValueChange: (v) {
                                      dataGridHelperStore
                                              .currentPageIndex
                                              .value =
                                          v["id"];
                                      filterDataSource();
                                    },
                                  ),
                                ),
                                TextHelper(text: "/"),
                                TextHelper(
                                  text: "${dataGridHelperStore.totalPage}",
                                  fontweight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (dataGridHelperStore.isPaginate.value)
                  const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum CellTextAlignment3 { center, left, right }

enum CellDataType3 { string, int, bool, date }

enum SummeryType3 { count, sum, none }

class CustomCellData3 {
  int rowIndex;
  int cellIndex;
  Map rowValue;
  dynamic cellValue;
  List<Map<String, dynamic>> data;

  CustomCellData3({
    required this.rowIndex,
    required this.cellIndex,
    required this.rowValue,
    required this.cellValue,
    required this.data,
  });
}

class DataGridColumnModel3 {
  final String dataField;
  final String? title;
  final bool? editable;
  final bool selectTextOnEditStart;
  final Color? headerFontColor;
  final Color? fontColor;
  final Color? footerFontColor;
  final double? width;
  final double? minWidth;
  final double? fontSize;
  final bool showFilter;
  final double? editorWidth;
  final TextInputType keyboard;
  final CellDataType3 dataType;
  final CellTextAlignment3 textAlign;
  final SummeryType3 summeryType;
  final bool withSummery;
  final bool withTooltip;
  final bool sortable;
  final String summeryPrefix;
  final Widget Function(CustomCellData3)? customCell;
  final Widget Function(CustomCellData3)? customHeaderCell;
  final Color Function(CustomCellData3)? rowColor;
  final bool Function(CustomCellData3)? customEditable;
  final Widget Function(String value)? customSummaryCell;
  final String Function(String value)? customFilterCellText;
  final Function(CustomCellData3)? onLongPress;
  DataGridColumnModel3({
    required this.dataField,
    this.title,
    this.editable,
    this.customEditable,
    this.width,
    this.minWidth,
    this.fontSize,
    this.editorWidth,
    this.summeryType = SummeryType3.none,
    this.withSummery = false,
    this.showFilter = false,
    this.withTooltip = false,
    this.sortable = false,
    this.headerFontColor,
    this.fontColor,
    this.footerFontColor,
    this.selectTextOnEditStart = false,
    this.keyboard = TextInputType.text,
    this.summeryPrefix = '',
    this.customCell,
    this.customHeaderCell,
    this.customSummaryCell,
    this.customFilterCellText,
    this.onLongPress,
    this.rowColor,
    required this.dataType,
    this.textAlign = CellTextAlignment3.center,
  });
}

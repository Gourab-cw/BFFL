import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';

import '../core/utility/helper.dart';
import 'mainstore.dart';

class IsolateArguments {
  final List<Map<String, dynamic>> data;
  final List<String> treeKeys;
  final String summeryKey;
  IsolateArguments({required this.data, required this.treeKeys, required this.summeryKey});
}

class StaggeredListController extends GetxController {
  RxInt renderedCount = 0.obs;

  void startRendering(int total, {int chunk = 200, int delayMs = 10}) {
    renderedCount.value = 0; // Reset before starting

    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: delayMs));

      if (renderedCount.value >= total) return false;

      renderedCount.value = (renderedCount.value + chunk).clamp(0, total);
      return true;
    });
  }
}

class StaggeredListRenderer extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final BuildContext context;
  final Widget Function(Map<String, dynamic>) itemBuilder;
  final String tag;

  const StaggeredListRenderer({Key? key, required this.data, required this.context, required this.itemBuilder, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StaggeredListController(), tag: tag);
    controller.startRendering(data.length);

    return Obx(() {
      final visibleCount = controller.renderedCount.value;
      final safeCount = visibleCount.clamp(0, data.length);
      final visibleItems = data.take(safeCount).toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: visibleItems.length,
        itemBuilder: (context, index) {
          return itemBuilder(visibleItems[index]);
        },
      );
    });
  }
}

class DeferredTree extends StatelessWidget {
  final Map<String, dynamic> node;
  final BuildContext context;
  final Widget Function({required List<Map<String, dynamic>> data, required BuildContext context}) makeTreeWidget;

  const DeferredTree({super.key, required this.node, required this.context, required this.makeTreeWidget});

  @override
  Widget build(BuildContext context) {
    final childList = makeListSerialize(node['child']);
    final tag = const Uuid().v4(); // Unique tag per subtree

    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 16)), // push to next frame (~1 frame)
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink(); // or loading placeholder
        }

        return StaggeredListRenderer(
          data: childList,
          context: context,
          itemBuilder: (item) => makeTreeWidget(data: [item], context: context),
          tag: tag,
        );
      },
    );
  }
}

class TreeHeaderData {
  final List<Map<String, dynamic>> child;
  final String value;
  final int treeIndex;
  final double summeryValue;
  final String key;
  final String id;
  TreeHeaderData({required this.child, required this.value, required this.treeIndex, required this.summeryValue, required this.key, required this.id});
}

class TreeDataStore extends GetxController {
  RxList<Map<String, dynamic>> list = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
}

abstract class HeaderTemplate {
  Widget build(BuildContext context, TreeHeaderData data);
}

abstract class ChildTemplate {
  Widget build(BuildContext context, dynamic data);
}

class TreeWidget extends StatefulHookWidget {
  final List<String> treeKeyList;
  final List<Map<String, dynamic>> dataSource;
  final bool firstChildExpand;
  final bool withSearch;
  final bool withSummery;
  final String searchKey;
  final String summeryKey;
  final Function(dynamic childData)? childOnTap;
  final Widget Function(dynamic childData) childCellMaker;
  final Widget Function(TreeHeaderData data)? headerCellMaker;
  final Color? headerBgColor;
  final HeaderTemplate? headerCellTemplate;
  final ChildTemplate? childCellTemplate;

  TreeWidget({
    super.key,
    required this.treeKeyList,
    required this.dataSource,
    required this.childCellMaker,
    this.headerCellTemplate,
    this.childCellTemplate,
    this.childOnTap,
    this.headerBgColor,
    this.headerCellMaker,
    this.searchKey = "",
    this.summeryKey = "",
    this.withSearch = false,
    this.withSummery = false,
    this.firstChildExpand = false,
  });

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> {
  final uniqueId = const Uuid().v4();
  late final TreeDataStore treeDataStore = Get.put(TreeDataStore(), tag: uniqueId);
  final TextEditingController searchController = TextEditingController();
  String searchText = "";
  MainStore mainStore = Get.find();
  static List<Map<String, dynamic>> treeDataCreator(IsolateArguments arg) {
    List<String> treeKeys = arg.treeKeys;
    List<Map<String, dynamic>> data = arg.data;
    String summeryKey = arg.summeryKey;
    if (treeKeys.isEmpty) {
      throw ErrorSummary("Error! Minimum 1 keys needed to make tree widget");
    }
    final stopwatch = Stopwatch()..start();
    final Map<String, dynamic> tree = {};

    for (final item in data) {
      Map<String, dynamic> currentLevel = tree;
      for (int i = 0; i < treeKeys.length; i++) {
        final keyVal = parseString(data: item[treeKeys[i]], defaultValue: "");
        currentLevel.putIfAbsent(keyVal, () {
          return {
            'name': keyVal,
            'key': treeKeys[i],
            'id': parseString(data: item["id"], defaultValue: ""),
            'treeIndex': i + 1,
            "summeryValue": summeryKey.isEmpty
                ? 0
                : data
                      .where((w) => w[treeKeys[i]] == keyVal)
                      .map((m) => m[summeryKey])
                      .fold(0.0, (a, b) => parseDouble(data: a, defaultValue: 0) + parseDouble(data: b, defaultValue: 0)),
            'child': i == treeKeys.length - 1 ? <Map<String, dynamic>>[] : <String, dynamic>{},
          };
        });

        final node = currentLevel[keyVal];
        if (i == treeKeys.length - 1) {
          node['child'].add(item);
        } else {
          currentLevel = node['child'];
        }
      }
    }

    // Recursive cleanup
    List<Map<String, dynamic>> flattenTree(Map<String, dynamic> node) {
      return node.values.map<Map<String, dynamic>>((n) {
        final child = n['child'];
        if (child is Map) {
          n['child'] = flattenTree((child as Map<String, dynamic>));
        }
        return n;
      }).toList();
    }

    stopwatch.stop();
    print('⏱️ Total time: ${stopwatch.elapsed.inSeconds} s');
    return flattenTree(tree);
  }

  void treeDataSetter({required List<Map<String, dynamic>> data, required List<String> treeKeys}) async {
    try {
      treeDataStore.isLoading.value = true;
      final result = await compute(treeDataCreator, IsolateArguments(data: widget.dataSource, treeKeys: widget.treeKeyList, summeryKey: widget.summeryKey))
          .whenComplete(() {
            treeDataStore.isLoading.value = false;
          });
      treeDataStore.list.value = result;
    } catch (e) {
      showAlert(" $e", AlertType.error, context);
    }
  }

  Widget makeTreeWidget({required List<Map<String, dynamic>> data, required BuildContext context, Color? headerBgColor}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Don't allow inner scroll
      itemCount: data.length,
      itemBuilder: (context, index) {
        final d = data[index];
        // logG("${d["summeryValue"]} ${parseDouble(data: d["summeryValue"], defaultValue: 0.0)}");
        // Base case (leaf node)
        if (d['treeIndex'] == null || d['treeIndex'] == 0) {
          return RepaintBoundary(
            key: ValueKey(d["ItemId"] ?? const Uuid().v4()),
            child: GestureDetector(
              onTap: () {
                if (widget.childOnTap != null) {
                  widget.childOnTap!(d);
                }
              },
              child: widget.childCellTemplate != null ? widget.childCellTemplate!.build(context, d) : widget.childCellMaker(d),
            ),
          );
        }
        // return Container();
        // return Obx(() {
        final childList = makeListSerialize(d['child']);
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          child: MoonAccordion(
            initiallyExpanded: d["treeIndex"] == 1 ? widget.firstChildExpand : false,
            maintainState: true,
            propagateGesturesToChild: true,
            label: widget.headerCellTemplate != null
                ? widget.headerCellTemplate!.build(
                    context,
                    TreeHeaderData(
                      id: d['id'],
                      key: d['key'],
                      child: childList,
                      value: d['name'],
                      treeIndex: d['treeIndex'],
                      summeryValue: parseDouble(data: d["summeryValue"], defaultValue: 0.0),
                    ),
                  )
                : widget.headerCellMaker != null
                ? widget.headerCellMaker!(
                    TreeHeaderData(
                      id: d['id'],
                      key: d['key'],
                      child: childList,
                      value: d['name'],
                      treeIndex: d['treeIndex'],
                      summeryValue: parseDouble(data: d["summeryValue"], defaultValue: 0.0),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 5 * parseDouble(data: d['treeIndex'], defaultValue: 0.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextHelper(text: d['name'], isWrap: true, fontweight: FontWeight.w600),
                        ),
                        if (widget.withSummery)
                          TextHelper(
                            width: 120,
                            text: currenyFormater(value: d['summeryValue']),
                            fontweight: FontWeight.w600,
                          ),
                      ],
                    ),
                  ),
            showBorder: false,
            accordionSize: MoonAccordionSize.lg,
            decoration: BoxDecoration(
              color: widget.headerCellTemplate != null
                  ? Colors.transparent
                  : headerBgColor ?? (mainStore.isDarkEnable.value ? Colors.grey.shade900 : Colors.white),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent),
            ),
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: DeferredTree(node: d, context: context, makeTreeWidget: makeTreeWidget),
              ),
            ],
          ),
        );
        // });
      },
    );
  }

  @override
  void dispose() {
    treeDataStore.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      List<Map<String, dynamic>> filteredData = widget.dataSource;
      if (widget.searchKey.isNotEmpty && widget.withSearch && searchText.isNotEmpty) {
        List<String> keyList = widget.searchKey.split(",");
        filteredData.retainWhere((f) {
          List<String> datas = [];
          for (String item in keyList) {
            if (parseString(data: f[item], defaultValue: "").isNotEmpty) {
              datas.add(parseString(data: f[item], defaultValue: ""));
            }
          }
          if (datas.isEmpty) {
            return true;
          }
          if (datas.any((d) => d.toString().toLowerCase().contains(searchText.toLowerCase()))) {
            return true;
          } else {
            return false;
          }
        });
      }
      treeDataSetter(data: filteredData, treeKeys: widget.treeKeyList);
      return null;
    }, [widget.dataSource, widget.treeKeyList, searchText]);
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.withSearch) const SizedBox(height: 10),
          if (widget.withSearch)
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextBox(
                width: 250,
                labelText: "Search ",
                controller: searchController,
                onValueChange: (v) {
                  setState(() {
                    searchText = v;
                  });
                },
                showAlwaysLabel: true,
                trailing: const Icon(MoonIcons.generic_search_24_regular),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: treeDataStore.isLoading.value
                  ? Center(
                      child: TextHelper(text: "Loading...", fontsize: 13, fontweight: FontWeight.w600, textalign: TextAlign.center),
                    )
                  : SingleChildScrollView(
                      child: makeTreeWidget(data: treeDataStore.list.value, headerBgColor: widget.headerBgColor, context: context),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

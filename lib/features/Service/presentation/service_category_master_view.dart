import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/controller/service_category_master_controller.dart';
import 'package:healthandwellness/features/Service/data/category.dart';
import 'package:moon_design/moon_design.dart';
import 'package:uuid/uuid.dart';

class ServiceCategoryMasterView extends StatefulWidget {
  const ServiceCategoryMasterView({super.key});

  @override
  State<ServiceCategoryMasterView> createState() => _ServiceCategoryMasterViewState();
}

class _ServiceCategoryMasterViewState extends State<ServiceCategoryMasterView> {
  final ServiceCategoryMasterController controller = Get.find<ServiceCategoryMasterController>();
  final MainStore mainStore = Get.find<MainStore>();
  final AppLoaderController loader = Get.find<AppLoaderController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future(() async {
      try {
        loader.startLoading();
        await controller.getInitialData();
      } catch (e) {
        showAlert("$e", AlertType.error);
      } finally {
        loader.stopLoading();
      }
    });
  }

  void _showAddEditDialog({CategoryModel? category}) {
    final TextEditingController nameInputController = TextEditingController(
      text: category != null ? category.name : "",
    );
    bool statusValue = category != null ? category.isActive : true;

    showAdaptiveDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8 > 400 ? 400 : MediaQuery.sizeOf(context).width * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHelper(
                        text: category == null ? "Add Category" : "Edit Category",
                        fontsize: 15,
                        fontweight: FontWeight.w600,
                      ),
                      const Divider(),
                      Row(
                        children: [
                          TextHelper(text: "Name:", width: 60, fontweight: FontWeight.w600, showRequired: true),
                          Expanded(
                            child: TextBox(
                              controller: nameInputController,
                              placeholder: "e.g., Physiotherapy",
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextHelper(text: "Active Status", fontweight: FontWeight.w600),
                          MoonSwitch(
                            value: statusValue,
                            onChanged: (v) => setState(() => statusValue = v),
                            switchSize: MoonSwitchSize.xs,
                            activeTrackColor: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 10,
                        children: [
                          ButtonHelperG(
                            onTap: () => Navigator.pop(context),
                            background: Colors.grey.shade100,
                            label: TextHelper(text: "Cancel", color: Colors.grey.shade700, fontweight: FontWeight.w500),
                            width: 80,
                            height: 35,
                          ),
                          ButtonHelperG(
                            onTap: () async {
                              final trimmedName = nameInputController.text.trim();
                              if (trimmedName.isEmpty) {
                                showAlert("Please enter a category name", AlertType.error);
                                return;
                              }
                              try {
                                Navigator.pop(context);
                                loader.startLoading();
                                final categoryToSave = CategoryModel(
                                  id: category != null ? category.id : const Uuid().v4(),
                                  name: trimmedName,
                                  branchId: category != null ? category.branchId : "",
                                  companyId: category != null ? category.companyId : "",
                                  isActive: statusValue,
                                );
                                await controller.saveCategory(categoryToSave);
                              } catch (e) {
                                showAlert("$e", AlertType.error);
                              } finally {
                                loader.stopLoading();
                              }
                            },
                            background: mainStore.theme.value.HeadColor,
                            label: TextHelper(text: "Save", color: Colors.white, fontweight: FontWeight.w600),
                            width: 80,
                            height: 35,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Service Category Master"),
          actions: [
            ButtonHelperG(
              onTap: () async {
                try {
                  loader.startLoading();
                  await controller.fetchCategories();
                } catch (e) {
                  showAlert("$e", AlertType.error);
                } finally {
                  loader.stopLoading();
                }
              },
              shadow: const [],
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: GetBuilder<ServiceCategoryMasterController>(
            init: controller,
            autoRemove: false,
            builder: (controller) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextBox(
                            controller: searchController,
                            leading: const Icon(MoonIcons.generic_search_24_regular),
                            placeholder: "Search Category..",
                            onValueChange: (c) {
                              controller.searchKey = c;
                              controller.update();
                            },
                          ),
                        ),
                        ButtonHelperG(
                          onTap: () => _showAddEditDialog(),
                          shadow: const [],
                          width: 80,
                          background: mainStore.theme.value.BackgroundColor,
                          height: 35,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: mainStore.theme.value.HeadColor, size: 18),
                              const SizedBox(width: 4),
                              TextHelper(
                                text: "Add",
                                color: mainStore.theme.value.HeadColor,
                                fontweight: FontWeight.w600,
                                fontsize: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        List<CategoryModel> filteredList = controller.categories;
                        if (controller.searchKey.isNotEmpty) {
                          filteredList = controller.categories
                              .where((c) => c.name.toLowerCase().contains(controller.searchKey.toLowerCase()))
                              .toList();
                        }

                        if (filteredList.isEmpty) {
                          return Center(
                            child: TextHelper(
                              text: "No categories found",
                              fontsize: 14,
                              fontweight: FontWeight.w500,
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredList.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (_, index) {
                            final CategoryModel category = filteredList[index];
                            return CardHelper(
                              onTap: () => _showAddEditDialog(category: category),
                              backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                              height: 60,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  const Icon(FontAwesomeIcons.list, color: Colors.blueGrey, size: 18),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextHelper(
                                          text: category.name,
                                          fontweight: FontWeight.w600,
                                          fontsize: 13.5,
                                        ),
                                        const SizedBox(height: 2),
                                        TextHelper(
                                          text: category.isActive ? "Active" : "Inactive",
                                          fontsize: 10,
                                          color: category.isActive ? Colors.green : Colors.red,
                                          fontweight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MoonSwitch(
                                        value: category.isActive,
                                        onChanged: (v) async {
                                          try {
                                            loader.startLoading();
                                            await controller.toggleCategoryActive(category);
                                          } catch (e) {
                                            showAlert("$e", AlertType.error);
                                          } finally {
                                            loader.stopLoading();
                                          }
                                        },
                                        switchSize: MoonSwitchSize.xs,
                                        activeTrackColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

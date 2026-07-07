import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/utility/app_loader.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/controller/service_master_controller.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:moon_design/moon_design.dart';

class ServiceMasterView extends StatefulWidget {
  const ServiceMasterView({super.key});

  @override
  State<ServiceMasterView> createState() => _ServiceMasterViewState();
}

class _ServiceMasterViewState extends State<ServiceMasterView> {
  final ServiceMasterController controller = Get.find<ServiceMasterController>();
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

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Service Master"),
          actions: [
            ButtonHelperG(
              onTap: () async {
                try {
                  loader.startLoading();
                  await controller.fetchServices();
                } catch (e) {
                  showAlert("$e", AlertType.error);
                } finally {
                  loader.stopLoading();
                }
              },
              shadow: [],
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: GetBuilder<ServiceMasterController>(
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
                            placeholder: "Search Service..",
                            onValueChange: (c) {
                              controller.searchKey = c;
                              controller.update();
                            },
                          ),
                        ),
                        ButtonHelperG(
                          onTap: () {
                            Get.toNamed('/servicecreateedit');
                          },
                          shadow: [],
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
                        List<ServiceModel> filteredList = controller.services;
                        if (controller.searchKey.isNotEmpty) {
                          filteredList = controller.services
                              .where((s) => s.name.toLowerCase().contains(controller.searchKey.toLowerCase()))
                              .toList();
                        }

                        if (filteredList.isEmpty) {
                          return Center(
                            child: TextHelper(
                              text: "No services found",
                              fontsize: 14,
                              fontweight: FontWeight.w500,
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredList.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (_, index) {
                            final ServiceModel service = filteredList[index];
                            return CardHelper(
                              onTap: () {
                                Get.toNamed('/servicecreateedit', arguments: service);
                              },
                              backgroundColor: mainStore.theme.value.lowShadeColor.withAlpha(180),
                              height: 80,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: service.image.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: service.image,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorWidget: (context, url, error) => Container(
                                              color: Colors.blueGrey.shade100,
                                              width: 60,
                                              height: 60,
                                              child: const Icon(Icons.health_and_safety_rounded, color: Colors.blueGrey),
                                            ),
                                          )
                                        : Container(
                                            color: Colors.blueGrey.shade100,
                                            width: 60,
                                            height: 60,
                                            child: const Icon(Icons.health_and_safety_rounded, color: Colors.blueGrey),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        TextHelper(
                                          text: service.name,
                                          fontweight: FontWeight.w600,
                                          fontsize: 13.5,
                                        ),
                                        const SizedBox(height: 2),
                                        TextHelper(
                                          text: service.categoryName.isNotEmpty
                                              ? service.categoryName
                                              : "No Category",
                                          fontsize: 11,
                                          color: Colors.blueGrey.shade500,
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            TextHelper(
                                              text: currenyFormater(value: service.amount, withDrCr: false),
                                              fontsize: 11,
                                              fontweight: FontWeight.w600,
                                              color: mainStore.theme.value.HeadColor,
                                            ),
                                            TextHelper(
                                              text: " • ${service.totalDays} Days",
                                              fontsize: 11,
                                              color: Colors.blueGrey.shade600,
                                            ),
                                            if (service.isTrial)
                                              Container(
                                                margin: const EdgeInsets.only(left: 6),
                                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: Colors.purple.shade50,
                                                  border: Border.all(color: Colors.purple.shade200),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  "Trial",
                                                  style: TextStyle(fontSize: 8.5, color: Colors.purple.shade700, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MoonSwitch(
                                        value: service.isActive,
                                        onChanged: (v) async {
                                          try {
                                            loader.startLoading();
                                            await controller.toggleServiceActive(service);
                                          } catch (e) {
                                            showAlert("$e", AlertType.error);
                                          } finally {
                                            loader.stopLoading();
                                          }
                                        },
                                        switchSize: MoonSwitchSize.xs,
                                        activeTrackColor: Colors.green,
                                      ),
                                      const SizedBox(height: 4),
                                      TextHelper(
                                        text: service.isActive ? "Active" : "Inactive",
                                        fontsize: 9,
                                        fontweight: FontWeight.w500,
                                        color: service.isActive ? Colors.green : Colors.red,
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

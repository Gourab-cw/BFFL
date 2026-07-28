import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:moon_design/moon_design.dart';

import '../../../app/mainstore.dart';
import '../../../core/utility/app_loader.dart';
import '../controller/service_controller.dart';

class ServiceView extends StatefulWidget {
  const ServiceView({super.key});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  final MainStore mainStore = Get.find<MainStore>();
  final Authenticator auth = Get.find<Authenticator>();
  final ServiceController service = Get.find<ServiceController>();
  final AppLoaderController loaderController = Get.find<AppLoaderController>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);

  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  Future<void> fetchingServices() async {
    // mainStore.makeLoading();
    try {
      loaderController.startLoading();
      await service.getServiceList();
    } catch (e) {
      showAlert("$e", AlertType.error);
    } finally {
      // mainStore.stopLoading();
      loaderController.stopLoading();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Future(() {
      fetchingServices();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainStore.theme.value.BackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Services',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        elevation: 0,
        // backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey.shade900,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: GetBuilder<ServiceController>(
            init: service,
            autoRemove: false,
            builder: (service) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modern Header & Search Bar Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHelper(
                            text: "Available Services",
                            fontweight: FontWeight.w700,
                            fontsize: 17,
                            color: Colors.blueGrey.shade900,
                            padding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 2),
                          TextHelper(
                            text: "Explore and book wellness sessions",
                            fontsize: 12,
                            color: Colors.grey.shade600,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),

                      if (showSearch)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextBox(
                              controller: searchController,
                              autofocus: true,
                              onValueChange: (v) {
                                service.searchKey = v;
                                service.update();
                              },
                              trailing: ButtonHelperG(
                                onTap: () {
                                  setState(() {
                                    showSearch = false;
                                  });
                                  searchController.clear();
                                  service.searchKey = "";
                                  service.update();
                                },
                                icon: Icon(
                                  MoonIcons.controls_close_24_regular,
                                  size: 18,
                                  color: Colors.blueGrey.shade700,
                                ),
                                background: Colors.transparent,
                              ),
                              placeholder: "Search...",
                            ),
                          ),
                        )
                      else
                        ButtonHelperG(
                          onTap: () {
                            setState(() {
                              showSearch = true;
                            });
                            searchController.clear();
                            service.searchKey = "";
                            service.update();
                          },
                          width: 38,
                          height: 38,
                          background: Colors.white,
                          icon: Icon(
                            MoonIcons.generic_search_24_regular,
                            color: Colors.blueGrey.shade700,
                            size: 18,
                          ),
                          margin: 0,
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Service Cards Grid
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: GetBuilder<ServiceController>(
                        init: service,
                        builder: (service) {
                          final filteredServices = service.services
                              .where(
                                (w) => w.name.toLowerCase().contains(
                                  service.searchKey.toLowerCase(),
                                ),
                              )
                              .toList();

                          if (filteredServices.isEmpty) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(32),
                              margin: const EdgeInsets.only(top: 40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MoonIcons.generic_ticket_24_regular,
                                    size: 48,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  TextHelper(
                                    text: "No services found",
                                    fontsize: 15,
                                    fontweight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredServices.length,
                            separatorBuilder: (ctx, idx) =>
                                const SizedBox(height: 10),
                            itemBuilder: (ctx, index) {
                              final m = filteredServices[index];
                              return GestureDetector(
                                onTap: () {
                                  service.selectedService = m;
                                  Get.toNamed('/servicedetailsview');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(6),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Compact Thumbnail Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: m.image,
                                          fit: BoxFit.cover,
                                          width: 58,
                                          height: 58,
                                          errorWidget: (ctx, _, _) => Container(
                                            width: 58,
                                            height: 58,
                                            color: mainStore
                                                .theme
                                                .value
                                                .HeadColor
                                                .withAlpha(20),
                                            child: Icon(
                                              Icons.health_and_safety_rounded,
                                              size: 28,
                                              color: mainStore
                                                  .theme
                                                  .value
                                                  .HeadColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      // Service Title & Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextHelper(
                                              text: m.name,
                                              fontweight: FontWeight.w700,
                                              fontsize: 14,
                                              color: Colors.blueGrey.shade900,
                                              isWrap: true,
                                              padding: EdgeInsets.zero,
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.verified_rounded,
                                                  size: 12,
                                                  color: mainStore
                                                      .theme
                                                      .value
                                                      .HeadColor,
                                                ),
                                                const SizedBox(width: 3),
                                                TextHelper(
                                                  text:
                                                      "Tap for details & slots",
                                                  fontsize: 11,
                                                  color: Colors.grey.shade600,
                                                  padding: EdgeInsets.zero,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Compact Action Pill Button
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              mainStore.theme.value.HeadColor,
                                              mainStore.theme.value.HeadColor
                                                  .withAlpha(210),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: mainStore
                                                  .theme
                                                  .value
                                                  .HeadColor
                                                  .withAlpha(50),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextHelper(
                                              text: "Book",
                                              color: Colors.white,
                                              fontweight: FontWeight.w700,
                                              fontsize: 12,
                                              padding: EdgeInsets.zero,
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              MoonIcons
                                                  .arrows_chevron_right_double_24_regular,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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

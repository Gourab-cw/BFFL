import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
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
  final ServiceController service = Get.find<ServiceController>();
  final AppLoaderController loaderController = Get.find<AppLoaderController>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
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
    final safePadding = MediaQuery.paddingOf(context);
    return GetBuilder<ServiceController>(
      init: service,
      autoRemove: false,
      builder: (service) {
        return Padding(
          padding: EdgeInsets.only(left: safePadding.left + 10, right: safePadding.right + 10, top: safePadding.top + 10, bottom: safePadding.bottom),
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                TextHelper(text: "Available Services", fontweight: FontWeight.w600, fontsize: 16),
                Divider(),
                GetBuilder<ServiceController>(
                  init: service,
                  builder: (service) {
                    return Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        ...service.services.map(
                          (m) => GestureDetector(
                            onTap: () {
                              service.selectedService = m;
                              Get.toNamed('/servicedetailsview');
                              service.update();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 2)],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: m.image,
                                      fit: BoxFit.cover,
                                      width: 160,
                                      height: 160,
                                      errorWidget: (ctx, _, _) => Icon(Icons.health_and_safety_rounded),
                                    ),

                                    // Positioned(
                                    //   bottom: 0,
                                    //   child: ImageFiltered(
                                    //     imageFilter: ImageFilter.blur(sigmaX: 5.5, sigmaY: 3, tileMode: TileMode.decal),
                                    //     child: Container(
                                    //       width: double.maxFinite,
                                    //       decoration: BoxDecoration(color: Colors.white.withAlpha(140)),
                                    //       height: 40,
                                    //       child: Text(""),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Positioned(
                                    //   bottom: 0,
                                    //   child: Container(
                                    //     width: double.maxFinite,
                                    //     decoration: BoxDecoration(color: Colors.white.withAlpha(100)),
                                    //     height: 40,
                                    //     child: TextHelper(
                                    //       text: m.name,
                                    //       padding: EdgeInsets.symmetric(horizontal: 8),
                                    //       isWrap: true,
                                    //       fontsize: 11.5,
                                    //       fontweight: FontWeight.w600,
                                    //     ),
                                    //   ),
                                    // ),
                                    Positioned(
                                      top: 5,
                                      left: 5,
                                      child: TextHelper(
                                        text: m.name,
                                        color: Colors.white,
                                        shadow: [BoxShadow(color: Colors.black, spreadRadius: 1, blurRadius: 1)],
                                        fontweight: FontWeight.w600,
                                        fontsize: 14,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 5,
                                      left: 5,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                                          child: ButtonHelperG(
                                            margin: 0,
                                            borderRadius: 20,
                                            background: Colors.grey.withAlpha(50),
                                            shadow: [],
                                            withBorder: true,
                                            width: 150,
                                            height: 32,
                                            label: TextHelper(text: "Book Now!", color: Colors.white),
                                            icon: Icon(MoonIcons.arrows_chevron_right_double_24_regular, size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

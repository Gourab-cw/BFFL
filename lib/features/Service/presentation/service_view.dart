import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/provider.dart';
import 'package:healthandwellness/core/utility/helper.dart';

import '../../../app/mainstore.dart';
import '../../../core/utility/app_loader.dart';

class ServiceView extends ConsumerStatefulWidget {
  const ServiceView({super.key});

  @override
  ConsumerState<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends ConsumerState<ServiceView> {
  final MainStore mainStore = Get.find<MainStore>();
  final AppLoaderController loaderController = Get.find<AppLoaderController>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  Future<void> fetchingServices() async {
    // mainStore.makeLoading();
    try {
      loaderController.startLoading();
      final serviceProvider = ref.read(serviceStateProvider.notifier);
      await serviceProvider.getServiceList();
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
    final serviceProvider = ref.watch(serviceStateProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Wrap(
            children: [...serviceProvider.services.map((m) => Container(child: TextHelper(text: m.name)))],
          ),
        ],
      ),
    );
  }
}

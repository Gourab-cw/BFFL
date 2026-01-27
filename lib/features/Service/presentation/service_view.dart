import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/app/provider.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/helper.dart';
import '../../../app/mainstore.dart';
import '../../../core/utility/app_loader.dart';
import '../../../core/widget/bottom_nav_bar.dart';

class ServiceView extends ConsumerStatefulWidget {
  const ServiceView({super.key});

  @override
  ConsumerState<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends ConsumerState<ServiceView> {
  final MainStore mainStore = Get.find<MainStore>();
  late final EdgeInsets safePadding = MediaQuery.paddingOf(context);
  Future<void> fetchingServices()async{
    mainStore.makeLoading();
    try{
      final serviceProvider = ref.read(serviceStateProvider.notifier);
     await serviceProvider.getServiceList();
    }catch(e){
      showAlert("$e", AlertType.error);
    }finally{
      mainStore.stopLoading();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchingServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final serviceProvider = ref.watch(serviceStateProvider);
    return AppLoader(child: Scaffold(
        bottomNavigationBar: BottomNavbar(),
        body: Padding(
            padding: EdgeInsets.only(
              top: safePadding.top,
              bottom: safePadding.bottom,
              left: safePadding.left+5,
              right: safePadding.right+5,
            ),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Wrap(
                      children: [
                        ...serviceProvider.services.map((m)=>Container(
                          child: TextHelper(text: m.name),
                        ))
                      ],
                    )
                  ]),
            )
        )
    ));
  }


}

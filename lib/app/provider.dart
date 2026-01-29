import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/Service/data/service_state.dart';
import 'package:healthandwellness/features/Service/repository/service_notifier.dart';

final mainStoreProvider = Provider<MainStore>((ref) {
  return Get.find<MainStore>();
});

final serviceStateProvider = NotifierProvider<ServiceNotifier, ServiceState>(ServiceNotifier.new);

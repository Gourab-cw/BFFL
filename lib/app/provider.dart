import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/core/Picklist/picklist_item.dart';
import 'package:healthandwellness/features/Service/data/service_state.dart';
import 'package:healthandwellness/features/Service/repository/service_notifier.dart';
import 'package:healthandwellness/features/login/repository/user_notifier.dart';

import '../core/Picklist/picklist_provider.dart';

final mainStoreProvider = Provider<MainStore>((ref) {
  return Get.find<MainStore>();
});


final userProvider = NotifierProvider(UserNotifier.new);
final serviceStateProvider = NotifierProvider<ServiceNotifier,ServiceState>(ServiceNotifier.new);
final pickListProvider = NotifierProvider<PickListNotifier,List<PicklistItem>>(PickListNotifier.new);

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/app/mainstore.dart';
import 'package:healthandwellness/features/login/repository/user_notifier.dart';

final mainStoreProvider = Provider<MainStore>((ref) {
  return Get.find<MainStore>();
});


final userProvider = NotifierProvider(UserNotifier.new);

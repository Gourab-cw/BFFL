

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';

final firebaseProvider =
NotifierProvider<FirebaseNotifier, FirebaseG>(FirebaseNotifier.new);

class FirebaseNotifier extends Notifier<FirebaseG>{
  @override
  FirebaseG build() {
    return FirebaseG();
  }

}
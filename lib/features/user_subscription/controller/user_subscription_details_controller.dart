import 'package:get/get.dart';
import 'package:healthandwellness/core/utility/firebase_service.dart';
import 'package:healthandwellness/features/Service/data/session_model.dart';
import 'package:healthandwellness/features/login/repository/authenticator.dart';
import 'package:healthandwellness/features/user_subscription/data/user_subscription.dart';

import '../../../core/utility/helper.dart';
import '../../Payment/data/payment_model.dart';

class UserSubscriptionDetailsController extends GetxController {
  final auth = Get.find<Authenticator>();
  final fb = Get.find<FB>();
  UserSubscription? selectedSubscription;

  List<SessionModel> sessions = [];
  List<PaymentModel> payments = [];
  Future<void> initDataLoader() async {
    final db = await fb.getDB();
    final [sessionSnaps, paymentSnaps] = await Future.wait([
      db.collection('session').where('subscriptionId', isEqualTo: selectedSubscription!.id).get(),
      db.collection('payment').where('subscriptionId', isEqualTo: selectedSubscription!.id).get(),
    ]);
    sessions = sessionSnaps.docs.map((doc) => SessionModel.fromFirestore(doc)).toList();
    payments = paymentSnaps.docs.map((doc) => PaymentModel.fromJson(makeMapSerialize(doc.data()))).toList();

    update();
  }
}

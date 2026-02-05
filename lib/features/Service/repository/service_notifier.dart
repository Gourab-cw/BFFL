import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthandwellness/features/Service/data/service.dart';
import 'package:intl/intl.dart';

import '../../../app/firebase_provider.dart';
import '../../../core/utility/firebase_service.dart';
import '../data/service_state.dart';

class ServiceNotifier extends Notifier<ServiceState> {
  late FirebaseG firebase;

  @override
  ServiceState build() {
    // TODO: implement build
    firebase = ref.read(firebaseProvider);
    return ServiceState(services: []);
  }

  Future<void> getServiceList() async {
    final db = await firebase.getDB();
    final resp = await db.collection("Subscription").where('isActive', isEqualTo: true).get();
    if (resp.docs.isNotEmpty) {
      final services = resp.docs.map((doc) {
        return ServiceModel.fromJson(doc.data());
      }).toList();

      state = state.copyWith(services: services);
    }
  }

  Future<void> getServiceDetails(String docId, String branchId) async {
    final db = await firebase.getDB();
    final String currentMonth = DateFormat('yyyy-MM').format(DateTime.now());
    final resp = await db
        .collection('yourCollectionName')
        .where('branchId', isEqualTo: branchId)
        .where('isActive', isEqualTo: true)
        .where('month', isGreaterThanOrEqualTo: currentMonth)
        .orderBy('month')
        .get();

    if (resp.docs.isNotEmpty) {
      final services = resp.docs.map((doc) {
        return ServiceModel.fromJson(doc.data());
      }).toList();

      state = state.copyWith(services: services);
    }
  }
}

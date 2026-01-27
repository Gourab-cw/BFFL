import 'package:healthandwellness/core/utility/helper.dart';
import 'package:healthandwellness/features/Service/data/service.dart';

class ServiceState{
  final List<ServiceModel> services;

  ServiceState({required this.services});

  factory ServiceState.fromJSON(Map<String,dynamic> data)=>ServiceState(
      services: makeListSerialize(data["services"]).map((m)=>ServiceModel.fromJson(m)).toList()
  );

  ServiceState copyWith({
    List<ServiceModel>? services
  }) {
    return ServiceState(
      services: services ?? this.services,
    );
  }

}
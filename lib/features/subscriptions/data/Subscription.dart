import 'package:healthandwellness/core/utility/helper.dart';

class Subscription {
  String id;
  String name;
  String image;
  String description;
  bool isActive;
  bool isTrail;

  List<String> trainerIds;
  bool? isNewSlot; // Used for slot assigning in slot manage
  int maxBooking;

  Subscription({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.isActive,
    required this.isTrail,
    required this.maxBooking,
    required this.trainerIds,
    this.isNewSlot,
  });

  factory Subscription.fromJSON(Map<String, dynamic> data) => Subscription(
    id: parseString(data: data['id'], defaultValue: ""),
    name: parseString(data: data['name'], defaultValue: ""),
    image: parseString(data: data['image'], defaultValue: ''),
    description: parseString(data: data['description'], defaultValue: ''),
    isActive: parseBool(data: data['isActive'], defaultValue: false),
    isTrail: parseBool(data: data['isTrail'], defaultValue: false),
    maxBooking: parseInt(data: data['maxBooking'], defaultInt: 0),
    trainerIds: (data['trainerId'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
  );

  Subscription copyWith({
    String? id,
    String? name,
    String? image,
    String? description,
    bool? isActive,
    bool? isTrail,
    bool? isNewSlot,
    int? maxBooking,
    List<String>? trainerIds,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      isTrail: isTrail ?? this.isTrail,
      isNewSlot: isNewSlot ?? this.isNewSlot,
      maxBooking: maxBooking ?? this.maxBooking,
      trainerIds: trainerIds ?? this.trainerIds,
    );
  }
}

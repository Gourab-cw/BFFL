// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VoucherModel _$VoucherModelFromJson(Map<String, dynamic> json) =>
    _VoucherModel(
      id: json['id'] as String,
      suffix: json['suffix'] as String,
      prefix: json['prefix'] as String,
      branchId: json['branchId'] as String,
      paymentMethods:
          (json['paymentMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['CASH'],
      docTypeId: parseIntV2(json['docTypeId']),
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$VoucherModelToJson(_VoucherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'suffix': instance.suffix,
      'prefix': instance.prefix,
      'branchId': instance.branchId,
      'paymentMethods': instance.paymentMethods,
      'docTypeId': instance.docTypeId,
      'name': instance.name,
      'isActive': instance.isActive,
    };

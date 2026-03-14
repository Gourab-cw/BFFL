// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: parseStringV2(json['id']),
      branchId: parseStringV2(json['branchId']),
      companyId: parseStringV2(json['companyId']),
      userId: parseStringV2(json['userId']),
      ledgerId: parseStringV2(json['ledgerId']),
      ledgerName: parseStringV2(json['ledgerName']),
      subscriptionId: parseStringV2(json['subscriptionId']),
      subscriptionName: parseStringV2(json['subscriptionName']),
      billId: parseStringV2(json['billId']),
      voucherTypeId: parseStringV2(json['voucherTypeId']),
      voucherTypeName: parseStringV2(json['voucherTypeName']),
      voucherNo: parseStringV2(json['voucherNo']),
      amount: parseDoubleV2(json['amount']),
      drCr: parseStringV2(json['drCr']),
      createdAt: timestampFromJson(json['createdAt']),
      updatedAt: timestampFromJson(json['updatedAt']),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'companyId': instance.companyId,
      'userId': instance.userId,
      'ledgerId': instance.ledgerId,
      'ledgerName': instance.ledgerName,
      'subscriptionId': instance.subscriptionId,
      'subscriptionName': instance.subscriptionName,
      'billId': instance.billId,
      'voucherTypeId': instance.voucherTypeId,
      'voucherTypeName': instance.voucherTypeName,
      'voucherNo': instance.voucherNo,
      'amount': instance.amount,
      'drCr': instance.drCr,
      'createdAt': timestampToJson(instance.createdAt),
      'updatedAt': timestampToJson(instance.updatedAt),
      'isActive': instance.isActive,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) =>
    _PaymentModel(
      id: parseStringV2(json['id']),
      branchId: parseStringV2(json['branchId']),
      accountantId: parseStringV2(json['accountantId']),
      companyId: parseStringV2(json['companyId']),
      createdAt: timestampFromJson(json['createdAt']),
      grossAmount: parseDoubleV2(json['grossAmount']),
      gstAmount: parseDoubleV2(json['gstAmount']),
      gstPer: parseDoubleV2(json['gstPer']),
      netAmount: parseDoubleV2(json['netAmount']),
      paidAmount: parseDoubleV2(json['paidAmount']),
      paymentModeId: parseStringV2(json['paymentModeId']),
      paymentModeName: parseStringV2(json['paymentModeName']),
      remarks: parseStringV2(json['remarks']),
      serviceId: parseStringV2(json['serviceId']),
      serviceName: parseStringV2(json['serviceName']),
      subscriptionId: parseStringV2(json['subscriptionId']),
      subscriptionName: parseStringV2(json['subscriptionName']),
      txnValue: parseStringV2(json['txnValue']),
      userId: parseStringV2(json['userId']),
      userName: parseStringV2(json['userName']),
      voucherAmount: parseDoubleV2(json['voucherAmount']),
      voucherId: parseStringV2(json['voucherId']),
      voucherNumber: parseStringV2(json['voucherNumber']),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$PaymentModelToJson(_PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branchId': instance.branchId,
      'accountantId': instance.accountantId,
      'companyId': instance.companyId,
      'createdAt': timestampToJson(instance.createdAt),
      'grossAmount': instance.grossAmount,
      'gstAmount': instance.gstAmount,
      'gstPer': instance.gstPer,
      'netAmount': instance.netAmount,
      'paidAmount': instance.paidAmount,
      'paymentModeId': instance.paymentModeId,
      'paymentModeName': instance.paymentModeName,
      'remarks': instance.remarks,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'subscriptionId': instance.subscriptionId,
      'subscriptionName': instance.subscriptionName,
      'txnValue': instance.txnValue,
      'userId': instance.userId,
      'userName': instance.userName,
      'voucherAmount': instance.voucherAmount,
      'voucherId': instance.voucherId,
      'voucherNumber': instance.voucherNumber,
      'isActive': instance.isActive,
    };

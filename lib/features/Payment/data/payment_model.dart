import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utility/helper.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@freezed
abstract class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    @JsonKey(name: 'id', fromJson: parseStringV2) required String id,
    @JsonKey(name: 'branchId', fromJson: parseStringV2) required String branchId,
    @JsonKey(name: 'accountantId', fromJson: parseStringV2) required String accountantId,
    @JsonKey(name: 'companyId', fromJson: parseStringV2) required String companyId,
    @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson) required Timestamp createdAt,
    @JsonKey(name: 'grossAmount', fromJson: parseDoubleV2) grossAmount,
    @JsonKey(name: 'gstAmount', fromJson: parseDoubleV2) gstAmount,
    @JsonKey(name: 'gstPer', fromJson: parseDoubleV2) gstPer,
    @JsonKey(name: 'netAmount', fromJson: parseDoubleV2) netAmount,
    @JsonKey(name: 'paidAmount', fromJson: parseDoubleV2) paidAmount,
    @JsonKey(name: 'paymentModeId', fromJson: parseStringV2) required String paymentModeId,
    @JsonKey(name: 'paymentModeName', fromJson: parseStringV2) required String paymentModeName,
    @JsonKey(name: 'remarks', fromJson: parseStringV2) required String remarks,
    @JsonKey(name: 'serviceId', fromJson: parseStringV2) required String serviceId,
    @JsonKey(name: 'serviceName', fromJson: parseStringV2) required String serviceName,
    @JsonKey(name: 'subscriptionId', fromJson: parseStringV2) required String subscriptionId,
    @JsonKey(name: 'subscriptionName', fromJson: parseStringV2) required String subscriptionName,
    @JsonKey(name: 'txnValue', fromJson: parseStringV2) required String txnValue,
    @JsonKey(name: 'userId', fromJson: parseStringV2) required String userId,
    @JsonKey(name: 'userName', fromJson: parseStringV2) required String userName,
    @JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2) required double voucherAmount,
    @JsonKey(name: 'voucherId', fromJson: parseStringV2) required String voucherId,
    @JsonKey(name: 'voucherNumber', fromJson: parseStringV2) required String voucherNumber,
    @Default(true) bool isActive,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
}

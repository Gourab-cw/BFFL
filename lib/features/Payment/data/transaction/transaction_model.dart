import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utility/helper.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(name: 'id', fromJson: parseStringV2) required String id,

    @JsonKey(name: 'branchId', fromJson: parseStringV2) required String branchId,

    @JsonKey(name: 'companyId', fromJson: parseStringV2) required String companyId,

    @JsonKey(name: 'userId', fromJson: parseStringV2) required String userId,

    @JsonKey(name: 'ledgerId', fromJson: parseStringV2) required String ledgerId,

    @JsonKey(name: 'ledgerName', fromJson: parseStringV2) required String ledgerName,

    @JsonKey(name: 'subscriptionId', fromJson: parseStringV2) String? subscriptionId,

    @JsonKey(name: 'subscriptionName', fromJson: parseStringV2) String? subscriptionName,

    @JsonKey(name: 'billId', fromJson: parseStringV2) String? billId,

    @JsonKey(name: 'voucherTypeId', fromJson: parseStringV2) required String voucherTypeId,

    @JsonKey(name: 'voucherTypeName', fromJson: parseStringV2) required String voucherTypeName,

    @JsonKey(name: 'voucherNo', fromJson: parseStringV2) required String voucherNo,

    @JsonKey(name: 'amount', fromJson: parseDoubleV2) required double amount,

    @JsonKey(name: 'drCr', fromJson: parseStringV2) required String drCr,

    @JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson) required Timestamp createdAt,

    @JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson) required Timestamp updatedAt,

    @Default(true) bool isActive,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
}

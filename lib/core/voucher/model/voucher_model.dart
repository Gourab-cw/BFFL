import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utility/helper.dart';

part 'voucher_model.freezed.dart';
part 'voucher_model.g.dart';

@freezed
abstract class VoucherModel with _$VoucherModel {
  const factory VoucherModel({
    required String id,
    required String suffix,
    required String prefix,
    required String branchId,
    @Default(['CASH']) List<String> paymentMethods,
    @JsonKey(fromJson: parseIntV2) required int docTypeId,
    required String name,
    @Default(true) bool isActive,
    @Default(false) bool withDiscount,
  }) = _VoucherModel;

  factory VoucherModel.fromJson(Map<String, dynamic> json) => _$VoucherModelFromJson(json);
}

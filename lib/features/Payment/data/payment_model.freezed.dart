// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentModel {

@JsonKey(name: 'id', fromJson: parseStringV2) String get id;@JsonKey(name: 'branchId', fromJson: parseStringV2) String get branchId;@JsonKey(name: 'accountantId', fromJson: parseStringV2) String get accountantId;@JsonKey(name: 'companyId', fromJson: parseStringV2) String get companyId;@JsonKey(fromJson: timestampFromJson, toJson: timestampToJson) Timestamp get createdAt;@JsonKey(name: 'grossAmount', fromJson: parseDoubleV2) dynamic get grossAmount;@JsonKey(name: 'gstAmount', fromJson: parseDoubleV2) dynamic get gstAmount;@JsonKey(name: 'gstPer', fromJson: parseDoubleV2) dynamic get gstPer;@JsonKey(name: 'netAmount', fromJson: parseDoubleV2) dynamic get netAmount;@JsonKey(name: 'paidAmount', fromJson: parseDoubleV2) dynamic get paidAmount;@JsonKey(name: 'paymentModeId', fromJson: parseStringV2) String get paymentModeId;@JsonKey(name: 'paymentModeName', fromJson: parseStringV2) String get paymentModeName;@JsonKey(name: 'remarks', fromJson: parseStringV2) String get remarks;@JsonKey(name: 'serviceId', fromJson: parseStringV2) String get serviceId;@JsonKey(name: 'serviceName', fromJson: parseStringV2) String get serviceName;@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) String get subscriptionId;@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) String get subscriptionName;@JsonKey(name: 'txnValue', fromJson: parseStringV2) String get txnValue;@JsonKey(name: 'userId', fromJson: parseStringV2) String get userId;@JsonKey(name: 'userName', fromJson: parseStringV2) String get userName;@JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2) double get voucherAmount;@JsonKey(name: 'voucherId', fromJson: parseStringV2) String get voucherId;@JsonKey(name: 'voucherNumber', fromJson: parseStringV2) String get voucherNumber; bool get isActive;
/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<PaymentModel> get copyWith => _$PaymentModelCopyWithImpl<PaymentModel>(this as PaymentModel, _$identity);

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.accountantId, accountantId) || other.accountantId == accountantId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.grossAmount, grossAmount)&&const DeepCollectionEquality().equals(other.gstAmount, gstAmount)&&const DeepCollectionEquality().equals(other.gstPer, gstPer)&&const DeepCollectionEquality().equals(other.netAmount, netAmount)&&const DeepCollectionEquality().equals(other.paidAmount, paidAmount)&&(identical(other.paymentModeId, paymentModeId) || other.paymentModeId == paymentModeId)&&(identical(other.paymentModeName, paymentModeName) || other.paymentModeName == paymentModeName)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.subscriptionName, subscriptionName) || other.subscriptionName == subscriptionName)&&(identical(other.txnValue, txnValue) || other.txnValue == txnValue)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.voucherAmount, voucherAmount) || other.voucherAmount == voucherAmount)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.voucherNumber, voucherNumber) || other.voucherNumber == voucherNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,branchId,accountantId,companyId,createdAt,const DeepCollectionEquality().hash(grossAmount),const DeepCollectionEquality().hash(gstAmount),const DeepCollectionEquality().hash(gstPer),const DeepCollectionEquality().hash(netAmount),const DeepCollectionEquality().hash(paidAmount),paymentModeId,paymentModeName,remarks,serviceId,serviceName,subscriptionId,subscriptionName,txnValue,userId,userName,voucherAmount,voucherId,voucherNumber,isActive]);

@override
String toString() {
  return 'PaymentModel(id: $id, branchId: $branchId, accountantId: $accountantId, companyId: $companyId, createdAt: $createdAt, grossAmount: $grossAmount, gstAmount: $gstAmount, gstPer: $gstPer, netAmount: $netAmount, paidAmount: $paidAmount, paymentModeId: $paymentModeId, paymentModeName: $paymentModeName, remarks: $remarks, serviceId: $serviceId, serviceName: $serviceName, subscriptionId: $subscriptionId, subscriptionName: $subscriptionName, txnValue: $txnValue, userId: $userId, userName: $userName, voucherAmount: $voucherAmount, voucherId: $voucherId, voucherNumber: $voucherNumber, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $PaymentModelCopyWith<$Res>  {
  factory $PaymentModelCopyWith(PaymentModel value, $Res Function(PaymentModel) _then) = _$PaymentModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', fromJson: parseStringV2) String id,@JsonKey(name: 'branchId', fromJson: parseStringV2) String branchId,@JsonKey(name: 'accountantId', fromJson: parseStringV2) String accountantId,@JsonKey(name: 'companyId', fromJson: parseStringV2) String companyId,@JsonKey(fromJson: timestampFromJson, toJson: timestampToJson) Timestamp createdAt,@JsonKey(name: 'grossAmount', fromJson: parseDoubleV2) dynamic grossAmount,@JsonKey(name: 'gstAmount', fromJson: parseDoubleV2) dynamic gstAmount,@JsonKey(name: 'gstPer', fromJson: parseDoubleV2) dynamic gstPer,@JsonKey(name: 'netAmount', fromJson: parseDoubleV2) dynamic netAmount,@JsonKey(name: 'paidAmount', fromJson: parseDoubleV2) dynamic paidAmount,@JsonKey(name: 'paymentModeId', fromJson: parseStringV2) String paymentModeId,@JsonKey(name: 'paymentModeName', fromJson: parseStringV2) String paymentModeName,@JsonKey(name: 'remarks', fromJson: parseStringV2) String remarks,@JsonKey(name: 'serviceId', fromJson: parseStringV2) String serviceId,@JsonKey(name: 'serviceName', fromJson: parseStringV2) String serviceName,@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) String subscriptionId,@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) String subscriptionName,@JsonKey(name: 'txnValue', fromJson: parseStringV2) String txnValue,@JsonKey(name: 'userId', fromJson: parseStringV2) String userId,@JsonKey(name: 'userName', fromJson: parseStringV2) String userName,@JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2) double voucherAmount,@JsonKey(name: 'voucherId', fromJson: parseStringV2) String voucherId,@JsonKey(name: 'voucherNumber', fromJson: parseStringV2) String voucherNumber, bool isActive
});




}
/// @nodoc
class _$PaymentModelCopyWithImpl<$Res>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._self, this._then);

  final PaymentModel _self;
  final $Res Function(PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? accountantId = null,Object? companyId = null,Object? createdAt = null,Object? grossAmount = freezed,Object? gstAmount = freezed,Object? gstPer = freezed,Object? netAmount = freezed,Object? paidAmount = freezed,Object? paymentModeId = null,Object? paymentModeName = null,Object? remarks = null,Object? serviceId = null,Object? serviceName = null,Object? subscriptionId = null,Object? subscriptionName = null,Object? txnValue = null,Object? userId = null,Object? userName = null,Object? voucherAmount = null,Object? voucherId = null,Object? voucherNumber = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,accountantId: null == accountantId ? _self.accountantId : accountantId // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,grossAmount: freezed == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as dynamic,gstAmount: freezed == gstAmount ? _self.gstAmount : gstAmount // ignore: cast_nullable_to_non_nullable
as dynamic,gstPer: freezed == gstPer ? _self.gstPer : gstPer // ignore: cast_nullable_to_non_nullable
as dynamic,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as dynamic,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as dynamic,paymentModeId: null == paymentModeId ? _self.paymentModeId : paymentModeId // ignore: cast_nullable_to_non_nullable
as String,paymentModeName: null == paymentModeName ? _self.paymentModeName : paymentModeName // ignore: cast_nullable_to_non_nullable
as String,remarks: null == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,subscriptionName: null == subscriptionName ? _self.subscriptionName : subscriptionName // ignore: cast_nullable_to_non_nullable
as String,txnValue: null == txnValue ? _self.txnValue : txnValue // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,voucherAmount: null == voucherAmount ? _self.voucherAmount : voucherAmount // ignore: cast_nullable_to_non_nullable
as double,voucherId: null == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String,voucherNumber: null == voucherNumber ? _self.voucherNumber : voucherNumber // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentModel].
extension PaymentModelPatterns on PaymentModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', fromJson: parseStringV2)  String id, @JsonKey(name: 'branchId', fromJson: parseStringV2)  String branchId, @JsonKey(name: 'accountantId', fromJson: parseStringV2)  String accountantId, @JsonKey(name: 'companyId', fromJson: parseStringV2)  String companyId, @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp createdAt, @JsonKey(name: 'grossAmount', fromJson: parseDoubleV2)  dynamic grossAmount, @JsonKey(name: 'gstAmount', fromJson: parseDoubleV2)  dynamic gstAmount, @JsonKey(name: 'gstPer', fromJson: parseDoubleV2)  dynamic gstPer, @JsonKey(name: 'netAmount', fromJson: parseDoubleV2)  dynamic netAmount, @JsonKey(name: 'paidAmount', fromJson: parseDoubleV2)  dynamic paidAmount, @JsonKey(name: 'paymentModeId', fromJson: parseStringV2)  String paymentModeId, @JsonKey(name: 'paymentModeName', fromJson: parseStringV2)  String paymentModeName, @JsonKey(name: 'remarks', fromJson: parseStringV2)  String remarks, @JsonKey(name: 'serviceId', fromJson: parseStringV2)  String serviceId, @JsonKey(name: 'serviceName', fromJson: parseStringV2)  String serviceName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2)  String subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2)  String subscriptionName, @JsonKey(name: 'txnValue', fromJson: parseStringV2)  String txnValue, @JsonKey(name: 'userId', fromJson: parseStringV2)  String userId, @JsonKey(name: 'userName', fromJson: parseStringV2)  String userName, @JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2)  double voucherAmount, @JsonKey(name: 'voucherId', fromJson: parseStringV2)  String voucherId, @JsonKey(name: 'voucherNumber', fromJson: parseStringV2)  String voucherNumber,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.id,_that.branchId,_that.accountantId,_that.companyId,_that.createdAt,_that.grossAmount,_that.gstAmount,_that.gstPer,_that.netAmount,_that.paidAmount,_that.paymentModeId,_that.paymentModeName,_that.remarks,_that.serviceId,_that.serviceName,_that.subscriptionId,_that.subscriptionName,_that.txnValue,_that.userId,_that.userName,_that.voucherAmount,_that.voucherId,_that.voucherNumber,_that.isActive);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', fromJson: parseStringV2)  String id, @JsonKey(name: 'branchId', fromJson: parseStringV2)  String branchId, @JsonKey(name: 'accountantId', fromJson: parseStringV2)  String accountantId, @JsonKey(name: 'companyId', fromJson: parseStringV2)  String companyId, @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp createdAt, @JsonKey(name: 'grossAmount', fromJson: parseDoubleV2)  dynamic grossAmount, @JsonKey(name: 'gstAmount', fromJson: parseDoubleV2)  dynamic gstAmount, @JsonKey(name: 'gstPer', fromJson: parseDoubleV2)  dynamic gstPer, @JsonKey(name: 'netAmount', fromJson: parseDoubleV2)  dynamic netAmount, @JsonKey(name: 'paidAmount', fromJson: parseDoubleV2)  dynamic paidAmount, @JsonKey(name: 'paymentModeId', fromJson: parseStringV2)  String paymentModeId, @JsonKey(name: 'paymentModeName', fromJson: parseStringV2)  String paymentModeName, @JsonKey(name: 'remarks', fromJson: parseStringV2)  String remarks, @JsonKey(name: 'serviceId', fromJson: parseStringV2)  String serviceId, @JsonKey(name: 'serviceName', fromJson: parseStringV2)  String serviceName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2)  String subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2)  String subscriptionName, @JsonKey(name: 'txnValue', fromJson: parseStringV2)  String txnValue, @JsonKey(name: 'userId', fromJson: parseStringV2)  String userId, @JsonKey(name: 'userName', fromJson: parseStringV2)  String userName, @JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2)  double voucherAmount, @JsonKey(name: 'voucherId', fromJson: parseStringV2)  String voucherId, @JsonKey(name: 'voucherNumber', fromJson: parseStringV2)  String voucherNumber,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _PaymentModel():
return $default(_that.id,_that.branchId,_that.accountantId,_that.companyId,_that.createdAt,_that.grossAmount,_that.gstAmount,_that.gstPer,_that.netAmount,_that.paidAmount,_that.paymentModeId,_that.paymentModeName,_that.remarks,_that.serviceId,_that.serviceName,_that.subscriptionId,_that.subscriptionName,_that.txnValue,_that.userId,_that.userName,_that.voucherAmount,_that.voucherId,_that.voucherNumber,_that.isActive);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', fromJson: parseStringV2)  String id, @JsonKey(name: 'branchId', fromJson: parseStringV2)  String branchId, @JsonKey(name: 'accountantId', fromJson: parseStringV2)  String accountantId, @JsonKey(name: 'companyId', fromJson: parseStringV2)  String companyId, @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp createdAt, @JsonKey(name: 'grossAmount', fromJson: parseDoubleV2)  dynamic grossAmount, @JsonKey(name: 'gstAmount', fromJson: parseDoubleV2)  dynamic gstAmount, @JsonKey(name: 'gstPer', fromJson: parseDoubleV2)  dynamic gstPer, @JsonKey(name: 'netAmount', fromJson: parseDoubleV2)  dynamic netAmount, @JsonKey(name: 'paidAmount', fromJson: parseDoubleV2)  dynamic paidAmount, @JsonKey(name: 'paymentModeId', fromJson: parseStringV2)  String paymentModeId, @JsonKey(name: 'paymentModeName', fromJson: parseStringV2)  String paymentModeName, @JsonKey(name: 'remarks', fromJson: parseStringV2)  String remarks, @JsonKey(name: 'serviceId', fromJson: parseStringV2)  String serviceId, @JsonKey(name: 'serviceName', fromJson: parseStringV2)  String serviceName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2)  String subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2)  String subscriptionName, @JsonKey(name: 'txnValue', fromJson: parseStringV2)  String txnValue, @JsonKey(name: 'userId', fromJson: parseStringV2)  String userId, @JsonKey(name: 'userName', fromJson: parseStringV2)  String userName, @JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2)  double voucherAmount, @JsonKey(name: 'voucherId', fromJson: parseStringV2)  String voucherId, @JsonKey(name: 'voucherNumber', fromJson: parseStringV2)  String voucherNumber,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.id,_that.branchId,_that.accountantId,_that.companyId,_that.createdAt,_that.grossAmount,_that.gstAmount,_that.gstPer,_that.netAmount,_that.paidAmount,_that.paymentModeId,_that.paymentModeName,_that.remarks,_that.serviceId,_that.serviceName,_that.subscriptionId,_that.subscriptionName,_that.txnValue,_that.userId,_that.userName,_that.voucherAmount,_that.voucherId,_that.voucherNumber,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentModel implements PaymentModel {
  const _PaymentModel({@JsonKey(name: 'id', fromJson: parseStringV2) required this.id, @JsonKey(name: 'branchId', fromJson: parseStringV2) required this.branchId, @JsonKey(name: 'accountantId', fromJson: parseStringV2) required this.accountantId, @JsonKey(name: 'companyId', fromJson: parseStringV2) required this.companyId, @JsonKey(fromJson: timestampFromJson, toJson: timestampToJson) required this.createdAt, @JsonKey(name: 'grossAmount', fromJson: parseDoubleV2) this.grossAmount, @JsonKey(name: 'gstAmount', fromJson: parseDoubleV2) this.gstAmount, @JsonKey(name: 'gstPer', fromJson: parseDoubleV2) this.gstPer, @JsonKey(name: 'netAmount', fromJson: parseDoubleV2) this.netAmount, @JsonKey(name: 'paidAmount', fromJson: parseDoubleV2) this.paidAmount, @JsonKey(name: 'paymentModeId', fromJson: parseStringV2) required this.paymentModeId, @JsonKey(name: 'paymentModeName', fromJson: parseStringV2) required this.paymentModeName, @JsonKey(name: 'remarks', fromJson: parseStringV2) required this.remarks, @JsonKey(name: 'serviceId', fromJson: parseStringV2) required this.serviceId, @JsonKey(name: 'serviceName', fromJson: parseStringV2) required this.serviceName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2) required this.subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2) required this.subscriptionName, @JsonKey(name: 'txnValue', fromJson: parseStringV2) required this.txnValue, @JsonKey(name: 'userId', fromJson: parseStringV2) required this.userId, @JsonKey(name: 'userName', fromJson: parseStringV2) required this.userName, @JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2) required this.voucherAmount, @JsonKey(name: 'voucherId', fromJson: parseStringV2) required this.voucherId, @JsonKey(name: 'voucherNumber', fromJson: parseStringV2) required this.voucherNumber, this.isActive = true});
  factory _PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

@override@JsonKey(name: 'id', fromJson: parseStringV2) final  String id;
@override@JsonKey(name: 'branchId', fromJson: parseStringV2) final  String branchId;
@override@JsonKey(name: 'accountantId', fromJson: parseStringV2) final  String accountantId;
@override@JsonKey(name: 'companyId', fromJson: parseStringV2) final  String companyId;
@override@JsonKey(fromJson: timestampFromJson, toJson: timestampToJson) final  Timestamp createdAt;
@override@JsonKey(name: 'grossAmount', fromJson: parseDoubleV2) final  dynamic grossAmount;
@override@JsonKey(name: 'gstAmount', fromJson: parseDoubleV2) final  dynamic gstAmount;
@override@JsonKey(name: 'gstPer', fromJson: parseDoubleV2) final  dynamic gstPer;
@override@JsonKey(name: 'netAmount', fromJson: parseDoubleV2) final  dynamic netAmount;
@override@JsonKey(name: 'paidAmount', fromJson: parseDoubleV2) final  dynamic paidAmount;
@override@JsonKey(name: 'paymentModeId', fromJson: parseStringV2) final  String paymentModeId;
@override@JsonKey(name: 'paymentModeName', fromJson: parseStringV2) final  String paymentModeName;
@override@JsonKey(name: 'remarks', fromJson: parseStringV2) final  String remarks;
@override@JsonKey(name: 'serviceId', fromJson: parseStringV2) final  String serviceId;
@override@JsonKey(name: 'serviceName', fromJson: parseStringV2) final  String serviceName;
@override@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) final  String subscriptionId;
@override@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) final  String subscriptionName;
@override@JsonKey(name: 'txnValue', fromJson: parseStringV2) final  String txnValue;
@override@JsonKey(name: 'userId', fromJson: parseStringV2) final  String userId;
@override@JsonKey(name: 'userName', fromJson: parseStringV2) final  String userName;
@override@JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2) final  double voucherAmount;
@override@JsonKey(name: 'voucherId', fromJson: parseStringV2) final  String voucherId;
@override@JsonKey(name: 'voucherNumber', fromJson: parseStringV2) final  String voucherNumber;
@override@JsonKey() final  bool isActive;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentModelCopyWith<_PaymentModel> get copyWith => __$PaymentModelCopyWithImpl<_PaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.accountantId, accountantId) || other.accountantId == accountantId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.grossAmount, grossAmount)&&const DeepCollectionEquality().equals(other.gstAmount, gstAmount)&&const DeepCollectionEquality().equals(other.gstPer, gstPer)&&const DeepCollectionEquality().equals(other.netAmount, netAmount)&&const DeepCollectionEquality().equals(other.paidAmount, paidAmount)&&(identical(other.paymentModeId, paymentModeId) || other.paymentModeId == paymentModeId)&&(identical(other.paymentModeName, paymentModeName) || other.paymentModeName == paymentModeName)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.serviceId, serviceId) || other.serviceId == serviceId)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.subscriptionName, subscriptionName) || other.subscriptionName == subscriptionName)&&(identical(other.txnValue, txnValue) || other.txnValue == txnValue)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.voucherAmount, voucherAmount) || other.voucherAmount == voucherAmount)&&(identical(other.voucherId, voucherId) || other.voucherId == voucherId)&&(identical(other.voucherNumber, voucherNumber) || other.voucherNumber == voucherNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,branchId,accountantId,companyId,createdAt,const DeepCollectionEquality().hash(grossAmount),const DeepCollectionEquality().hash(gstAmount),const DeepCollectionEquality().hash(gstPer),const DeepCollectionEquality().hash(netAmount),const DeepCollectionEquality().hash(paidAmount),paymentModeId,paymentModeName,remarks,serviceId,serviceName,subscriptionId,subscriptionName,txnValue,userId,userName,voucherAmount,voucherId,voucherNumber,isActive]);

@override
String toString() {
  return 'PaymentModel(id: $id, branchId: $branchId, accountantId: $accountantId, companyId: $companyId, createdAt: $createdAt, grossAmount: $grossAmount, gstAmount: $gstAmount, gstPer: $gstPer, netAmount: $netAmount, paidAmount: $paidAmount, paymentModeId: $paymentModeId, paymentModeName: $paymentModeName, remarks: $remarks, serviceId: $serviceId, serviceName: $serviceName, subscriptionId: $subscriptionId, subscriptionName: $subscriptionName, txnValue: $txnValue, userId: $userId, userName: $userName, voucherAmount: $voucherAmount, voucherId: $voucherId, voucherNumber: $voucherNumber, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$PaymentModelCopyWith<$Res> implements $PaymentModelCopyWith<$Res> {
  factory _$PaymentModelCopyWith(_PaymentModel value, $Res Function(_PaymentModel) _then) = __$PaymentModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', fromJson: parseStringV2) String id,@JsonKey(name: 'branchId', fromJson: parseStringV2) String branchId,@JsonKey(name: 'accountantId', fromJson: parseStringV2) String accountantId,@JsonKey(name: 'companyId', fromJson: parseStringV2) String companyId,@JsonKey(fromJson: timestampFromJson, toJson: timestampToJson) Timestamp createdAt,@JsonKey(name: 'grossAmount', fromJson: parseDoubleV2) dynamic grossAmount,@JsonKey(name: 'gstAmount', fromJson: parseDoubleV2) dynamic gstAmount,@JsonKey(name: 'gstPer', fromJson: parseDoubleV2) dynamic gstPer,@JsonKey(name: 'netAmount', fromJson: parseDoubleV2) dynamic netAmount,@JsonKey(name: 'paidAmount', fromJson: parseDoubleV2) dynamic paidAmount,@JsonKey(name: 'paymentModeId', fromJson: parseStringV2) String paymentModeId,@JsonKey(name: 'paymentModeName', fromJson: parseStringV2) String paymentModeName,@JsonKey(name: 'remarks', fromJson: parseStringV2) String remarks,@JsonKey(name: 'serviceId', fromJson: parseStringV2) String serviceId,@JsonKey(name: 'serviceName', fromJson: parseStringV2) String serviceName,@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) String subscriptionId,@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) String subscriptionName,@JsonKey(name: 'txnValue', fromJson: parseStringV2) String txnValue,@JsonKey(name: 'userId', fromJson: parseStringV2) String userId,@JsonKey(name: 'userName', fromJson: parseStringV2) String userName,@JsonKey(name: 'voucherAmount', fromJson: parseDoubleV2) double voucherAmount,@JsonKey(name: 'voucherId', fromJson: parseStringV2) String voucherId,@JsonKey(name: 'voucherNumber', fromJson: parseStringV2) String voucherNumber, bool isActive
});




}
/// @nodoc
class __$PaymentModelCopyWithImpl<$Res>
    implements _$PaymentModelCopyWith<$Res> {
  __$PaymentModelCopyWithImpl(this._self, this._then);

  final _PaymentModel _self;
  final $Res Function(_PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? accountantId = null,Object? companyId = null,Object? createdAt = null,Object? grossAmount = freezed,Object? gstAmount = freezed,Object? gstPer = freezed,Object? netAmount = freezed,Object? paidAmount = freezed,Object? paymentModeId = null,Object? paymentModeName = null,Object? remarks = null,Object? serviceId = null,Object? serviceName = null,Object? subscriptionId = null,Object? subscriptionName = null,Object? txnValue = null,Object? userId = null,Object? userName = null,Object? voucherAmount = null,Object? voucherId = null,Object? voucherNumber = null,Object? isActive = null,}) {
  return _then(_PaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,accountantId: null == accountantId ? _self.accountantId : accountantId // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,grossAmount: freezed == grossAmount ? _self.grossAmount : grossAmount // ignore: cast_nullable_to_non_nullable
as dynamic,gstAmount: freezed == gstAmount ? _self.gstAmount : gstAmount // ignore: cast_nullable_to_non_nullable
as dynamic,gstPer: freezed == gstPer ? _self.gstPer : gstPer // ignore: cast_nullable_to_non_nullable
as dynamic,netAmount: freezed == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as dynamic,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as dynamic,paymentModeId: null == paymentModeId ? _self.paymentModeId : paymentModeId // ignore: cast_nullable_to_non_nullable
as String,paymentModeName: null == paymentModeName ? _self.paymentModeName : paymentModeName // ignore: cast_nullable_to_non_nullable
as String,remarks: null == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String,serviceId: null == serviceId ? _self.serviceId : serviceId // ignore: cast_nullable_to_non_nullable
as String,serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,subscriptionId: null == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String,subscriptionName: null == subscriptionName ? _self.subscriptionName : subscriptionName // ignore: cast_nullable_to_non_nullable
as String,txnValue: null == txnValue ? _self.txnValue : txnValue // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,voucherAmount: null == voucherAmount ? _self.voucherAmount : voucherAmount // ignore: cast_nullable_to_non_nullable
as double,voucherId: null == voucherId ? _self.voucherId : voucherId // ignore: cast_nullable_to_non_nullable
as String,voucherNumber: null == voucherNumber ? _self.voucherNumber : voucherNumber // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

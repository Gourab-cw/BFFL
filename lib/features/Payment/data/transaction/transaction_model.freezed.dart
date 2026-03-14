// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

@JsonKey(name: 'id', fromJson: parseStringV2) String get id;@JsonKey(name: 'branchId', fromJson: parseStringV2) String get branchId;@JsonKey(name: 'companyId', fromJson: parseStringV2) String get companyId;@JsonKey(name: 'userId', fromJson: parseStringV2) String get userId;@JsonKey(name: 'ledgerId', fromJson: parseStringV2) String get ledgerId;@JsonKey(name: 'ledgerName', fromJson: parseStringV2) String get ledgerName;@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) String? get subscriptionId;@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) String? get subscriptionName;@JsonKey(name: 'billId', fromJson: parseStringV2) String? get billId;@JsonKey(name: 'voucherTypeId', fromJson: parseStringV2) String get voucherTypeId;@JsonKey(name: 'voucherTypeName', fromJson: parseStringV2) String get voucherTypeName;@JsonKey(name: 'voucherNo', fromJson: parseStringV2) String get voucherNo;@JsonKey(name: 'amount', fromJson: parseDoubleV2) double get amount;@JsonKey(name: 'drCr', fromJson: parseStringV2) String get drCr;@JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson) Timestamp get createdAt;@JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson) Timestamp get updatedAt; bool get isActive;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.ledgerId, ledgerId) || other.ledgerId == ledgerId)&&(identical(other.ledgerName, ledgerName) || other.ledgerName == ledgerName)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.subscriptionName, subscriptionName) || other.subscriptionName == subscriptionName)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.voucherTypeId, voucherTypeId) || other.voucherTypeId == voucherTypeId)&&(identical(other.voucherTypeName, voucherTypeName) || other.voucherTypeName == voucherTypeName)&&(identical(other.voucherNo, voucherNo) || other.voucherNo == voucherNo)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.drCr, drCr) || other.drCr == drCr)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,companyId,userId,ledgerId,ledgerName,subscriptionId,subscriptionName,billId,voucherTypeId,voucherTypeName,voucherNo,amount,drCr,createdAt,updatedAt,isActive);

@override
String toString() {
  return 'TransactionModel(id: $id, branchId: $branchId, companyId: $companyId, userId: $userId, ledgerId: $ledgerId, ledgerName: $ledgerName, subscriptionId: $subscriptionId, subscriptionName: $subscriptionName, billId: $billId, voucherTypeId: $voucherTypeId, voucherTypeName: $voucherTypeName, voucherNo: $voucherNo, amount: $amount, drCr: $drCr, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', fromJson: parseStringV2) String id,@JsonKey(name: 'branchId', fromJson: parseStringV2) String branchId,@JsonKey(name: 'companyId', fromJson: parseStringV2) String companyId,@JsonKey(name: 'userId', fromJson: parseStringV2) String userId,@JsonKey(name: 'ledgerId', fromJson: parseStringV2) String ledgerId,@JsonKey(name: 'ledgerName', fromJson: parseStringV2) String ledgerName,@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) String? subscriptionId,@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) String? subscriptionName,@JsonKey(name: 'billId', fromJson: parseStringV2) String? billId,@JsonKey(name: 'voucherTypeId', fromJson: parseStringV2) String voucherTypeId,@JsonKey(name: 'voucherTypeName', fromJson: parseStringV2) String voucherTypeName,@JsonKey(name: 'voucherNo', fromJson: parseStringV2) String voucherNo,@JsonKey(name: 'amount', fromJson: parseDoubleV2) double amount,@JsonKey(name: 'drCr', fromJson: parseStringV2) String drCr,@JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson) Timestamp createdAt,@JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson) Timestamp updatedAt, bool isActive
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branchId = null,Object? companyId = null,Object? userId = null,Object? ledgerId = null,Object? ledgerName = null,Object? subscriptionId = freezed,Object? subscriptionName = freezed,Object? billId = freezed,Object? voucherTypeId = null,Object? voucherTypeName = null,Object? voucherNo = null,Object? amount = null,Object? drCr = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,ledgerId: null == ledgerId ? _self.ledgerId : ledgerId // ignore: cast_nullable_to_non_nullable
as String,ledgerName: null == ledgerName ? _self.ledgerName : ledgerName // ignore: cast_nullable_to_non_nullable
as String,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,subscriptionName: freezed == subscriptionName ? _self.subscriptionName : subscriptionName // ignore: cast_nullable_to_non_nullable
as String?,billId: freezed == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String?,voucherTypeId: null == voucherTypeId ? _self.voucherTypeId : voucherTypeId // ignore: cast_nullable_to_non_nullable
as String,voucherTypeName: null == voucherTypeName ? _self.voucherTypeName : voucherTypeName // ignore: cast_nullable_to_non_nullable
as String,voucherNo: null == voucherNo ? _self.voucherNo : voucherNo // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,drCr: null == drCr ? _self.drCr : drCr // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', fromJson: parseStringV2)  String id, @JsonKey(name: 'branchId', fromJson: parseStringV2)  String branchId, @JsonKey(name: 'companyId', fromJson: parseStringV2)  String companyId, @JsonKey(name: 'userId', fromJson: parseStringV2)  String userId, @JsonKey(name: 'ledgerId', fromJson: parseStringV2)  String ledgerId, @JsonKey(name: 'ledgerName', fromJson: parseStringV2)  String ledgerName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2)  String? subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2)  String? subscriptionName, @JsonKey(name: 'billId', fromJson: parseStringV2)  String? billId, @JsonKey(name: 'voucherTypeId', fromJson: parseStringV2)  String voucherTypeId, @JsonKey(name: 'voucherTypeName', fromJson: parseStringV2)  String voucherTypeName, @JsonKey(name: 'voucherNo', fromJson: parseStringV2)  String voucherNo, @JsonKey(name: 'amount', fromJson: parseDoubleV2)  double amount, @JsonKey(name: 'drCr', fromJson: parseStringV2)  String drCr, @JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp createdAt, @JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp updatedAt,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.branchId,_that.companyId,_that.userId,_that.ledgerId,_that.ledgerName,_that.subscriptionId,_that.subscriptionName,_that.billId,_that.voucherTypeId,_that.voucherTypeName,_that.voucherNo,_that.amount,_that.drCr,_that.createdAt,_that.updatedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', fromJson: parseStringV2)  String id, @JsonKey(name: 'branchId', fromJson: parseStringV2)  String branchId, @JsonKey(name: 'companyId', fromJson: parseStringV2)  String companyId, @JsonKey(name: 'userId', fromJson: parseStringV2)  String userId, @JsonKey(name: 'ledgerId', fromJson: parseStringV2)  String ledgerId, @JsonKey(name: 'ledgerName', fromJson: parseStringV2)  String ledgerName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2)  String? subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2)  String? subscriptionName, @JsonKey(name: 'billId', fromJson: parseStringV2)  String? billId, @JsonKey(name: 'voucherTypeId', fromJson: parseStringV2)  String voucherTypeId, @JsonKey(name: 'voucherTypeName', fromJson: parseStringV2)  String voucherTypeName, @JsonKey(name: 'voucherNo', fromJson: parseStringV2)  String voucherNo, @JsonKey(name: 'amount', fromJson: parseDoubleV2)  double amount, @JsonKey(name: 'drCr', fromJson: parseStringV2)  String drCr, @JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp createdAt, @JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp updatedAt,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.branchId,_that.companyId,_that.userId,_that.ledgerId,_that.ledgerName,_that.subscriptionId,_that.subscriptionName,_that.billId,_that.voucherTypeId,_that.voucherTypeName,_that.voucherNo,_that.amount,_that.drCr,_that.createdAt,_that.updatedAt,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', fromJson: parseStringV2)  String id, @JsonKey(name: 'branchId', fromJson: parseStringV2)  String branchId, @JsonKey(name: 'companyId', fromJson: parseStringV2)  String companyId, @JsonKey(name: 'userId', fromJson: parseStringV2)  String userId, @JsonKey(name: 'ledgerId', fromJson: parseStringV2)  String ledgerId, @JsonKey(name: 'ledgerName', fromJson: parseStringV2)  String ledgerName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2)  String? subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2)  String? subscriptionName, @JsonKey(name: 'billId', fromJson: parseStringV2)  String? billId, @JsonKey(name: 'voucherTypeId', fromJson: parseStringV2)  String voucherTypeId, @JsonKey(name: 'voucherTypeName', fromJson: parseStringV2)  String voucherTypeName, @JsonKey(name: 'voucherNo', fromJson: parseStringV2)  String voucherNo, @JsonKey(name: 'amount', fromJson: parseDoubleV2)  double amount, @JsonKey(name: 'drCr', fromJson: parseStringV2)  String drCr, @JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp createdAt, @JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson)  Timestamp updatedAt,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.branchId,_that.companyId,_that.userId,_that.ledgerId,_that.ledgerName,_that.subscriptionId,_that.subscriptionName,_that.billId,_that.voucherTypeId,_that.voucherTypeName,_that.voucherNo,_that.amount,_that.drCr,_that.createdAt,_that.updatedAt,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel implements TransactionModel {
  const _TransactionModel({@JsonKey(name: 'id', fromJson: parseStringV2) required this.id, @JsonKey(name: 'branchId', fromJson: parseStringV2) required this.branchId, @JsonKey(name: 'companyId', fromJson: parseStringV2) required this.companyId, @JsonKey(name: 'userId', fromJson: parseStringV2) required this.userId, @JsonKey(name: 'ledgerId', fromJson: parseStringV2) required this.ledgerId, @JsonKey(name: 'ledgerName', fromJson: parseStringV2) required this.ledgerName, @JsonKey(name: 'subscriptionId', fromJson: parseStringV2) this.subscriptionId, @JsonKey(name: 'subscriptionName', fromJson: parseStringV2) this.subscriptionName, @JsonKey(name: 'billId', fromJson: parseStringV2) this.billId, @JsonKey(name: 'voucherTypeId', fromJson: parseStringV2) required this.voucherTypeId, @JsonKey(name: 'voucherTypeName', fromJson: parseStringV2) required this.voucherTypeName, @JsonKey(name: 'voucherNo', fromJson: parseStringV2) required this.voucherNo, @JsonKey(name: 'amount', fromJson: parseDoubleV2) required this.amount, @JsonKey(name: 'drCr', fromJson: parseStringV2) required this.drCr, @JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson) required this.createdAt, @JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson) required this.updatedAt, this.isActive = true});
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override@JsonKey(name: 'id', fromJson: parseStringV2) final  String id;
@override@JsonKey(name: 'branchId', fromJson: parseStringV2) final  String branchId;
@override@JsonKey(name: 'companyId', fromJson: parseStringV2) final  String companyId;
@override@JsonKey(name: 'userId', fromJson: parseStringV2) final  String userId;
@override@JsonKey(name: 'ledgerId', fromJson: parseStringV2) final  String ledgerId;
@override@JsonKey(name: 'ledgerName', fromJson: parseStringV2) final  String ledgerName;
@override@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) final  String? subscriptionId;
@override@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) final  String? subscriptionName;
@override@JsonKey(name: 'billId', fromJson: parseStringV2) final  String? billId;
@override@JsonKey(name: 'voucherTypeId', fromJson: parseStringV2) final  String voucherTypeId;
@override@JsonKey(name: 'voucherTypeName', fromJson: parseStringV2) final  String voucherTypeName;
@override@JsonKey(name: 'voucherNo', fromJson: parseStringV2) final  String voucherNo;
@override@JsonKey(name: 'amount', fromJson: parseDoubleV2) final  double amount;
@override@JsonKey(name: 'drCr', fromJson: parseStringV2) final  String drCr;
@override@JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson) final  Timestamp createdAt;
@override@JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson) final  Timestamp updatedAt;
@override@JsonKey() final  bool isActive;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.ledgerId, ledgerId) || other.ledgerId == ledgerId)&&(identical(other.ledgerName, ledgerName) || other.ledgerName == ledgerName)&&(identical(other.subscriptionId, subscriptionId) || other.subscriptionId == subscriptionId)&&(identical(other.subscriptionName, subscriptionName) || other.subscriptionName == subscriptionName)&&(identical(other.billId, billId) || other.billId == billId)&&(identical(other.voucherTypeId, voucherTypeId) || other.voucherTypeId == voucherTypeId)&&(identical(other.voucherTypeName, voucherTypeName) || other.voucherTypeName == voucherTypeName)&&(identical(other.voucherNo, voucherNo) || other.voucherNo == voucherNo)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.drCr, drCr) || other.drCr == drCr)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branchId,companyId,userId,ledgerId,ledgerName,subscriptionId,subscriptionName,billId,voucherTypeId,voucherTypeName,voucherNo,amount,drCr,createdAt,updatedAt,isActive);

@override
String toString() {
  return 'TransactionModel(id: $id, branchId: $branchId, companyId: $companyId, userId: $userId, ledgerId: $ledgerId, ledgerName: $ledgerName, subscriptionId: $subscriptionId, subscriptionName: $subscriptionName, billId: $billId, voucherTypeId: $voucherTypeId, voucherTypeName: $voucherTypeName, voucherNo: $voucherNo, amount: $amount, drCr: $drCr, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', fromJson: parseStringV2) String id,@JsonKey(name: 'branchId', fromJson: parseStringV2) String branchId,@JsonKey(name: 'companyId', fromJson: parseStringV2) String companyId,@JsonKey(name: 'userId', fromJson: parseStringV2) String userId,@JsonKey(name: 'ledgerId', fromJson: parseStringV2) String ledgerId,@JsonKey(name: 'ledgerName', fromJson: parseStringV2) String ledgerName,@JsonKey(name: 'subscriptionId', fromJson: parseStringV2) String? subscriptionId,@JsonKey(name: 'subscriptionName', fromJson: parseStringV2) String? subscriptionName,@JsonKey(name: 'billId', fromJson: parseStringV2) String? billId,@JsonKey(name: 'voucherTypeId', fromJson: parseStringV2) String voucherTypeId,@JsonKey(name: 'voucherTypeName', fromJson: parseStringV2) String voucherTypeName,@JsonKey(name: 'voucherNo', fromJson: parseStringV2) String voucherNo,@JsonKey(name: 'amount', fromJson: parseDoubleV2) double amount,@JsonKey(name: 'drCr', fromJson: parseStringV2) String drCr,@JsonKey(name: 'createdAt', fromJson: timestampFromJson, toJson: timestampToJson) Timestamp createdAt,@JsonKey(name: 'updatedAt', fromJson: timestampFromJson, toJson: timestampToJson) Timestamp updatedAt, bool isActive
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branchId = null,Object? companyId = null,Object? userId = null,Object? ledgerId = null,Object? ledgerName = null,Object? subscriptionId = freezed,Object? subscriptionName = freezed,Object? billId = freezed,Object? voucherTypeId = null,Object? voucherTypeName = null,Object? voucherNo = null,Object? amount = null,Object? drCr = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,}) {
  return _then(_TransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,ledgerId: null == ledgerId ? _self.ledgerId : ledgerId // ignore: cast_nullable_to_non_nullable
as String,ledgerName: null == ledgerName ? _self.ledgerName : ledgerName // ignore: cast_nullable_to_non_nullable
as String,subscriptionId: freezed == subscriptionId ? _self.subscriptionId : subscriptionId // ignore: cast_nullable_to_non_nullable
as String?,subscriptionName: freezed == subscriptionName ? _self.subscriptionName : subscriptionName // ignore: cast_nullable_to_non_nullable
as String?,billId: freezed == billId ? _self.billId : billId // ignore: cast_nullable_to_non_nullable
as String?,voucherTypeId: null == voucherTypeId ? _self.voucherTypeId : voucherTypeId // ignore: cast_nullable_to_non_nullable
as String,voucherTypeName: null == voucherTypeName ? _self.voucherTypeName : voucherTypeName // ignore: cast_nullable_to_non_nullable
as String,voucherNo: null == voucherNo ? _self.voucherNo : voucherNo // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,drCr: null == drCr ? _self.drCr : drCr // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

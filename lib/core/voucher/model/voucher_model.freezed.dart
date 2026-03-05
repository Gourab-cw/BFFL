// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'voucher_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoucherModel {

 String get id; String get suffix; String get prefix; String get branchId; List<String> get paymentMethods;@JsonKey(fromJson: parseIntV2) int get docTypeId; String get name; bool get isActive;
/// Create a copy of VoucherModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VoucherModelCopyWith<VoucherModel> get copyWith => _$VoucherModelCopyWithImpl<VoucherModel>(this as VoucherModel, _$identity);

  /// Serializes this VoucherModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VoucherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.suffix, suffix) || other.suffix == suffix)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&const DeepCollectionEquality().equals(other.paymentMethods, paymentMethods)&&(identical(other.docTypeId, docTypeId) || other.docTypeId == docTypeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,suffix,prefix,branchId,const DeepCollectionEquality().hash(paymentMethods),docTypeId,name,isActive);

@override
String toString() {
  return 'VoucherModel(id: $id, suffix: $suffix, prefix: $prefix, branchId: $branchId, paymentMethods: $paymentMethods, docTypeId: $docTypeId, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $VoucherModelCopyWith<$Res>  {
  factory $VoucherModelCopyWith(VoucherModel value, $Res Function(VoucherModel) _then) = _$VoucherModelCopyWithImpl;
@useResult
$Res call({
 String id, String suffix, String prefix, String branchId, List<String> paymentMethods,@JsonKey(fromJson: parseIntV2) int docTypeId, String name, bool isActive
});




}
/// @nodoc
class _$VoucherModelCopyWithImpl<$Res>
    implements $VoucherModelCopyWith<$Res> {
  _$VoucherModelCopyWithImpl(this._self, this._then);

  final VoucherModel _self;
  final $Res Function(VoucherModel) _then;

/// Create a copy of VoucherModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? suffix = null,Object? prefix = null,Object? branchId = null,Object? paymentMethods = null,Object? docTypeId = null,Object? name = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,suffix: null == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,paymentMethods: null == paymentMethods ? _self.paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<String>,docTypeId: null == docTypeId ? _self.docTypeId : docTypeId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VoucherModel].
extension VoucherModelPatterns on VoucherModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VoucherModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VoucherModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VoucherModel value)  $default,){
final _that = this;
switch (_that) {
case _VoucherModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VoucherModel value)?  $default,){
final _that = this;
switch (_that) {
case _VoucherModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String suffix,  String prefix,  String branchId,  List<String> paymentMethods, @JsonKey(fromJson: parseIntV2)  int docTypeId,  String name,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VoucherModel() when $default != null:
return $default(_that.id,_that.suffix,_that.prefix,_that.branchId,_that.paymentMethods,_that.docTypeId,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String suffix,  String prefix,  String branchId,  List<String> paymentMethods, @JsonKey(fromJson: parseIntV2)  int docTypeId,  String name,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _VoucherModel():
return $default(_that.id,_that.suffix,_that.prefix,_that.branchId,_that.paymentMethods,_that.docTypeId,_that.name,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String suffix,  String prefix,  String branchId,  List<String> paymentMethods, @JsonKey(fromJson: parseIntV2)  int docTypeId,  String name,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _VoucherModel() when $default != null:
return $default(_that.id,_that.suffix,_that.prefix,_that.branchId,_that.paymentMethods,_that.docTypeId,_that.name,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VoucherModel implements VoucherModel {
  const _VoucherModel({required this.id, required this.suffix, required this.prefix, required this.branchId, final  List<String> paymentMethods = const ['CASH'], @JsonKey(fromJson: parseIntV2) required this.docTypeId, required this.name, this.isActive = true}): _paymentMethods = paymentMethods;
  factory _VoucherModel.fromJson(Map<String, dynamic> json) => _$VoucherModelFromJson(json);

@override final  String id;
@override final  String suffix;
@override final  String prefix;
@override final  String branchId;
 final  List<String> _paymentMethods;
@override@JsonKey() List<String> get paymentMethods {
  if (_paymentMethods is EqualUnmodifiableListView) return _paymentMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_paymentMethods);
}

@override@JsonKey(fromJson: parseIntV2) final  int docTypeId;
@override final  String name;
@override@JsonKey() final  bool isActive;

/// Create a copy of VoucherModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VoucherModelCopyWith<_VoucherModel> get copyWith => __$VoucherModelCopyWithImpl<_VoucherModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VoucherModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VoucherModel&&(identical(other.id, id) || other.id == id)&&(identical(other.suffix, suffix) || other.suffix == suffix)&&(identical(other.prefix, prefix) || other.prefix == prefix)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&const DeepCollectionEquality().equals(other._paymentMethods, _paymentMethods)&&(identical(other.docTypeId, docTypeId) || other.docTypeId == docTypeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,suffix,prefix,branchId,const DeepCollectionEquality().hash(_paymentMethods),docTypeId,name,isActive);

@override
String toString() {
  return 'VoucherModel(id: $id, suffix: $suffix, prefix: $prefix, branchId: $branchId, paymentMethods: $paymentMethods, docTypeId: $docTypeId, name: $name, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$VoucherModelCopyWith<$Res> implements $VoucherModelCopyWith<$Res> {
  factory _$VoucherModelCopyWith(_VoucherModel value, $Res Function(_VoucherModel) _then) = __$VoucherModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String suffix, String prefix, String branchId, List<String> paymentMethods,@JsonKey(fromJson: parseIntV2) int docTypeId, String name, bool isActive
});




}
/// @nodoc
class __$VoucherModelCopyWithImpl<$Res>
    implements _$VoucherModelCopyWith<$Res> {
  __$VoucherModelCopyWithImpl(this._self, this._then);

  final _VoucherModel _self;
  final $Res Function(_VoucherModel) _then;

/// Create a copy of VoucherModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? suffix = null,Object? prefix = null,Object? branchId = null,Object? paymentMethods = null,Object? docTypeId = null,Object? name = null,Object? isActive = null,}) {
  return _then(_VoucherModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,suffix: null == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String,prefix: null == prefix ? _self.prefix : prefix // ignore: cast_nullable_to_non_nullable
as String,branchId: null == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String,paymentMethods: null == paymentMethods ? _self._paymentMethods : paymentMethods // ignore: cast_nullable_to_non_nullable
as List<String>,docTypeId: null == docTypeId ? _self.docTypeId : docTypeId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

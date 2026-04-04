// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MealPlanModel {

 String get htmlContent; String get fileName; DateTime? get updatedAt;
/// Create a copy of MealPlanModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealPlanModelCopyWith<MealPlanModel> get copyWith => _$MealPlanModelCopyWithImpl<MealPlanModel>(this as MealPlanModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealPlanModel&&(identical(other.htmlContent, htmlContent) || other.htmlContent == htmlContent)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,htmlContent,fileName,updatedAt);

@override
String toString() {
  return 'MealPlanModel(htmlContent: $htmlContent, fileName: $fileName, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MealPlanModelCopyWith<$Res>  {
  factory $MealPlanModelCopyWith(MealPlanModel value, $Res Function(MealPlanModel) _then) = _$MealPlanModelCopyWithImpl;
@useResult
$Res call({
 String htmlContent, String fileName, DateTime? updatedAt
});




}
/// @nodoc
class _$MealPlanModelCopyWithImpl<$Res>
    implements $MealPlanModelCopyWith<$Res> {
  _$MealPlanModelCopyWithImpl(this._self, this._then);

  final MealPlanModel _self;
  final $Res Function(MealPlanModel) _then;

/// Create a copy of MealPlanModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? htmlContent = null,Object? fileName = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
htmlContent: null == htmlContent ? _self.htmlContent : htmlContent // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MealPlanModel].
extension MealPlanModelPatterns on MealPlanModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealPlanModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealPlanModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealPlanModel value)  $default,){
final _that = this;
switch (_that) {
case _MealPlanModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealPlanModel value)?  $default,){
final _that = this;
switch (_that) {
case _MealPlanModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String htmlContent,  String fileName,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealPlanModel() when $default != null:
return $default(_that.htmlContent,_that.fileName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String htmlContent,  String fileName,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MealPlanModel():
return $default(_that.htmlContent,_that.fileName,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String htmlContent,  String fileName,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MealPlanModel() when $default != null:
return $default(_that.htmlContent,_that.fileName,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MealPlanModel extends MealPlanModel {
  const _MealPlanModel({required this.htmlContent, required this.fileName, this.updatedAt}): super._();
  

@override final  String htmlContent;
@override final  String fileName;
@override final  DateTime? updatedAt;

/// Create a copy of MealPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealPlanModelCopyWith<_MealPlanModel> get copyWith => __$MealPlanModelCopyWithImpl<_MealPlanModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealPlanModel&&(identical(other.htmlContent, htmlContent) || other.htmlContent == htmlContent)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,htmlContent,fileName,updatedAt);

@override
String toString() {
  return 'MealPlanModel(htmlContent: $htmlContent, fileName: $fileName, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MealPlanModelCopyWith<$Res> implements $MealPlanModelCopyWith<$Res> {
  factory _$MealPlanModelCopyWith(_MealPlanModel value, $Res Function(_MealPlanModel) _then) = __$MealPlanModelCopyWithImpl;
@override @useResult
$Res call({
 String htmlContent, String fileName, DateTime? updatedAt
});




}
/// @nodoc
class __$MealPlanModelCopyWithImpl<$Res>
    implements _$MealPlanModelCopyWith<$Res> {
  __$MealPlanModelCopyWithImpl(this._self, this._then);

  final _MealPlanModel _self;
  final $Res Function(_MealPlanModel) _then;

/// Create a copy of MealPlanModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? htmlContent = null,Object? fileName = null,Object? updatedAt = freezed,}) {
  return _then(_MealPlanModel(
htmlContent: null == htmlContent ? _self.htmlContent : htmlContent // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

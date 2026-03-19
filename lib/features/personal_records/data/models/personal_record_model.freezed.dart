// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personal_record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PersonalRecord {

 String get id; String get exerciseName; double get weightKg; int get reps; DateTime get date; String? get note;
/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalRecordCopyWith<PersonalRecord> get copyWith => _$PersonalRecordCopyWithImpl<PersonalRecord>(this as PersonalRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,exerciseName,weightKg,reps,date,note);

@override
String toString() {
  return 'PersonalRecord(id: $id, exerciseName: $exerciseName, weightKg: $weightKg, reps: $reps, date: $date, note: $note)';
}


}

/// @nodoc
abstract mixin class $PersonalRecordCopyWith<$Res>  {
  factory $PersonalRecordCopyWith(PersonalRecord value, $Res Function(PersonalRecord) _then) = _$PersonalRecordCopyWithImpl;
@useResult
$Res call({
 String id, String exerciseName, double weightKg, int reps, DateTime date, String? note
});




}
/// @nodoc
class _$PersonalRecordCopyWithImpl<$Res>
    implements $PersonalRecordCopyWith<$Res> {
  _$PersonalRecordCopyWithImpl(this._self, this._then);

  final PersonalRecord _self;
  final $Res Function(PersonalRecord) _then;

/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? exerciseName = null,Object? weightKg = null,Object? reps = null,Object? date = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalRecord].
extension PersonalRecordPatterns on PersonalRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalRecord value)  $default,){
final _that = this;
switch (_that) {
case _PersonalRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String exerciseName,  double weightKg,  int reps,  DateTime date,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
return $default(_that.id,_that.exerciseName,_that.weightKg,_that.reps,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String exerciseName,  double weightKg,  int reps,  DateTime date,  String? note)  $default,) {final _that = this;
switch (_that) {
case _PersonalRecord():
return $default(_that.id,_that.exerciseName,_that.weightKg,_that.reps,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String exerciseName,  double weightKg,  int reps,  DateTime date,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _PersonalRecord() when $default != null:
return $default(_that.id,_that.exerciseName,_that.weightKg,_that.reps,_that.date,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _PersonalRecord extends PersonalRecord {
  const _PersonalRecord({required this.id, required this.exerciseName, required this.weightKg, required this.reps, required this.date, this.note}): super._();
  

@override final  String id;
@override final  String exerciseName;
@override final  double weightKg;
@override final  int reps;
@override final  DateTime date;
@override final  String? note;

/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalRecordCopyWith<_PersonalRecord> get copyWith => __$PersonalRecordCopyWithImpl<_PersonalRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.reps, reps) || other.reps == reps)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,exerciseName,weightKg,reps,date,note);

@override
String toString() {
  return 'PersonalRecord(id: $id, exerciseName: $exerciseName, weightKg: $weightKg, reps: $reps, date: $date, note: $note)';
}


}

/// @nodoc
abstract mixin class _$PersonalRecordCopyWith<$Res> implements $PersonalRecordCopyWith<$Res> {
  factory _$PersonalRecordCopyWith(_PersonalRecord value, $Res Function(_PersonalRecord) _then) = __$PersonalRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String exerciseName, double weightKg, int reps, DateTime date, String? note
});




}
/// @nodoc
class __$PersonalRecordCopyWithImpl<$Res>
    implements _$PersonalRecordCopyWith<$Res> {
  __$PersonalRecordCopyWithImpl(this._self, this._then);

  final _PersonalRecord _self;
  final $Res Function(_PersonalRecord) _then;

/// Create a copy of PersonalRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? exerciseName = null,Object? weightKg = null,Object? reps = null,Object? date = null,Object? note = freezed,}) {
  return _then(_PersonalRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,weightKg: null == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double,reps: null == reps ? _self.reps : reps // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
